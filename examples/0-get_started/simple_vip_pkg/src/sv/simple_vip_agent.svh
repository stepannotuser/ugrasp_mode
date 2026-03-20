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
