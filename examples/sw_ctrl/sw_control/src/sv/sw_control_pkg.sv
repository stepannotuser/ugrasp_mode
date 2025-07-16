// SVGraph sw_control
// File    sw_control_pkg.sv

package sw_control_pkg;

  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  `include "sw_control_types.svh"
  `include "sw_control_covergroups.svh"
  
  `include "sw_control_base_sequence.svh"
  `include "sw_control_sequence.svh"
  `include "sw_control_checker.svh"
  
  `include "sw_control_base_sequence.sv"
  `include "sw_control_sequence.sv"
  `include "sw_control_checker.sv"

endpackage : sw_control_pkg

