// SVGraph sw_control
// File    sw_control_checker.svh


class sw_control_checker extends uvm_component;
  `uvm_component_utils(sw_control_checker)

  extern function new(string name="sw_control_checker" , uvm_component parent=null);

  extern static function bit is_valid_transition(sw_control_state_t src,dst);

  extern        function void check_transition(sw_control_state_t src,dst);

endclass : sw_control_checker 
