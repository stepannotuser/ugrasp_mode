// SVGraph arp
// File    arp_sequence.svh

class arp_sequence extends arp_base_sequence;
  `uvm_object_utils(arp_sequence)

  // Constructor 
  extern function new(string name="arp_sequence");

  // Default edge weight. Users may want to overconstrain in a child class
  constraint arp_default_c {
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
  
  extern virtual function void state_pre_body(arp_state_t state);
  extern virtual task          state_body(arp_state_t state);
  extern virtual function void state_post_body(arp_state_t state);
  
  extern virtual function void transition_pre_body(arp_state_t src,dst);
  extern virtual task          transition_body(arp_state_t src,dst);
  extern virtual function void transition_post_body(arp_state_t src,dst);
  
  /// ----------------------------------------------
  /// Utility Functions
  /// ----------------------------------------------
  extern virtual function void goto(arp_state_t next);
  extern virtual function void exit();
  // ----------------------------------------------
  // State tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Idle_pre_body();
  extern virtual task          Idle_body();
  extern virtual function void Idle_post_body();

  extern virtual function void RequestAddress_pre_body();
  extern virtual task          RequestAddress_body();
  extern virtual function void RequestAddress_post_body();

  extern virtual function void AddressConflict_pre_body();
  extern virtual task          AddressConflict_body();
  extern virtual function void AddressConflict_post_body();

  extern virtual function void AssignAddress_pre_body();
  extern virtual task          AssignAddress_body();
  extern virtual function void AssignAddress_post_body();

  extern virtual function void Ready_pre_body();
  extern virtual task          Ready_body();
  extern virtual function void Ready_post_body();

  extern virtual function void starting_pre_body();
  extern virtual task          starting_body();
  extern virtual function void starting_post_body();

  // ----------------------------------------------
  // Transition tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Idle_to_RequestAddress_pre_body();
  extern virtual task          Idle_to_RequestAddress_body();
  extern virtual function void Idle_to_RequestAddress_post_body();

  extern virtual function void RequestAddress_to_AddressConflict_pre_body();
  extern virtual task          RequestAddress_to_AddressConflict_body();
  extern virtual function void RequestAddress_to_AddressConflict_post_body();

  extern virtual function void RequestAddress_to_AssignAddress_pre_body();
  extern virtual task          RequestAddress_to_AssignAddress_body();
  extern virtual function void RequestAddress_to_AssignAddress_post_body();

  extern virtual function void AddressConflict_to_RequestAddress_pre_body();
  extern virtual task          AddressConflict_to_RequestAddress_body();
  extern virtual function void AddressConflict_to_RequestAddress_post_body();

  extern virtual function void AssignAddress_to_Ready_pre_body();
  extern virtual task          AssignAddress_to_Ready_body();
  extern virtual function void AssignAddress_to_Ready_post_body();

  extern virtual function void Ready_to_Idle_pre_body();
  extern virtual task          Ready_to_Idle_body();
  extern virtual function void Ready_to_Idle_post_body();

  extern virtual function void starting_to_Idle_pre_body();
  extern virtual task          starting_to_Idle_body();
  extern virtual function void starting_to_Idle_post_body();

  extern virtual task body();
endclass : arp_sequence
