// SVGraph my_fsm
// File    my_fsm_checker.svh


class my_fsm_checker extends uvm_component;
  `uvm_component_utils(my_fsm_checker)

  extern function new(string name="my_fsm_checker" , uvm_component parent=null);

  extern static function bit is_valid_transition(my_fsm_state_t src,dst);

  extern        function void check_transition(my_fsm_state_t src,dst);

endclass : my_fsm_checker 
