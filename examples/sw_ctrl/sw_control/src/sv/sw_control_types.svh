// SVGraph sw_control
// File    sw_control_types.svh

// State Enumerated Type 
typedef enum integer {
  UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors
  ,Idle = 1
  ,Configure
  ,InitTxBuffers
  ,TxControl
  ,WaitForInterrupt
  ,ReadRxBuffer
  ,starting
} sw_control_state_t;

