// SVGraph my_fsm
// File    my_fsm_types.svh

// State Enumerated Type 
typedef enum integer {
  UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors
  ,IDLE = 1
  ,READ
  ,WRITE
  ,DONE
  ,__START__
} my_fsm_state_t;

