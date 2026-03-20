

.PHONY: gen
gen: 
	python3 ../../svgraph.py -in_csv link_training.csv -out_dir pcie_link_training_pkg/src/sv -classname pcie_link_training -gen_uvm -first_state Detect -per_instance no -gen_dot -gen_dot_full
	python3 ../../svgraph.py -in_csv pcie_link_polling.csv -out_dir pcie_link_polling_pkg/src/sv -classname pcie_link_polling -gen_uvm -first_state Entry_from_Detect -per_instance no -gen_dot -gen_dot_full

clean:
	rm -rf pcie_link_training_pkg pcie_link_polling_pkg


.PHONY: run
run: pcie_link_training_pkg
	vlog +acc pcie_link_training_pkg/src/sv/pcie_link_training_pkg.sv 
	vlog +acc tb.sv
	vsim tb
