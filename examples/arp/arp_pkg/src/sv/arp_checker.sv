// SVGraph arp
// File    arp_checker.sv


function arp_checker::new(string name="arp_checker" , uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function bit arp_checker::is_valid_transition(arp_state_t src,dst);
  bit ret_val = 0;
  case ({src,dst})
    {Idle,RequestAddress} : ret_val = 1;
    {RequestAddress,AddressConflict} : ret_val = 1;
    {RequestAddress,AssignAddress} : ret_val = 1;
    {AddressConflict,RequestAddress} : ret_val = 1;
    {AssignAddress,Ready} : ret_val = 1;
    {Ready,Idle} : ret_val = 1;
    {starting,Idle} : ret_val = 1;
    default: ret_val = 0;
  endcase
endfunction : is_valid_transition

function void arp_checker::check_transition(arp_state_t src,dst);
  ASSERT_ARP_TRANSITION: assert (is_valid_transition(src,dst))
  else `uvm_error("ASSERT_ARP_TRANSITION",$sformatf("Invalid transition from %s to %s",src,dst))
endfunction : check_transition

