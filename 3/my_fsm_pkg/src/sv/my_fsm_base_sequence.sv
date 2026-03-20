// SVGraph my_fsm
// File    my_fsm_base_sequence.sv

// ----------------------------------------------
/// Constructor
// ----------------------------------------------

function my_fsm_base_sequence::new(string name="my_fsm_base_sequence");
  local_curr_iter_idx = 0;
  weight_end = 0;
  init_weight(initial_edge_weight);
  cg = new();
endfunction : new


// configure the covergroup goals depending on constraint setup
function void my_fsm_base_sequence::post_randomize();
  int unsigned _at_least_value = this.coverage_default_edge_at_least;
  int unsigned _cover_weight   = 1;
  foreach (weight[src,dst]) begin
    // user made this edge as 0, so it's not a target
    _at_least_value = (weight[src][dst] == 0) ? 1 : this.coverage_default_edge_at_least;
    _cover_weight   = (weight[src][dst] == 0) ? 0 : 1;

    // setup individual edge coverpoint target
    case ({src,dst})
      {IDLE,READ} : begin cg.IDLE_to_READ.option.weight = _cover_weight; cg.IDLE_to_READ.option.at_least = _at_least_value; end
      {READ,WRITE} : begin cg.READ_to_WRITE.option.weight = _cover_weight; cg.READ_to_WRITE.option.at_least = _at_least_value; end
      {WRITE,DONE} : begin cg.WRITE_to_DONE.option.weight = _cover_weight; cg.WRITE_to_DONE.option.at_least = _at_least_value; end
      {DONE,DONE} : begin cg.DONE_to_DONE.option.weight = _cover_weight; cg.DONE_to_DONE.option.at_least = _at_least_value; end
      endcase
    end
//
  // Allow the body() to run. If not a fatal is triggered.
  randomization_done = 1;
endfunction :  post_randomize


// ----------------------------------------------
// protected management functions and tasks
// ----------------------------------------------
/// weight initialization, called by the constructor
/// Defined in the graph class as it requires the state to be defined.
/// Should be pure virtual but some tools don't like pure virtual UVM classes
function void my_fsm_base_sequence::init_weight(int unsigned _w);
  my_fsm_state_t src,dst; 
  if ( _w > 0 ) weight_end = 0 ;
  else          weight_end = 100;
    weight[IDLE][READ] = _w;
    weight[READ][WRITE] = _w;
    weight[WRITE][DONE] = _w;
    weight[DONE][DONE] = _w;
    weight[__START__][IDLE] = _w;
endfunction : init_weight

// Value getter to be used in directed constraints
function int unsigned my_fsm_base_sequence::get_uint_value(int unsigned value);
  return value;
endfunction : get_uint_value

// curr_iter_idx getter

function int unsigned my_fsm_base_sequence::get_current_iteration();
  return local_curr_iter_idx;
endfunction : get_current_iteration


function my_fsm_state_t my_fsm_base_sequence::get_current_state();
  return current_state;
endfunction : get_current_state
function my_fsm_state_t my_fsm_base_sequence::get_previous_state();
  return previous_state;
endfunction : get_previous_state
// ----------------------------------------------
// Coverage
// ----------------------------------------------
/// Users may override it to implement their own coverage
function int my_fsm_base_sequence::get_custom_coverage();
  return 100;
endfunction : get_custom_coverage


// we need to perform some maintenance each time a transition is made
// cannot be in the base class because of the dependency on my_fsm_state_t
function void my_fsm_base_sequence::update_transition(my_fsm_state_t _src, _dst);
  previous_state = current_state;
  current_state = _dst;
  weight[_src][_dst] = weight[_src][_dst] > weight_default_decrement ? weight[_src][_dst] - weight_default_decrement : 1;
  local_curr_iter_idx += 1;
  // Record coverage
  cg.sample(current_state);
  // End of seqquence exit criteria
  if ( ( local_curr_iter_idx >= max_iter ) || 
     ( coverage_closure_en && (cg.get_coverage() == 100 && get_custom_coverage() == 100) ) ) 
  begin 
    init_weight(0);
    weight_end = 100;
  end
endfunction : update_transition

// ----------------------------------------------
// GoTo & Edge Management
// ----------------------------------------------
function void my_fsm_base_sequence::goto(my_fsm_state_t next);
  goto_next_state = next; // where we are going
  goto_from_state = current_state; // save the source
  goto_saved_weight = weight[goto_from_state]; // save the weight of the source
  foreach (goto_saved_weight[st]) begin
    if ( st == goto_next_state )
      goto_activated = 1;
    else
      weight[goto_from_state][st] = 0; // set all the destination to 0, except the one we are going to
  end
  if ( ! goto_activated ) begin 
    // we are actually not going anywhere
    // restore the weights
    weight[goto_from_state] = goto_saved_weight;
  end
endfunction : goto

function void my_fsm_base_sequence::prepare_context();
  if ( goto_activated ) begin 
    goto_activated = 0;
    weight[goto_from_state] = goto_saved_weight;
  end
endfunction : prepare_context

function void my_fsm_base_sequence::exit();
  init_weight(0);
  weight_end = 100;

endfunction : exit

function void my_fsm_base_sequence::exclude_next(my_fsm_state_t next);
  if (next inside {weight[current_state]} )
    weight[current_state][next] = 0;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to exclude the next state %s",current_state,next,next))
endfunction : exclude_next

function void my_fsm_base_sequence::include_next(my_fsm_state_t next,int unsigned _weight=initial_edge_weight);
  if (next inside {weight[current_state]} )
    weight[current_state][next] = _weight;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the next state %s",current_state,next,next))
endfunction : include_next

function void my_fsm_base_sequence::exclude_edge(my_fsm_state_t src,dst);
  if (dst inside {weight[src]} )
    weight[src][dst] = 0;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the next state %s",src,dst,dst))
endfunction : exclude_edge

function void my_fsm_base_sequence::include_edge(my_fsm_state_t src,dst,int unsigned _weight=initial_edge_weight);
  if (dst inside {weight[src]} )
    weight[src][dst] = _weight;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the state %s",src,dst,dst))
endfunction : include_edge

// ----------------------------------------------
// default constraints
// ----------------------------------------------
constraint my_fsm_base_sequence::svgraph_base_sequence_default_c {
  weight_default_decrement < initial_edge_weight;

  soft max_iter                 == 1_000; //< Maximum default number off iterations 
  soft coverage_closure_en      == 0;     //< Coverage Closure is disable by default
  soft coverage_default_edge_at_least    == 1;     //< coverage_default_edge_at_least
  soft initial_edge_weight      == 100;   //< Default Weight for each edge
  soft weight_default_decrement == 1;     //< weight_default_decrement
}
