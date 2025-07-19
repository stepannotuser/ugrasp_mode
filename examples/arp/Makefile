
.PHONY: arp_pkg
arp_pkg: arp_pkg/src/sv/arp_pkg.sv 

arp_pkg/src/sv/arp_pkg.sv: Makefile arp.csv
	python3 ../../svgraph.py -in_csv arp.csv -out_dir arp_pkg/src/sv -classname arp -gen_uvm -first_state Idle -per_instance no -gen_dot -gen_dot_full

gen: arp_pkg

clean:
	rm -rf arp_pkg


.PHONY: run
run: arp_pkg
	vlog +acc arp_pkg/src/sv/arp_pkg.sv 
	vlog +acc tb.sv
	vsim tb
