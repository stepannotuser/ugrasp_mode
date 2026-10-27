// This file is part of the AEDVICES Simplified Edition.
//
// Copyright (c) 2025 AEDVICES Consulting SAS. All rights reserved.
//
// Licensed under the AEDVICES-SE-v1.0 (Public Use License - Simplified Edition).
// You may use, copy, and modify this file for personal/internal use only.
// Redistribution or commercial use is prohibited without a separate license.
//
// See LICENSE.txt or contact contact@aedvices.com for more information.
//


package ghostsd_test_pkg;

  // Package imports
  import uvm_pkg::*;
  import simple_vip_pkg::*;
  import ghostsd_pkg::*;
  `include "uvm_macros.svh"
//  `include "ghostsd_user_sequence.svh"
  
  class ghostsd extends uvm_test;
    `uvm_component_utils(ghostsd)
    
    simple_vip_agent vip_agent;

    // constructor
    function new(string name = "ghostsd", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    // Build phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//
`ifdef AUTOMATON
      ghostsd_user_sequence::type_id::set_type_override(
          ghostsd_automaton_sequence::get_type());
`endif
      vip_agent = simple_vip_agent::type_id::create("vip_agent", this);
    endfunction
//      vip_agent = simple_vip_agent::type_id::create("vip_agent", this);
//    endfunction : build_phase

    // Run Phase
    virtual task run_phase(uvm_phase phase);
      ghostsd_user_sequence my_seq = ghostsd_user_sequence::type_id::create("my_seq");
      phase.raise_objection(this);
    
      `uvm_info(get_type_name(), "Starting ghostsd run_phase", UVM_LOW)
      
      assert (
        my_seq.randomize() with { 
          max_iter == 1000; //20000
          coverage_default_edge_at_least == 1;
          coverage_closure_en == 1; 
        }
      ) else `uvm_fatal(get_type_name(), "Failed to randomize ghostsd");
      
      my_seq.start(vip_agent.sequencer);
      #100ns; // Simulate some activity

      `uvm_info(get_type_name(), "Ending ghostsd run_phase", UVM_LOW)
    
      phase.drop_objection(this);
    endtask : run_phase


endclass : ghostsd


endpackage : ghostsd_test_pkg
