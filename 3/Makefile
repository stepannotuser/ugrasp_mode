CLASSNAME   ?= my_fsm
IN_CSV      ?= my_fsm.csv
OUT_DIR     ?= $(CLASSNAME)_pkg/src/sv
FIRST_STATE ?= IDLE
END_STATE   ?= __END__
START_STATE ?= __START__
USER_SEQ_FILE ?= my_path_seq.sv
TB_FILE     ?= tb_my_fsm.sv               

UGRASP   ?= python3 ../ugrasp.py

SV_FILES  = $(OUT_DIR)/$(CLASSNAME)_pkg.sv \
            $(USER_SEQ_FILE) \
            $(TB_FILE)

.PHONY: all gen compile run clean vars

all: gen compile run

gen:
	@echo "=== Generating $(CLASSNAME) package from $(IN_CSV) ==="
	mkdir -p $(OUT_DIR)
	$(UGRASP) -in_csv $(IN_CSV) \
	          -out_dir $(OUT_DIR) \
	          -classname $(CLASSNAME) \
	          -gen_uvm \
	          -first_state $(FIRST_STATE) \
	          -per_instance no \
	          -gen_dot \
	          -gen_dot_full \
	          -post_run_state_name $(END_STATE) \
	          -pre_run_state_name $(START_STATE)
	@echo "=== Generation done ==="

compile: gen
	@echo "=== Compiling with Questa ==="
	vlog -work work +incdir+$(OUT_DIR) $(SV_FILES)

run: compile
	@echo "=== Running simulation ==="
	vsim -c work.tb -do "run -all; quit"

clean:
	@echo "=== Cleaning ==="
	rm -rf work *.wlf transcript vsim.wlf $(CLASSNAME)_pkg
	rm -f *.log

vars:
	@echo "CLASSNAME = $(CLASSNAME)"
	@echo "IN_CSV    = $(IN_CSV)"
	@echo "OUT_DIR   = $(OUT_DIR)"
	@echo "FIRST_STATE = $(FIRST_STATE)"
	@echo "END_STATE = $(END_STATE)"
	@echo "START_STATE = $(START_STATE)"
	@echo "USER_SEQ_FILE = $(USER_SEQ_FILE)"
	@echo "TB_FILE   = $(TB_FILE)"
