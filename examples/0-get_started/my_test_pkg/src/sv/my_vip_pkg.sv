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

package simple_vip_pkg;

  // Package imports
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //--------------------------------------------------------------
  // Simple Sequence Item.
  //--------------------------------------------------------------
  class simple_vip_sequence_item extends uvm_tlm_generic_payload;
    `uvm_object_utils(simple_vip_sequence_item)

    function new(string name = "simple_vip_sequence_item");
      super.new(name);
    endfunction : new
  endclass : simple_vip_sequence_item

  //--------------------------------------------------------------
  // Simple Driver
  //--------------------------------------------------------------
  class simple_vip_driver extends uvm_driver#(simple_vip_sequence_item);
    `uvm_component_utils(simple_vip_driver)

    function new(string name = "simple_vip_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new
  endclass : simple_vip_driver

  //--------------------------------------------------------------
  // Simple Sequencer
  //--------------------------------------------------------------
  class simple_vip_sequencer extends uvm_sequencer#(simple_vip_sequence_item);
    `uvm_component_utils(simple_vip_sequencer)

    function new(string name = "simple_vip_sequencer", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new
  endclass : simple_vip_sequencer

  //--------------------------------------------------------------
  // Simple Agent
  //--------------------------------------------------------------
  class simple_vip_agent extends uvm_agent;
    `uvm_component_utils(simple_vip_agent)
    simple_vip_driver driver ;
    simple_vip_sequencer sequencer;

    function new(string name = "simple_vip_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    // Build phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = simple_vip_driver::type_id::create("driver", this);
      sequencer = simple_vip_sequencer::type_id::create("sequencer", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

  endclass : simple_vip_agent


endpackage : simple_vip_pkg