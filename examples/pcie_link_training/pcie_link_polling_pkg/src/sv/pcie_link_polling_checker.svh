// SVGraph pcie_link_polling
// File    pcie_link_polling_checker.svh


class pcie_link_polling_checker extends uvm_component;
  `uvm_component_utils(pcie_link_polling_checker)

  extern function new(string name="pcie_link_polling_checker" , uvm_component parent=null);

  extern static function bit is_valid_transition(pcie_link_polling_state_t src,dst);

  extern        function void check_transition(pcie_link_polling_state_t src,dst);

endclass : pcie_link_polling_checker 
