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


package my_test_pkg;

  // Package imports
  import uvm_pkg::*;
  import simple_vip_pkg::*;
  `include "uvm_macros.svh"
  
  class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    simple_vip_agent vip_agent;

    // constructor
    function new(string name = "my_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    // Build phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      vip_agent = simple_vip_agent::type_id::create("vip_agent", this);
    endfunction : build_phase

    // Run Phase
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
    
      `uvm_info(get_type_name(), "Starting my_test run_phase", UVM_LOW)
      // Add your test stimulus here
      #100ns; // Simulate some activity
      `uvm_info(get_type_name(), "Ending my_test run_phase", UVM_LOW)
    
      phase.drop_objection(this);
    endtask : run_phase


endclass : my_test

  


endpackage : my_test_pkg