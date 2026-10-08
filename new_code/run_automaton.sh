#!/usr/bin/env bash

set -e

MODE="${1:-edges}"
START="${2:-IDLE}"

CLASSNAME="my_fsm"
CSV="examples/0-get_started/my_fsm.csv"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EX_DIR="$REPO_ROOT/examples/0-get_started"
NEW_CODE="$REPO_ROOT/new_code"

if [ -z "$UVM_HOME" ] || [ -z "$UVM_DPI" ]; then
  echo "UVM_HOME/UVM_DPI не заданы."
  echo "source ~/.bashrc"
  exit 1
fi

if ! command -v vlog >/dev/null || ! command -v vsim >/dev/null; then
  echo "vlog/vsim не найдены в PATH."
  exit 1
fi


echo "генерация SV-класса из walk..."
cd "$REPO_ROOT"
python3 new_code/walk_to_sv.py "$CSV" "$MODE" "$CLASSNAME" "$START"
cp new_code/output/${CLASSNAME}_automaton_sequence.svh new_code/
echo ""

echo "удаление"
cd "$EX_DIR"
rm -rf work
mkdir -p work
echo ""

echo "компиляция..."
vlib work > /dev/null
vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv          > /tmp/vlog1.log 2>&1
vlog -sv +incdir+$UVM_HOME/src simple_vip_pkg/src/sv/simple_vip_pkg.sv > /tmp/vlog2.log 2>&1
vlog -sv +incdir+$UVM_HOME/src my_fsm_pkg/src/sv/my_fsm_pkg.sv    > /tmp/vlog3.log 2>&1
vlog -sv +incdir+$UVM_HOME/src my_test_pkg/src/sv/my_test_pkg.sv  > /tmp/vlog4.log 2>&1
vlog -sv +incdir+$UVM_HOME/src ../../new_code/my_automaton_pkg.sv > /tmp/vlog5.log 2>&1
vlog -sv +incdir+$UVM_HOME/src ../../new_code/tb_automaton.sv     > /tmp/vlog6.log 2>&1

for f in /tmp/vlog*.log; do
  errs=$(grep -oP 'Errors: \K\d+' "$f" | tail -1)
  if [ "$errs" != "0" ]; then
    echo "ошибка компиляции в $f:"
    cat "$f"
    exit 1
  fi
done
echo "ошибок нет"
echo ""

LOG="$NEW_CODE/sim_automaton.log"
echo "симуляция..."
vsim -c -sv_lib $UVM_DPI -do "run -all; quit -f" tb_automaton > "$LOG" 2>&1
echo "лог сохранён: $LOG"
echo ""

echo "результаты:"
echo "----------------------------------------"
grep -E "\[AUTOMATON\]|nr of iterations|UVM_ERROR|UVM_FATAL" "$LOG" \
  | sed 's/^# //' \
  | sed 's/.*\[AUTOMATON\]/[AUTOMATON]/'
echo "----------------------------------------"
echo ""
echo "Walk (из Python):"
cd "$REPO_ROOT"
python3 "$NEW_CODE/dfs_traversal.py" "$CSV" "$MODE" "$START" | tail -3
echo ""
echo "готово."
