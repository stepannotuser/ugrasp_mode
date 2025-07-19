// SVGraph pcie_link_training
// File    pcie_link_training_sequence.svh

class pcie_link_training_sequence extends pcie_link_training_base_sequence;
  `uvm_object_utils(pcie_link_training_sequence)

  // Constructor 
  extern function new(string name="pcie_link_training_sequence");

  // Default edge weight. Users may want to overconstrain in a child class
  constraint pcie_link_training_default_c {
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
  
  extern virtual function void state_pre_body(pcie_link_training_state_t state);
  extern virtual task          state_body(pcie_link_training_state_t state);
  extern virtual function void state_post_body(pcie_link_training_state_t state);
  
  extern virtual function void transition_pre_body(pcie_link_training_state_t src,dst);
  extern virtual task          transition_body(pcie_link_training_state_t src,dst);
  extern virtual function void transition_post_body(pcie_link_training_state_t src,dst);
  
  /// ----------------------------------------------
  /// Utility Functions
  /// ----------------------------------------------
  extern virtual function void goto(pcie_link_training_state_t next);
  extern virtual function void exit();
  // ----------------------------------------------
  // State tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Detect_pre_body();
  extern virtual task          Detect_body();
  extern virtual function void Detect_post_body();

  extern virtual function void Polling_pre_body();
  extern virtual task          Polling_body();
  extern virtual function void Polling_post_body();

  extern virtual function void Configuration_pre_body();
  extern virtual task          Configuration_body();
  extern virtual function void Configuration_post_body();

  extern virtual function void L0_pre_body();
  extern virtual task          L0_body();
  extern virtual function void L0_post_body();

  extern virtual function void Recovery_pre_body();
  extern virtual task          Recovery_body();
  extern virtual function void Recovery_post_body();

  extern virtual function void L1_pre_body();
  extern virtual task          L1_body();
  extern virtual function void L1_post_body();

  extern virtual function void L0s_pre_body();
  extern virtual task          L0s_body();
  extern virtual function void L0s_post_body();

  extern virtual function void L2_pre_body();
  extern virtual task          L2_body();
  extern virtual function void L2_post_body();

  extern virtual function void starting_pre_body();
  extern virtual task          starting_body();
  extern virtual function void starting_post_body();

  // ----------------------------------------------
  // Transition tasks and functions hooks
  // ----------------------------------------------
  extern virtual function void Detect_to_Polling_pre_body();
  extern virtual task          Detect_to_Polling_body();
  extern virtual function void Detect_to_Polling_post_body();

  extern virtual function void Polling_to_Detect_pre_body();
  extern virtual task          Polling_to_Detect_body();
  extern virtual function void Polling_to_Detect_post_body();

  extern virtual function void Polling_to_Configuration_pre_body();
  extern virtual task          Polling_to_Configuration_body();
  extern virtual function void Polling_to_Configuration_post_body();

  extern virtual function void Configuration_to_L0_pre_body();
  extern virtual task          Configuration_to_L0_body();
  extern virtual function void Configuration_to_L0_post_body();

  extern virtual function void Configuration_to_Recovery_pre_body();
  extern virtual task          Configuration_to_Recovery_body();
  extern virtual function void Configuration_to_Recovery_post_body();

  extern virtual function void Configuration_to_Detect_pre_body();
  extern virtual task          Configuration_to_Detect_body();
  extern virtual function void Configuration_to_Detect_post_body();

  extern virtual function void L0_to_L1_pre_body();
  extern virtual task          L0_to_L1_body();
  extern virtual function void L0_to_L1_post_body();

  extern virtual function void L0_to_L0s_pre_body();
  extern virtual task          L0_to_L0s_body();
  extern virtual function void L0_to_L0s_post_body();

  extern virtual function void L0_to_L2_pre_body();
  extern virtual task          L0_to_L2_body();
  extern virtual function void L0_to_L2_post_body();

  extern virtual function void L0_to_Recovery_pre_body();
  extern virtual task          L0_to_Recovery_body();
  extern virtual function void L0_to_Recovery_post_body();

  extern virtual function void Recovery_to_Configuration_pre_body();
  extern virtual task          Recovery_to_Configuration_body();
  extern virtual function void Recovery_to_Configuration_post_body();

  extern virtual function void Recovery_to_L0_pre_body();
  extern virtual task          Recovery_to_L0_body();
  extern virtual function void Recovery_to_L0_post_body();

  extern virtual function void Recovery_to_Detect_pre_body();
  extern virtual task          Recovery_to_Detect_body();
  extern virtual function void Recovery_to_Detect_post_body();

  extern virtual function void L1_to_Recovery_pre_body();
  extern virtual task          L1_to_Recovery_body();
  extern virtual function void L1_to_Recovery_post_body();

  extern virtual function void L0s_to_L0_pre_body();
  extern virtual task          L0s_to_L0_body();
  extern virtual function void L0s_to_L0_post_body();

  extern virtual function void L0s_to_Recovery_pre_body();
  extern virtual task          L0s_to_Recovery_body();
  extern virtual function void L0s_to_Recovery_post_body();

  extern virtual function void L2_to_Detect_pre_body();
  extern virtual task          L2_to_Detect_body();
  extern virtual function void L2_to_Detect_post_body();

  extern virtual function void starting_to_Detect_pre_body();
  extern virtual task          starting_to_Detect_body();
  extern virtual function void starting_to_Detect_post_body();

  extern virtual task body();
endclass : pcie_link_training_sequence
