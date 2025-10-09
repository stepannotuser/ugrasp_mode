  //--------------------------------------------------------------
  // Simple Driver
  //--------------------------------------------------------------
  class simple_vip_driver extends uvm_driver#(simple_vip_sequence_item);
    `uvm_component_utils(simple_vip_driver)

    function new(string name = "simple_vip_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new


    // Main run task
    virtual task run_phase(uvm_phase phase);
      simple_vip_sequence_item req;
      forever begin
        // Get the next item from the sequencer
        seq_item_port.get_next_item(req);
        // mimic driving
        req.print();
        #10ns;
        // Indicate to the sequencer that the item is done
        seq_item_port.item_done();
      end
    endtask : run_phase
  endclass : simple_vip_driver

