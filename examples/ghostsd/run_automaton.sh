#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GHOSTSD_DIR="$REPO_ROOT/examples/ghostsd"
VIP_PKG="$REPO_ROOT/examples/0-get_started/simple_vip_pkg/src/sv/simple_vip_pkg.sv"
CSV="$GHOSTSD_DIR/ghostsd_fsm.csv"

STRATEGY="${1:-edges}"
START="${2:-IDLE}"

GEN_DIR="$REPO_ROOT/build/generated/ghostsd_${STRATEGY}"
BUILD_DIR="$REPO_ROOT/build/sim/ghostsd_${STRATEGY}"

if [ "$STRATEGY" = "random" ]; then
    SEQ_CLASS="ghostsd_sequence"
    DEFINE=""
else
    SEQ_CLASS="ghostsd_automaton_sequence"
    DEFINE="+define+AUTOMATON"
fi

rm -rf "$GEN_DIR"
python3 "$REPO_ROOT/ugrasp.py" \
    -in_csv "$CSV" \
    -out_dir "$GEN_DIR" \
    -classname ghostsd \
    -gen_uvm \
    -first_state "$START" \
    -per_instance no \
    -strategy "$STRATEGY"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

vlib work
vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv
vlog -sv +incdir+$UVM_HOME/src "$VIP_PKG"
vlog -sv +incdir+$UVM_HOME/src "$GEN_DIR/ghostsd_pkg.sv"

sed -e "s/my_fsm_automaton_sequence/$SEQ_CLASS/g" \
    -e "s/my_fsm_sequence/$SEQ_CLASS/g" \
    -e "s/my_fsm/ghostsd/g" \
    -e "s/module tb_auto/module tb_ghostsd/" \
    "$REPO_ROOT/new_code/tb_auto_integration.sv" > tb_ghostsd.sv
vlog -sv +incdir+$UVM_HOME/src $DEFINE tb_ghostsd.sv > /dev/null

vsim -c -sv_lib $UVM_DPI -do "run -all; quit -f" tb_ghostsd > sim.log 2>&1

echo "[$STRATEGY]"
grep -nE "AUTOMATON|nr of iterations|coverage:|UVM_ERROR|UVM_FATAL" sim.log | sed 's/^# //'
