  //--------------------------------------------------------------
  // Simple Sequence Item.
  //--------------------------------------------------------------
  class simple_vip_sequence_item extends uvm_tlm_generic_payload;
    `uvm_object_utils(simple_vip_sequence_item)

    function new(string name = "simple_vip_sequence_item");
      super.new(name);
    endfunction : new
  endclass : simple_vip_sequence_item

