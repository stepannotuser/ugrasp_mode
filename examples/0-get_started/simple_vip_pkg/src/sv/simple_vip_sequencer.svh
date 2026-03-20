  //--------------------------------------------------------------
  // Simple Sequencer
  //--------------------------------------------------------------
  class simple_vip_sequencer extends uvm_sequencer#(simple_vip_sequence_item);
    `uvm_component_utils(simple_vip_sequencer)

    function new(string name = "simple_vip_sequencer", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new
  endclass : simple_vip_sequencer
