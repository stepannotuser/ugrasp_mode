// SVGraph arp
// File    arp_types.svh

// State Enumerated Type 
typedef enum integer {
  UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors
  ,Idle = 1
  ,RequestAddress
  ,AddressConflict
  ,AssignAddress
  ,Ready
  ,starting
} arp_state_t;

