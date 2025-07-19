// SVGraph pcie_link_polling
// File    pcie_link_polling_sequence.svh

class pcie_link_polling_sequence extends pcie_link_polling_base_sequence;
  `uvm_object_utils(pcie_link_polling_sequence)

  // Constructor 
  extern function new(string name="pcie_link_polling_sequence");

  // Default edge weight. Users may want to overconstrain in a child class
  constraint pcie_link_polling_default_c {
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
  
  extern virtual function void state_pre_body(pcie_link_polling_state_t state);
  extern virtual task          state_body(pcie_link_polling_state_t state);
  extern virtual function void state_post_body(pcie_link_polling_state_t state);
  
  extern virtual function void transition_pre_body(pcie_link_polling_state_t src,dst);
  extern virtual task          transition_body(pcie_link_polling_state_t src,dst);
  extern virtual function void transition_post_body(pcie_link_polling_state_t src,dst);
  
  /// ----------------------------------------------
  /// Utility Functions
  /// ----------------------------------------------
  extern virtual function void goto(pcie_link_polling_state_t next);
  extern virtual function void exit();
  // ----------------------------------------------
  // State tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Entry_from_Detect_pre_body();
  extern virtual task          Entry_from_Detect_body();
  extern virtual function void Entry_from_Detect_post_body();

  extern virtual function void Polling_Active_pre_body();
  extern virtual task          Polling_Active_body();
  extern virtual function void Polling_Active_post_body();

  extern virtual function void Polling_Compliance_pre_body();
  extern virtual task          Polling_Compliance_body();
  extern virtual function void Polling_Compliance_post_body();

  extern virtual function void Polling_Configuration_pre_body();
  extern virtual task          Polling_Configuration_body();
  extern virtual function void Polling_Configuration_post_body();

  extern virtual function void Exit_to_Detect_pre_body();
  extern virtual task          Exit_to_Detect_body();
  extern virtual function void Exit_to_Detect_post_body();

  extern virtual function void Exit_to_Configuration_pre_body();
  extern virtual task          Exit_to_Configuration_body();
  extern virtual function void Exit_to_Configuration_post_body();

  extern virtual function void starting_pre_body();
  extern virtual task          starting_body();
  extern virtual function void starting_post_body();

  // ----------------------------------------------
  // Transition tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Entry_from_Detect_to_Polling_Active_pre_body();
  extern virtual task          Entry_from_Detect_to_Polling_Active_body();
  extern virtual function void Entry_from_Detect_to_Polling_Active_post_body();

  extern virtual function void Polling_Active_to_Polling_Compliance_pre_body();
  extern virtual task          Polling_Active_to_Polling_Compliance_body();
  extern virtual function void Polling_Active_to_Polling_Compliance_post_body();

  extern virtual function void Polling_Active_to_Polling_Configuration_pre_body();
  extern virtual task          Polling_Active_to_Polling_Configuration_body();
  extern virtual function void Polling_Active_to_Polling_Configuration_post_body();

  extern virtual function void Polling_Active_to_Exit_to_Detect_pre_body();
  extern virtual task          Polling_Active_to_Exit_to_Detect_body();
  extern virtual function void Polling_Active_to_Exit_to_Detect_post_body();

  extern virtual function void Polling_Compliance_to_Polling_Active_pre_body();
  extern virtual task          Polling_Compliance_to_Polling_Active_body();
  extern virtual function void Polling_Compliance_to_Polling_Active_post_body();

  extern virtual function void Polling_Configuration_to_Exit_to_Detect_pre_body();
  extern virtual task          Polling_Configuration_to_Exit_to_Detect_body();
  extern virtual function void Polling_Configuration_to_Exit_to_Detect_post_body();

  extern virtual function void Polling_Configuration_to_Exit_to_Configuration_pre_body();
  extern virtual task          Polling_Configuration_to_Exit_to_Configuration_body();
  extern virtual function void Polling_Configuration_to_Exit_to_Configuration_post_body();

  extern virtual function void starting_to_Entry_from_Detect_pre_body();
  extern virtual task          starting_to_Entry_from_Detect_body();
  extern virtual function void starting_to_Entry_from_Detect_post_body();

  extern virtual task body();
endclass : pcie_link_polling_sequence
