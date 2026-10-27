#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"

STRATEGIES=("$@")
[[ ${#STRATEGIES[@]} -eq 0 ]] && STRATEGIES=(random dfs edges postman)

FIRST_STATE="${FIRST_STATE:-Detect}"
PRE_RUN="${PRE_RUN:-starting}"
PER_INSTANCE="${PER_INSTANCE:-no}"
CLASSNAME="pcie_link_training"

EXAMPLE_DIR="$PWD"
REPO_ROOT="$(cd "$EXAMPLE_DIR/../.." && pwd)"
SVGRAPH="$REPO_ROOT/ugrasp.py"
CSV="$EXAMPLE_DIR/link_training.csv"
TB="$EXAMPLE_DIR/tb.sv"

BUILD="$EXAMPLE_DIR/build"
LOG_DIR="$EXAMPLE_DIR/logs"
LOG="$LOG_DIR/regression.log"

mkdir -p "$BUILD" "$LOG_DIR"
: > "$LOG"

: "${QUESTA:?export QUESTA=/path/to/questasim/bin}"
: "${UVM_HOME:?export UVM_HOME=/path/to/uvm-1.2}"
: "${UVM_DPI:?export UVM_DPI=$UVM_HOME/lib/uvm_dpi}"

[[ -f "$SVGRAPH" ]] || { echo "missing: $SVGRAPH" >&2; exit 1; }
[[ -f "$CSV"     ]] || { echo "missing: $CSV"     >&2; exit 1; }
[[ -f "$TB"      ]] || { echo "missing: $TB"      >&2; exit 1; }

if [[ -x "$REPO_ROOT/.venv/bin/python3" ]]; then
    PY="$REPO_ROOT/.venv/bin/python3"
else
    PY="$(command -v python3)"
fi

"$PY" -c 'import networkx' 2>/dev/null \
    || { echo "pip install networkx" >&2; exit 1; }

parse_num() {
    local file=$1 pat=$2 v
    v=$(grep -E "$pat" "$file" 2>/dev/null | tail -1 | grep -oE '[0-9]+' | tail -1)
    echo "${v:-0}"
}

declare -A STATE TRANS TOTAL ITERS WALK WARN STATUS

run_all() {
    echo "=== regression start: $(date) ==="
    echo "  strategies : ${STRATEGIES[*]}"
    echo "  first      : $FIRST_STATE"
    echo "  pre_run    : $PRE_RUN"
    echo "  per_inst   : $PER_INSTANCE"
    echo "  log        : $LOG"
    echo

    local t0 t1 strategy gen sim pkg tfile
    t0=$(date +%s)

    for strategy in "${STRATEGIES[@]}"; do
        echo
        echo "──── [$strategy] ─────────────────────────────────────────────"

        gen="$BUILD/generated/${CLASSNAME}_${strategy}"
        sim="$BUILD/sim/${CLASSNAME}_${strategy}"
        rm -rf "$gen" "$sim"
        mkdir -p "$gen" "$sim"

        echo "  generating..."
        if ! "$PY" "$SVGRAPH" \
            -in_csv "$CSV" \
            -out_dir "$gen" \
            -classname "$CLASSNAME" \
            -gen_uvm -gen_dot -gen_dot_full \
            -first_state "$FIRST_STATE" \
            -pre_run_state_name "$PRE_RUN" \
            -per_instance "$PER_INSTANCE" \
            -strategy "$strategy"; then
            STATUS[$strategy]="FAIL(gen)"
            continue
        fi

        pkg="$gen/${CLASSNAME}_pkg.sv"
        [[ -f "$pkg" ]] || { STATUS[$strategy]="FAIL(gen)"; continue; }

        echo "  compiling..."
        cd "$sim"
        if ! "$QUESTA/vlib" work \
          || ! "$QUESTA/vlog" -sv -timescale 1ns/1ps +incdir+"$UVM_HOME/src" \
                "$UVM_HOME/src/uvm_pkg.sv" \
          || ! "$QUESTA/vlog" -sv -timescale 1ns/1ps +incdir+"$UVM_HOME/src" \
                "$pkg" \
          || ! "$QUESTA/vlog" -sv -timescale 1ns/1ps +incdir+"$UVM_HOME/src" \
                "$TB"; then
            STATUS[$strategy]="FAIL(compile)"
            cd "$EXAMPLE_DIR"
            continue
        fi

        echo "  simulating..."
        if ! "$QUESTA/vsim" -c -sv_lib "$UVM_DPI" \
                -do "run -all; quit -f" tb; then
            STATUS[$strategy]="FAIL(sim)"
            cd "$EXAMPLE_DIR"
            continue
        fi
        cd "$EXAMPLE_DIR"

        tfile="$sim/transcript"
        [[ -f "$tfile" ]] || tfile="$sim/vsim.log"

        STATE[$strategy]=$(parse_num "$tfile" 'state[[:space:]]+coverage')
        TRANS[$strategy]=$(parse_num "$tfile" 'transition[[:space:]]+coverage')
        TOTAL[$strategy]=$(parse_num "$tfile" 'Total[[:space:]]+coverage')
        ITERS[$strategy]=$(parse_num "$tfile" 'nr of iterations')
        WALK[$strategy]=$(grep -oE 'walk: [0-9]+' "$tfile" 2>/dev/null \
                          | tail -1 | grep -oE '[0-9]+' || true)
        WARN[$strategy]=$(grep -cE '\*\* Warning' "$tfile" 2>/dev/null || true)
        : "${WALK[$strategy]:=-}"
        : "${WARN[$strategy]:=0}"

        if [[ ${STATE[$strategy]} -ge 100 \
           && ${TRANS[$strategy]} -ge 100 \
           && ${TOTAL[$strategy]} -ge 100 ]]; then
            STATUS[$strategy]="PASS"
        else
            STATUS[$strategy]="FAIL(cov)"
        fi

        echo "  -> state=${STATE[$strategy]}%  trans=${TRANS[$strategy]}%  total=${TOTAL[$strategy]}%  iters=${ITERS[$strategy]}  walk=${WALK[$strategy]}  ${STATUS[$strategy]}"
    done

    t1=$(date +%s)

    local failed=0 passed=0 s
    for s in "${STRATEGIES[@]}"; do
        if [[ "${STATUS[$s]:-}" == "PASS" ]]; then passed=$((passed+1)); else failed=$((failed+1)); fi
    done

    echo
    echo "═══════════════════════════════════════════════════════════════════"
    echo "  REGRESSION SUMMARY"
    echo "═══════════════════════════════════════════════════════════════════"
    printf "%-10s %8s %6s %8s %10s %8s %6s %-12s\n" \
        "Strategy" "Iters" "Walk" "State" "Trans" "Total" "Warn" "Status"
    printf "%-10s %8s %6s %8s %10s %8s %6s %-12s\n" \
        "--------" "-----" "----" "-----" "-----" "-----" "----" "------"
    for s in "${STRATEGIES[@]}"; do
        printf "%-10s %8s %6s %7s%% %9s%% %7s%% %6s %-12s\n" \
            "$s" "${ITERS[$s]:-0}" "${WALK[$s]:--}" \
            "${STATE[$s]:-0}" "${TRANS[$s]:-0}" "${TOTAL[$s]:-0}" \
            "${WARN[$s]:-0}" "${STATUS[$s]:-?}"
    done
    echo
    echo "  log     : $LOG"
    echo "  build   : $BUILD"
    echo "  elapsed : $((t1 - t0))s"
    echo "  passed  : $passed / ${#STRATEGIES[@]}"
    if [[ $failed -gt 0 ]]; then
        echo "  RESULT  : FAILED ($failed failed)"
        return 1
    fi
    echo "  RESULT  : PASSED"
    return 0
}

run_all 2>&1 | tee -a "$LOG"
exit "${PIPESTATUS[0]}"
