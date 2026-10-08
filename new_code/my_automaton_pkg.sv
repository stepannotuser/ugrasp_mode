package my_automaton_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import simple_vip_pkg::*;
  import my_fsm_pkg::*; //базовый
  import my_test_pkg::*; // наследни

  `include "my_fsm_automaton_sequence.svh" // моешенское

endpackage : my_automaton_pkg
