// SVGraph pcie_link_polling
// File    pcie_link_polling_checker.sv


function pcie_link_polling_checker::new(string name="pcie_link_polling_checker" , uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function bit pcie_link_polling_checker::is_valid_transition(pcie_link_polling_state_t src,dst);
  bit ret_val = 0;
  case ({src,dst})
    {Entry_from_Detect,Polling_Active} : ret_val = 1;
    {Polling_Active,Polling_Compliance} : ret_val = 1;
    {Polling_Active,Polling_Configuration} : ret_val = 1;
    {Polling_Active,Exit_to_Detect} : ret_val = 1;
    {Polling_Compliance,Polling_Active} : ret_val = 1;
    {Polling_Configuration,Exit_to_Detect} : ret_val = 1;
    {Polling_Configuration,Exit_to_Configuration} : ret_val = 1;
    {starting,Entry_from_Detect} : ret_val = 1;
    default: ret_val = 0;
  endcase
endfunction : is_valid_transition

function void pcie_link_polling_checker::check_transition(pcie_link_polling_state_t src,dst);
  ASSERT_PCIE_LINK_POLLING_TRANSITION: assert (is_valid_transition(src,dst))
  else `uvm_error("ASSERT_PCIE_LINK_POLLING_TRANSITION",$sformatf("Invalid transition from %s to %s",src,dst))
endfunction : check_transition

