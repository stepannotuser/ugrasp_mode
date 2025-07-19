// SVGraph sw_control
// File    sw_control_sequence.svh

class sw_control_sequence extends sw_control_base_sequence;
  `uvm_object_utils(sw_control_sequence)

  // Constructor 
  extern function new(string name="sw_control_sequence");

  // Default edge weight. Users may want to overconstrain in a child class
  constraint sw_control_default_c {
    foreach (weight[src,dst]) {
      soft weight[src][dst] == get_uint_value(initial_edge_weight);
    }
  }

  /// ----------------------------------------------
  /// Common body tasks
  /// ----------------------------------------------
  
  extern virtual function void completion_pre_body(); 
  extern virtual task          completion_body(); 
  extern virtual function void completion_post_body();
  
  extern virtual function void state_pre_body(sw_control_state_t state);
  extern virtual task          state_body(sw_control_state_t state);
  extern virtual function void state_post_body(sw_control_state_t state);
  
  extern virtual function void transition_pre_body(sw_control_state_t src,dst);
  extern virtual task          transition_body(sw_control_state_t src,dst);
  extern virtual function void transition_post_body(sw_control_state_t src,dst);
  
  /// ----------------------------------------------
  /// Utility Functions
  /// ----------------------------------------------
  extern virtual function void goto(sw_control_state_t next);
  extern virtual function void exit();
  // ----------------------------------------------
  // State tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Idle_pre_body();
  extern virtual task          Idle_body();
  extern virtual function void Idle_post_body();

  extern virtual function void Configure_pre_body();
  extern virtual task          Configure_body();
  extern virtual function void Configure_post_body();

  extern virtual function void InitTxBuffers_pre_body();
  extern virtual task          InitTxBuffers_body();
  extern virtual function void InitTxBuffers_post_body();

  extern virtual function void TxControl_pre_body();
  extern virtual task          TxControl_body();
  extern virtual function void TxControl_post_body();

  extern virtual function void WaitForInterrupt_pre_body();
  extern virtual task          WaitForInterrupt_body();
  extern virtual function void WaitForInterrupt_post_body();

  extern virtual function void ReadRxBuffer_pre_body();
  extern virtual task          ReadRxBuffer_body();
  extern virtual function void ReadRxBuffer_post_body();

  extern virtual function void __START___pre_body();
  extern virtual task          __START___body();
  extern virtual function void __START___post_body();

  // ----------------------------------------------
  // Transition tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Idle_to_Configure_pre_body();
  extern virtual task          Idle_to_Configure_body();
  extern virtual function void Idle_to_Configure_post_body();

  extern virtual function void Idle_to_InitTxBuffers_pre_body();
  extern virtual task          Idle_to_InitTxBuffers_body();
  extern virtual function void Idle_to_InitTxBuffers_post_body();

  extern virtual function void Idle_to_TxControl_pre_body();
  extern virtual task          Idle_to_TxControl_body();
  extern virtual function void Idle_to_TxControl_post_body();

  extern virtual function void Configure_to_InitTxBuffers_pre_body();
  extern virtual task          Configure_to_InitTxBuffers_body();
  extern virtual function void Configure_to_InitTxBuffers_post_body();

  extern virtual function void Configure_to_WaitForInterrupt_pre_body();
  extern virtual task          Configure_to_WaitForInterrupt_body();
  extern virtual function void Configure_to_WaitForInterrupt_post_body();

  extern virtual function void InitTxBuffers_to_TxControl_pre_body();
  extern virtual task          InitTxBuffers_to_TxControl_body();
  extern virtual function void InitTxBuffers_to_TxControl_post_body();

  extern virtual function void InitTxBuffers_to_InitTxBuffers_pre_body();
  extern virtual task          InitTxBuffers_to_InitTxBuffers_body();
  extern virtual function void InitTxBuffers_to_InitTxBuffers_post_body();

  extern virtual function void TxControl_to_WaitForInterrupt_pre_body();
  extern virtual task          TxControl_to_WaitForInterrupt_body();
  extern virtual function void TxControl_to_WaitForInterrupt_post_body();

  extern virtual function void TxControl_to_TxControl_pre_body();
  extern virtual task          TxControl_to_TxControl_body();
  extern virtual function void TxControl_to_TxControl_post_body();

  extern virtual function void TxControl_to_InitTxBuffers_pre_body();
  extern virtual task          TxControl_to_InitTxBuffers_body();
  extern virtual function void TxControl_to_InitTxBuffers_post_body();

  extern virtual function void WaitForInterrupt_to_ReadRxBuffer_pre_body();
  extern virtual task          WaitForInterrupt_to_ReadRxBuffer_body();
  extern virtual function void WaitForInterrupt_to_ReadRxBuffer_post_body();

  extern virtual function void WaitForInterrupt_to_InitTxBuffers_pre_body();
  extern virtual task          WaitForInterrupt_to_InitTxBuffers_body();
  extern virtual function void WaitForInterrupt_to_InitTxBuffers_post_body();

  extern virtual function void WaitForInterrupt_to_Idle_pre_body();
  extern virtual task          WaitForInterrupt_to_Idle_body();
  extern virtual function void WaitForInterrupt_to_Idle_post_body();

  extern virtual function void WaitForInterrupt_to_TxControl_pre_body();
  extern virtual task          WaitForInterrupt_to_TxControl_body();
  extern virtual function void WaitForInterrupt_to_TxControl_post_body();

  extern virtual function void ReadRxBuffer_to_Idle_pre_body();
  extern virtual task          ReadRxBuffer_to_Idle_body();
  extern virtual function void ReadRxBuffer_to_Idle_post_body();

  extern virtual function void ReadRxBuffer_to_Configure_pre_body();
  extern virtual task          ReadRxBuffer_to_Configure_body();
  extern virtual function void ReadRxBuffer_to_Configure_post_body();

  extern virtual function void ReadRxBuffer_to_InitTxBuffers_pre_body();
  extern virtual task          ReadRxBuffer_to_InitTxBuffers_body();
  extern virtual function void ReadRxBuffer_to_InitTxBuffers_post_body();

  extern virtual function void ReadRxBuffer_to_WaitForInterrupt_pre_body();
  extern virtual task          ReadRxBuffer_to_WaitForInterrupt_body();
  extern virtual function void ReadRxBuffer_to_WaitForInterrupt_post_body();

  extern virtual function void __START___to_Idle_pre_body();
  extern virtual task          __START___to_Idle_body();
  extern virtual function void __START___to_Idle_post_body();

  extern virtual task body();
endclass : sw_control_sequence
