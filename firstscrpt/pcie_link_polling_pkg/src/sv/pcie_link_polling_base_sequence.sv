// SVGraph pcie_link_polling
// File    pcie_link_polling_base_sequence.sv

// ----------------------------------------------
/// Constructor
// ----------------------------------------------

function pcie_link_polling_base_sequence::new(string name="pcie_link_polling_base_sequence");
  local_curr_iter_idx = 0;
  weight_end = 0;
  init_weight(initial_edge_weight);
  cg = new();
endfunction : new


// configure the covergroup goals depending on constraint setup
function void pcie_link_polling_base_sequence::post_randomize();
  int unsigned _at_least_value = this.coverage_default_edge_at_least;
  int unsigned _cover_weight   = 1;
  foreach (weight[src,dst]) begin
    // user made this edge as 0, so it's not a target
    _at_least_value = (weight[src][dst] == 0) ? 1 : this.coverage_default_edge_at_least;
    _cover_weight   = (weight[src][dst] == 0) ? 0 : 1;

    // setup individual edge coverpoint target
    case ({src,dst})
      {Entry_from_Detect,Polling_Active} : begin cg.Entry_from_Detect_to_Polling_Active.option.weight = _cover_weight; cg.Entry_from_Detect_to_Polling_Active.option.at_least = _at_least_value; end
      {Polling_Active,Polling_Compliance} : begin cg.Polling_Active_to_Polling_Compliance.option.weight = _cover_weight; cg.Polling_Active_to_Polling_Compliance.option.at_least = _at_least_value; end
      {Polling_Active,Polling_Configuration} : begin cg.Polling_Active_to_Polling_Configuration.option.weight = _cover_weight; cg.Polling_Active_to_Polling_Configuration.option.at_least = _at_least_value; end
      {Polling_Active,Exit_to_Detect} : begin cg.Polling_Active_to_Exit_to_Detect.option.weight = _cover_weight; cg.Polling_Active_to_Exit_to_Detect.option.at_least = _at_least_value; end
      {Polling_Compliance,Polling_Active} : begin cg.Polling_Compliance_to_Polling_Active.option.weight = _cover_weight; cg.Polling_Compliance_to_Polling_Active.option.at_least = _at_least_value; end
      {Polling_Configuration,Exit_to_Detect} : begin cg.Polling_Configuration_to_Exit_to_Detect.option.weight = _cover_weight; cg.Polling_Configuration_to_Exit_to_Detect.option.at_least = _at_least_value; end
      {Polling_Configuration,Exit_to_Configuration} : begin cg.Polling_Configuration_to_Exit_to_Configuration.option.weight = _cover_weight; cg.Polling_Configuration_to_Exit_to_Configuration.option.at_least = _at_least_value; end
      {starting,Entry_from_Detect} : begin cg.starting_to_Entry_from_Detect.option.weight = _cover_weight; cg.starting_to_Entry_from_Detect.option.at_least = _at_least_value; end
      endcase
    end
endfunction :  post_randomize


// ----------------------------------------------
// protected management functions and tasks
// ----------------------------------------------
/// weight initialization, called by the constructor
/// Defined in the graph class as it requires the state to be defined.
/// Should be pure virtual but some tools don't like pure virtual UVM classes
function void pcie_link_polling_base_sequence::init_weight(int unsigned _w);
  pcie_link_polling_state_t src,dst; 
  if ( _w > 0 ) weight_end = 0 ;
  else          weight_end = 100;
    weight[Entry_from_Detect][Polling_Active] = _w;
    weight[Polling_Active][Polling_Compliance] = _w;
    weight[Polling_Active][Polling_Configuration] = _w;
    weight[Polling_Active][Exit_to_Detect] = _w;
    weight[Polling_Compliance][Polling_Active] = _w;
    weight[Polling_Configuration][Exit_to_Detect] = _w;
    weight[Polling_Configuration][Exit_to_Configuration] = _w;
    weight[starting][Entry_from_Detect] = _w;
endfunction : init_weight

// Value getter to be used in directed constraints
function int unsigned pcie_link_polling_base_sequence::get_uint_value(int unsigned value);
  return value;
endfunction : get_uint_value

// curr_iter_idx getter

function int unsigned pcie_link_polling_base_sequence::get_current_iteration();
  return local_curr_iter_idx;
endfunction : get_current_iteration


function pcie_link_polling_state_t pcie_link_polling_base_sequence::get_current_state();
  return current_state;
endfunction : get_current_state
function pcie_link_polling_state_t pcie_link_polling_base_sequence::get_previous_state();
  return previous_state;
endfunction : get_previous_state
// ----------------------------------------------
// Coverage
// ----------------------------------------------
/// Users may override it to implement their own coverage
function int pcie_link_polling_base_sequence::get_custom_coverage();
  return 100;
endfunction : get_custom_coverage


// we need to perform some maintenance each time a transition is made
// cannot be in the base class because of the dependency on pcie_link_polling_state_t
function void pcie_link_polling_base_sequence::update_transition(pcie_link_polling_state_t _src, _dst);
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
function void pcie_link_polling_base_sequence::goto(pcie_link_polling_state_t next);
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

function void pcie_link_polling_base_sequence::prepare_context();
  if ( goto_activated ) begin 
    goto_activated = 0;
    weight[goto_from_state] = goto_saved_weight;
  end
endfunction : prepare_context

function void pcie_link_polling_base_sequence::exit();
  init_weight(0);
  weight_end = 100;

endfunction : exit

function void pcie_link_polling_base_sequence::exclude_next(pcie_link_polling_state_t next);
  if (next inside {weight[current_state]} )
    weight[current_state][next] = 0;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to exclude the next state %s",current_state,next,next))
endfunction : exclude_next

function void pcie_link_polling_base_sequence::include_next(pcie_link_polling_state_t next,int unsigned _weight=initial_edge_weight);
  if (next inside {weight[current_state]} )
    weight[current_state][next] = _weight;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the next state %s",current_state,next,next))
endfunction : include_next

function void pcie_link_polling_base_sequence::exclude_edge(pcie_link_polling_state_t src,dst);
  if (dst inside {weight[src]} )
    weight[src][dst] = 0;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the next state %s",src,dst,dst))
endfunction : exclude_edge

function void pcie_link_polling_base_sequence::include_edge(pcie_link_polling_state_t src,dst,int unsigned _weight=initial_edge_weight);
  if (dst inside {weight[src]} )
    weight[src][dst] = _weight;
  else
    `uvm_warning("INVALID_EDGE",$sformatf("Invalid edge from %s to %s while trying to include the state %s",src,dst,dst))
endfunction : include_edge

// ----------------------------------------------
// default constraints
// ----------------------------------------------
constraint pcie_link_polling_base_sequence::svgraph_base_sequence_default_c {
  weight_default_decrement < initial_edge_weight;

  soft max_iter                 == 1_000; //< Maximum default number off iterations 
  soft coverage_closure_en      == 0;     //< Coverage Closure is disable by default
  soft coverage_default_edge_at_least    == 1;     //< coverage_default_edge_at_least
  soft initial_edge_weight      == 100;   //< Default Weight for each edge
  soft weight_default_decrement == 1;     //< weight_default_decrement
}
