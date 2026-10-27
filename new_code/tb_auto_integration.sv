`include "uvm_macros.svh"
import uvm_pkg::*;
import simple_vip_pkg::*;
import my_fsm_pkg::*;

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
`ifdef AUTOMATON
    my_fsm_automaton_sequence seq;
`else
    my_fsm_sequence seq;             // родительский, с randsequence
`endif
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test", UVM_LOW)

`ifdef AUTOMATON
    seq = my_fsm_automaton_sequence::type_id::create("seq");
`else
    seq = my_fsm_sequence::type_id::create("seq");
`endif
    if (!seq.randomize() with { max_iter == 1000; coverage_closure_en == 1; })
      `uvm_fatal(get_type_name(), "randomize failed")
    `uvm_info("TB", $sformatf("max_iter=%0d cov_closure=%0d", seq.max_iter, seq.coverage_closure_en), UVM_LOW)

    seq.start(vip_agent.sequencer);
    #100ns;

`ifdef AUTOMATON
    `uvm_info("AUTOMATON",
      $sformatf("State coverage:      %0.2f%%", seq.get_automaton_state_coverage()), UVM_LOW)
    `uvm_info("AUTOMATON",
      $sformatf("Transition coverage: %0.2f%%", seq.get_automaton_transition_coverage()), UVM_LOW)
    `uvm_info("AUTOMATON",
      $sformatf("Total coverage:      %0.2f%%", seq.get_automaton_total_coverage()), UVM_LOW)
`else
    `uvm_info("RANDOM", "Random sequence completed. См. completion_post_body в логе.", UVM_LOW)
`endif

    `uvm_info(get_type_name(), "Ending test", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase
endclass : automaton_test

module tb_auto;
  initial run_test("automaton_test");
endmodule
