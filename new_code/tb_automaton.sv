`include "uvm_macros.svh"
import uvm_pkg::*;
import simple_vip_pkg::*;
import my_fsm_pkg::*;
import my_test_pkg::*;
import my_automaton_pkg::*;

class automaton_test extends uvm_test;
  `uvm_component_utils(automaton_test)

  simple_vip_agent vip_agent;

  function new(string name = "automaton_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vip_agent = simple_vip_agent::type_id::create("vip_agent", this);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    my_fsm_automaton_sequence seq;
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting automaton_test", UVM_LOW)

    seq = my_fsm_automaton_sequence::type_id::create("seq");

    if (!seq.randomize()) `uvm_fatal(get_type_name(), "randomize failed")

    seq.set_state_at_least(1);
    seq.set_transition_at_least(1);

    seq.start(vip_agent.sequencer);
    //#100ns; 

    `uvm_info("AUTOMATON",
      $sformatf("State coverage:      %0.2f%%", seq.get_state_coverage()), UVM_LOW)
    `uvm_info("AUTOMATON",
      $sformatf("Transition coverage: %0.2f%%", seq.get_transition_coverage()), UVM_LOW)
    `uvm_info("AUTOMATON",
      $sformatf("Total coverage:      %0.2f%%", seq.get_total_coverage()), UVM_LOW)

    `uvm_info(get_type_name(), "Ending automaton_test", UVM_LOW)

    phase.drop_objection(this);
  endtask : run_phase
endclass

module tb_automaton;
  initial run_test("automaton_test");
endmodule
