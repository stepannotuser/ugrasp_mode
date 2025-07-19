## /*
##  * This file is part of the AEDVICES Simplified Edition.
##  *
##  * Copyright (c) 2025 AEDVICES Consulting SAS. All rights reserved.
##  *
##  * Licensed under the AEDVICES-SE-v1.0 (Public Use License - Simplified Edition).
##  * You may use, copy, and modify this file for personal/internal use only.
##  * Redistribution or commercial use is prohibited without a separate license.
##  *
##  * See LICENSE.txt or contact contact@aedvices.com for more information.
##  */

.PHONY:
gen: 
	python3 ../../svgraph.py -in_csv sw_control.csv -out_dir sw_control/src/sv -classname sw_control -gen_uvm -first_state Idle -per_instance no -gen_dot -gen_dot_full

.PHONY:
clean:
	rm -rf sw_control/src/sv