// Файл: tb_my_fsm.sv
module tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import my_fsm_pkg::*;
  import my_path_seq_sv_unit::*;   // импортируем пакет, где определён my_path_seq

  // Простой секвенсор
  class my_sequencer extends uvm_sequencer;
    `uvm_component_utils(my_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    my_sequencer sequencer;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = my_sequencer::type_id::create("sequencer", this);
    endfunction

    task run_phase(uvm_phase phase);
      my_path_seq seq;
      phase.raise_objection(this);
      seq = my_path_seq::type_id::create("seq");
      assert(seq.randomize());
      seq.start(sequencer);
      phase.drop_objection(this);
    endtask
  endclass

  initial begin
    run_test("my_test");
  end
endmodule
