#!/usr/bin/env bash

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EX_DIR="$REPO_ROOT/examples/0-get_started"
VIP_PKG="$EX_DIR/simple_vip_pkg/src/sv/simple_vip_pkg.sv"
CSV="$EX_DIR/my_fsm.csv"

STRATEGY="${1:-edges}"
START="${2:-IDLE}"

if [ "$STRATEGY" = "random" ]; then
    echo "edges, dfs or postman"
    exit 1
fi

GEN_DIR="/tmp/test/my_fsm_${STRATEGY}"
BUILD_DIR="/tmp/build_my_fsm_${STRATEGY}"

# ---------- 1. Генерация ----------
echo "[1/4] Генерация пакета через ugrasp (strategy=$STRATEGY)..."
rm -rf "$GEN_DIR"
python3 "$REPO_ROOT/ugrasp.py" \
    -in_csv "$CSV" \
    -out_dir "$GEN_DIR" \
    -classname my_fsm \
    -gen_uvm \
    -first_state "$START" \
    -per_instance no \
    -strategy "$STRATEGY"

# ---------- 2. Сборка ----------
echo "[2/4] Сборка в $BUILD_DIR ..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

vlib work > /dev/null
vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv          > /dev/null
vlog -sv +incdir+$UVM_HOME/src "$VIP_PKG"                        > /dev/null
vlog -sv +incdir+$UVM_HOME/src "$GEN_DIR/my_fsm_pkg.sv"          > /dev/null

# Готовим testbench через sed: my_fsm -> my_fsm, module tb_auto -> module tb_my_fsm
sed -e 's/module tb_auto/module tb_my_fsm/' \
    "$REPO_ROOT/new_code/tb_auto_integration.sv" > tb_my_fsm.sv
vlog -sv +incdir+$UVM_HOME/src +define+AUTOMATON tb_my_fsm.sv    > /dev/null

# ---------- 3. Симуляция ----------
echo "[3/4] Симуляция..."
vsim -c -sv_lib $UVM_DPI -do "run -all; quit -f" tb_my_fsm > sim.log 2>&1

# ---------- 4. Отчёт ----------
echo "[4/4] Результаты:"
echo "----------------------------------------"
grep -E "\[AUTOMATON\]|nr of iterations|UVM_ERROR|UVM_FATAL" sim.log | sed 's/^# //'
echo "----------------------------------------"
