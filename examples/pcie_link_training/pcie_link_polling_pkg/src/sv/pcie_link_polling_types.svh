// SVGraph pcie_link_polling
// File    pcie_link_polling_types.svh

// State Enumerated Type 
typedef enum integer {
  UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors
  ,Entry_from_Detect = 1
  ,Polling_Active
  ,Polling_Compliance
  ,Polling_Configuration
  ,Exit_to_Detect
  ,Exit_to_Configuration
  ,starting
} pcie_link_polling_state_t;

