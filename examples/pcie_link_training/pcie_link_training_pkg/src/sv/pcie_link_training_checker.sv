// SVGraph pcie_link_training
// File    pcie_link_training_checker.sv


function pcie_link_training_checker::new(string name="pcie_link_training_checker" , uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function bit pcie_link_training_checker::is_valid_transition(pcie_link_training_state_t src,dst);
  bit ret_val = 0;
  case ({src,dst})
    {Detect,Polling} : ret_val = 1;
    {Polling,Detect} : ret_val = 1;
    {Polling,Configuration} : ret_val = 1;
    {Configuration,L0} : ret_val = 1;
    {Configuration,Recovery} : ret_val = 1;
    {Configuration,Detect} : ret_val = 1;
    {L0,L1} : ret_val = 1;
    {L0,L0s} : ret_val = 1;
    {L0,L2} : ret_val = 1;
    {L0,Recovery} : ret_val = 1;
    {Recovery,Configuration} : ret_val = 1;
    {Recovery,L0} : ret_val = 1;
    {Recovery,Detect} : ret_val = 1;
    {L1,Recovery} : ret_val = 1;
    {L0s,L0} : ret_val = 1;
    {L0s,Recovery} : ret_val = 1;
    {L2,Detect} : ret_val = 1;
    {starting,Detect} : ret_val = 1;
    default: ret_val = 0;
  endcase
endfunction : is_valid_transition

function void pcie_link_training_checker::check_transition(pcie_link_training_state_t src,dst);
  ASSERT_PCIE_LINK_TRAINING_TRANSITION: assert (is_valid_transition(src,dst))
  else `uvm_error("ASSERT_PCIE_LINK_TRAINING_TRANSITION",$sformatf("Invalid transition from %s to %s",src,dst))
endfunction : check_transition

