// SVGraph pcie_link_training
// File    pcie_link_training_types.svh

// State Enumerated Type 
typedef enum integer {
  UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors
  ,Detect = 1
  ,Polling
  ,Configuration
  ,L0
  ,Recovery
  ,L1
  ,L0s
  ,L2
  ,starting
} pcie_link_training_state_t;

