// SVGraph arp
// File    arp_base_sequence.svh

class arp_base_sequence extends uvm_sequence;
  
  // ----------------------------------------------
  // protected internal variables
  // ----------------------------------------------
  local     int unsigned local_curr_iter_idx = 0;  ///< Current Iteration Index. Incremented on each new state
  protected int unsigned weight_end = 0;           ///< Exit criteria. When 0, no exit from normal flow is possible
  
  // ----------------------------------------------
  // public constrainable settings
  // ----------------------------------------------
  rand int unsigned max_iter;                      ///< maximum number of iterations. When reached, the graph completes
  rand int unsigned initial_edge_weight = 100;     ///< constrainable initial default weight for each edge
  rand bit          coverage_closure_en = 0;       ///< constrainable coverage closure configuration. When 1, graph will exit when the coverage reaches 100%
  rand int unsigned weight_default_decrement = 1;  ///< constrainable decrement of the weight of the edge each time it is executed
  rand int unsigned coverage_default_edge_at_least = 1;     ///< constrainable. Each edge should be covered at least this number of times
  rand int unsigned weight[arp_state_t][arp_state_t] = '{default:initial_edge_weight}; //< constrainable weights for each possible edge. Initial value set to 'initial_edge_weight'

  
  // ----------------------------------------------
  // Coverage
  // ----------------------------------------------
  protected arp_state_t current_state;
  protected arp_state_t previous_state;
  arp_cg cg;
  extern virtual           function int          get_custom_coverage();
  
  // ----------------------------------------------
  // GoTo & Edge Management
  // ----------------------------------------------
  protected arp_state_t goto_next_state; // where to go
  protected arp_state_t goto_from_state; // where from
  protected int unsigned goto_saved_weight[arp_state_t]; // saved weight of the source before going
  protected bit          goto_activated = 0; // got is activated
  extern virtual protected function void prepare_context();
  extern virtual           function void goto(arp_state_t next);
  extern virtual           function void exit();
  extern virtual           function void exclude_next(arp_state_t next);
  extern virtual           function void include_next(arp_state_t next,int unsigned _weight=initial_edge_weight);
  extern virtual           function void exclude_edge(arp_state_t src,dst);
  extern virtual           function void include_edge(arp_state_t src,dst,int unsigned _weight=initial_edge_weight);
  extern virtual           function int unsigned get_current_iteration();
  extern virtual           function arp_state_t get_current_state();
  extern virtual           function arp_state_t get_previous_state();
  
  // ----------------------------------------------
  /// Constructor
  // ----------------------------------------------
  extern function          new(string name="arp_base_sequence");
  extern function          void post_randomize();
  
  // ----------------------------------------------
  // protected management functions and tasks
  // ----------------------------------------------
  extern virtual protected function void         init_weight(int unsigned _w);
  extern virtual protected function int unsigned get_uint_value(int unsigned value);
  extern virtual protected function void         update_transition(arp_state_t _src, _dst);
  
  // ----------------------------------------------
  // default constraints
  // ----------------------------------------------
  /* extern */ constraint svgraph_base_sequence_default_c;
  
  `uvm_object_utils_begin(arp_base_sequence)
    `uvm_field_int(max_iter                 , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )
    `uvm_field_int(initial_edge_weight      , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )
    `uvm_field_int(coverage_closure_en      , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )
    `uvm_field_int(weight_default_decrement , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )
    `uvm_field_int(coverage_default_edge_at_least    , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )
  `uvm_object_utils_end
  
endclass : arp_base_sequence
