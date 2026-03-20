// SVGraph arp
// File    arp_checker.svh


class arp_checker extends uvm_component;
  `uvm_component_utils(arp_checker)

  extern function new(string name="arp_checker" , uvm_component parent=null);

  extern static function bit is_valid_transition(arp_state_t src,dst);

  extern        function void check_transition(arp_state_t src,dst);

endclass : arp_checker 
