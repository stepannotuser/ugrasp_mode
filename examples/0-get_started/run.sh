#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

#пока так
#export QUESTA=/путь/к/questasim/linux_x86_64
#export UVM_HOME=/путь/к/questasim/verilog_src/uvm-1.2
#export UVM_DPI=/путь/к/questasim/uvm-1.2/linux_x86_64/uvm_dpi

# 1) генерация
python3 ../../ugrasp.py \
    -in_csv my_fsm.csv \
    -out_dir my_fsm_pkg/src/sv \
    -classname my_fsm \
    -gen_uvm \
    -first_state IDLE \
    -per_instance no \
    -gen_dot \
    -gen_dot_full \
    -sequence_item simple_vip_sequence_item \
    -import_package simple_vip_pkg

# 2) компиляция
rm -rf work
$QUESTA/vlib work
$QUESTA/vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src simple_vip_pkg/src/sv/simple_vip_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src my_fsm_pkg/src/sv/my_fsm_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src my_test_pkg/src/sv/my_test_pkg.sv
$QUESTA/vlog -sv +incdir+$UVM_HOME/src tb/src/sv/tb.sv

# 3) запуск
$QUESTA/vsim -c -sv_lib $UVM_DPI -do "run -all; quit -f" tb
