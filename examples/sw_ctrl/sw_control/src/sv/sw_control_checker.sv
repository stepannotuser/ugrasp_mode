// SVGraph sw_control
// File    sw_control_checker.sv


function sw_control_checker::new(string name="sw_control_checker" , uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function bit sw_control_checker::is_valid_transition(sw_control_state_t src,dst);
  bit ret_val = 0;
  case ({src,dst})
    {Idle,Configure} : ret_val = 1;
    {Idle,InitTxBuffers} : ret_val = 1;
    {Idle,TxControl} : ret_val = 1;
    {Configure,InitTxBuffers} : ret_val = 1;
    {Configure,WaitForInterrupt} : ret_val = 1;
    {InitTxBuffers,TxControl} : ret_val = 1;
    {InitTxBuffers,InitTxBuffers} : ret_val = 1;
    {TxControl,WaitForInterrupt} : ret_val = 1;
    {TxControl,TxControl} : ret_val = 1;
    {TxControl,InitTxBuffers} : ret_val = 1;
    {WaitForInterrupt,ReadRxBuffer} : ret_val = 1;
    {WaitForInterrupt,InitTxBuffers} : ret_val = 1;
    {WaitForInterrupt,Idle} : ret_val = 1;
    {WaitForInterrupt,TxControl} : ret_val = 1;
    {ReadRxBuffer,Idle} : ret_val = 1;
    {ReadRxBuffer,Configure} : ret_val = 1;
    {ReadRxBuffer,InitTxBuffers} : ret_val = 1;
    {ReadRxBuffer,WaitForInterrupt} : ret_val = 1;
    {starting,Idle} : ret_val = 1;
    default: ret_val = 0;
  endcase
endfunction : is_valid_transition

function void sw_control_checker::check_transition(sw_control_state_t src,dst);
  ASSERT_SW_CONTROL_TRANSITION: assert (is_valid_transition(src,dst))
  else `uvm_error("ASSERT_SW_CONTROL_TRANSITION",$sformatf("Invalid transition from %s to %s",src,dst))
endfunction : check_transition

