// SVGraph my_fsm
// File    my_fsm_checker.sv


function my_fsm_checker::new(string name="my_fsm_checker" , uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function bit my_fsm_checker::is_valid_transition(my_fsm_state_t src,dst);
  bit ret_val = 0;
  case ({src,dst})
    {IDLE,READ} : ret_val = 1;
    {READ,WRITE} : ret_val = 1;
    {WRITE,DONE} : ret_val = 1;
    {DONE,DONE} : ret_val = 1;
    {__START__,IDLE} : ret_val = 1;
    default: ret_val = 0;
  endcase
endfunction : is_valid_transition

function void my_fsm_checker::check_transition(my_fsm_state_t src,dst);
  ASSERT_MY_FSM_TRANSITION: assert (is_valid_transition(src,dst))
  else `uvm_error("ASSERT_MY_FSM_TRANSITION",$sformatf("Invalid transition from %s to %s",src,dst))
endfunction : check_transition

