// SVGraph my_fsm
// File    my_fsm_sequence.svh

class my_fsm_sequence extends my_fsm_base_sequence;
  `uvm_object_utils(my_fsm_sequence)

  // Constructor 
  extern function new(string name="my_fsm_sequence");

  // Default edge weight. Users may want to overconstrain in a child class
  constraint my_fsm_default_c {
    foreach (weight[src,dst]) {
      soft weight[src][dst] == get_uint_value(initial_edge_weight);
    }
  }

  // ----------------------------------------------
  // Common body tasks
  // ----------------------------------------------
  // completion is called when the graph exists
  extern virtual function void completion_pre_body(); 
  extern virtual task          completion_body(); 
  extern virtual function void completion_post_body();

  // state_body(state) is called in parallal to any <state>_body() task.
  // this allows to handles states in a more generic way
  extern virtual function void state_pre_body(my_fsm_state_t state);
  extern virtual task          state_body(my_fsm_state_t state);
  extern virtual function void state_post_body(my_fsm_state_t state);

  // transition_body(src,dst) is called in parallal to any <transition>_body() task.
  // this allows to handles transition in a more generic way
  extern virtual function void transition_pre_body(my_fsm_state_t src,dst);
  extern virtual task          transition_body(my_fsm_state_t src,dst);
  extern virtual function void transition_post_body(my_fsm_state_t src,dst);

  /// ----------------------------------------------
  /// Utility Functions
  /// ----------------------------------------------
  // goto(): to be called in a state to control what is the next state
  extern virtual function void goto(my_fsm_state_t next);

  // exit(): to be called at anytime to force to go to completion
  extern virtual function void exit();

  // exclude_next(): to be called in a state to exclude one of the next from possible choices
  extern virtual function void exclude_next(my_fsm_state_t next);

  // include_next(): to be called in a state to include one of the next within possible choices
  extern virtual function void include_next(my_fsm_state_t next,
                                            int unsigned _weight=initial_edge_weight);

  // exclude_edge(): to be called anywhere, to exclude any edge
  extern virtual function void exclude_edge(my_fsm_state_t src,dst);

  // include_edge(): to be called anywhere, to include any edge
  extern virtual function void include_edge(my_fsm_state_t src,dst,
                                            int unsigned _weight=initial_edge_weight);

  // ----------------------------------------------
  // State tasks and functions hooks
  // ----------------------------------------------
  // Use these to perform actions when you are expected to be in or to go to a state
  // You may use goto(state) include_next(state) or include_next(state) from these
  // You may use exclude_edge(src,dst) or include_edge(src,dst) from these
  extern virtual function void IDLE_pre_body();
  extern virtual function void READ_pre_body();
  extern virtual function void WRITE_pre_body();
  extern virtual function void DONE_pre_body();
  extern virtual function void __START___pre_body();

  extern virtual task          IDLE_body();
  extern virtual task          READ_body();
  extern virtual task          WRITE_body();
  extern virtual task          DONE_body();
  extern virtual task          __START___body();

  extern virtual function void IDLE_post_body();
  extern virtual function void READ_post_body();
  extern virtual function void WRITE_post_body();
  extern virtual function void DONE_post_body();
  extern virtual function void __START___post_body();

  // ----------------------------------------------
  // Transition tasks and functions hooks
  // ----------------------------------------------
  // Use these to perform actions to move to the destination state
  // You may use exclude_edge(src,dst) or include_edge(src,dst) from these
  extern virtual function void IDLE_to_READ_pre_body();
  extern virtual function void READ_to_WRITE_pre_body();
  extern virtual function void WRITE_to_DONE_pre_body();
  extern virtual function void DONE_to_DONE_pre_body();
  extern virtual function void __START___to_IDLE_pre_body();

  extern virtual task          IDLE_to_READ_body();
  extern virtual task          READ_to_WRITE_body();
  extern virtual task          WRITE_to_DONE_body();
  extern virtual task          DONE_to_DONE_body();
  extern virtual task          __START___to_IDLE_body();

  extern virtual function void IDLE_to_READ_post_body();
  extern virtual function void READ_to_WRITE_post_body();
  extern virtual function void WRITE_to_DONE_post_body();
  extern virtual function void DONE_to_DONE_post_body();
  extern virtual function void __START___to_IDLE_post_body();

  extern virtual task body();
endclass : my_fsm_sequence
