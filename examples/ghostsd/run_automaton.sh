#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

STRATEGY="${1:-edges}"
START="${2:-IDLE}"

if [ "$STRATEGY" = "random" ]; then
    SEQ=ghostsd_user_sequence
    DEF=""
    USR=""
else
    SEQ=ghostsd_automaton_sequence
    DEF="+define+AUTOMATON"
    USR="-user_sequence ghostsd_user_sequence"
fi

export UVM_HOME=/home/step/Questa_Sim/questasim/verilog_src/uvm-1.2
export UVM_DPI=/home/step/Questa_Sim/questasim/uvm-1.2/linux_x86_64/uvm_dpi
export QUESTA=/home/step/Questa_Sim/questasim/linux_x86_64

cp ghostsd_test_pkg/src/sv/ghostsd_user_sequence.svh ghostsd_pkg/src/sv/

python3 ../../ugrasp.py \
    -in_csv ghostsd_fsm.csv \
    -out_dir ghostsd_pkg/src/sv \
    -classname ghostsd \
    -gen_uvm \
    -first_state "$START" \
    -per_instance yes \
    -strategy "$STRATEGY" \
    -sequence_item simple_vip_sequence_item \
    -import_package simple_vip_pkg \
    $USR

if [ "$STRATEGY" = "random" ]; then
    sed -i 's|`include "ghostsd_sequence.svh"|`include "ghostsd_sequence.svh"\n`include "ghostsd_user_sequence.svh"|' \
        ghostsd_pkg/src/sv/ghostsd_pkg.sv
fi

rm -rf work
$QUESTA/vlib work
$QUESTA/vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src ../0-get_started/simple_vip_pkg/src/sv/simple_vip_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src ghostsd_pkg/src/sv/ghostsd_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src $DEF ghostsd_test_pkg/src/sv/ghostsd_test_pkg.sv
sed -e "s/ghostsd_automaton_sequence/$SEQ/g" \
    -e "s/ghostsd_sequence/$SEQ/g" \
    tb/src/sv/tb.sv > tb_ghostsd.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src $DEF tb_ghostsd.sv
$QUESTA/vsim -c -sv_lib $UVM_DPI -do "run -all; quit -f" tb > sim.log 2>&1

grep -nE "AUTOMATON|nr of iterations|coverage:|UVM_ERROR|UVM_FATAL" sim.log | sed 's/^# //'
    
if grep -qE "UVM_(ERROR|FATAL) :\s+[1-9]" sim.log; then
    echo "error"
    exit 1
fi 
echo "no error"
