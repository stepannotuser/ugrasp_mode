// SVGraph my_fsm
// File    my_fsm_sequence.sv

// ----------------------------------------------
// Constructor 
// ----------------------------------------------
function my_fsm_sequence::new(string name="my_fsm_sequence");
  super.new(name);
endfunction : new


// ----------------------------------------------
// Utility Functions 
// ----------------------------------------------
function void my_fsm_sequence::goto(my_fsm_state_t next);
  super.goto(next);
endfunction : goto

function void my_fsm_sequence::exit();
  super.exit();
endfunction : exit

function void my_fsm_sequence::exclude_next(my_fsm_state_t next);
  super.exclude_next(next);
endfunction : exclude_next

function void my_fsm_sequence::include_next(my_fsm_state_t next,int unsigned _weight=initial_edge_weight);
  super.include_next(next);
endfunction : include_next

function void my_fsm_sequence::exclude_edge(my_fsm_state_t src,dst);
  super.exclude_edge(src,dst);
endfunction : exclude_edge

function void my_fsm_sequence::include_edge(my_fsm_state_t src,dst,int unsigned _weight=initial_edge_weight);
  super.include_edge(src,dst);
endfunction : include_edge


// ----------------------------------------------
// Common tasks and functions hooks
// ----------------------------------------------
function void my_fsm_sequence::state_pre_body(my_fsm_state_t state); 
endfunction
task          my_fsm_sequence::state_body(my_fsm_state_t state); 
endtask
function void my_fsm_sequence::state_post_body(my_fsm_state_t state);
endfunction


function void my_fsm_sequence::transition_pre_body(my_fsm_state_t src,dst); 
endfunction
task          my_fsm_sequence::transition_body(my_fsm_state_t src,dst); 
endtask
function void my_fsm_sequence::transition_post_body(my_fsm_state_t src,dst);
endfunction


// ----------------------------------------------
// State tasks and functions hooks
// ----------------------------------------------
// STATE:IDLE Hooks to be implemented in children classes
function void my_fsm_sequence::IDLE_pre_body();
endfunction
task          my_fsm_sequence::IDLE_body();
endtask
function void my_fsm_sequence::IDLE_post_body();
endfunction

// STATE:READ Hooks to be implemented in children classes
function void my_fsm_sequence::READ_pre_body();
endfunction
task          my_fsm_sequence::READ_body();
endtask
function void my_fsm_sequence::READ_post_body();
endfunction

// STATE:WRITE Hooks to be implemented in children classes
function void my_fsm_sequence::WRITE_pre_body();
endfunction
task          my_fsm_sequence::WRITE_body();
endtask
function void my_fsm_sequence::WRITE_post_body();
endfunction

// STATE:DONE Hooks to be implemented in children classes
function void my_fsm_sequence::DONE_pre_body();
endfunction
task          my_fsm_sequence::DONE_body();
endtask
function void my_fsm_sequence::DONE_post_body();
endfunction

// STATE:__START__ Hooks to be implemented in children classes
function void my_fsm_sequence::__START___pre_body();
endfunction
task          my_fsm_sequence::__START___body();
endtask
function void my_fsm_sequence::__START___post_body();
endfunction

// ----------------------------------------------
// Transition tasks and functions hooks
// ----------------------------------------------
// TRANSITION:IDLE to READ: Hooks to be implemented in children classes
function void my_fsm_sequence::IDLE_to_READ_pre_body();
endfunction
task          my_fsm_sequence::IDLE_to_READ_body();
endtask
function void my_fsm_sequence::IDLE_to_READ_post_body();
endfunction

// TRANSITION:READ to WRITE: Hooks to be implemented in children classes
function void my_fsm_sequence::READ_to_WRITE_pre_body();
endfunction
task          my_fsm_sequence::READ_to_WRITE_body();
endtask
function void my_fsm_sequence::READ_to_WRITE_post_body();
endfunction

// TRANSITION:WRITE to DONE: Hooks to be implemented in children classes
function void my_fsm_sequence::WRITE_to_DONE_pre_body();
endfunction
task          my_fsm_sequence::WRITE_to_DONE_body();
endtask
function void my_fsm_sequence::WRITE_to_DONE_post_body();
endfunction

// TRANSITION:DONE to DONE: Hooks to be implemented in children classes
function void my_fsm_sequence::DONE_to_DONE_pre_body();
endfunction
task          my_fsm_sequence::DONE_to_DONE_body();
endtask
function void my_fsm_sequence::DONE_to_DONE_post_body();
endfunction

// TRANSITION:__START__ to IDLE: Hooks to be implemented in children classes
function void my_fsm_sequence::__START___to_IDLE_pre_body();
endfunction
task          my_fsm_sequence::__START___to_IDLE_body();
endtask
function void my_fsm_sequence::__START___to_IDLE_post_body();
endfunction

// ----------------------------------------------
// Completion hook
// ----------------------------------------------
function void my_fsm_sequence::completion_pre_body(); 
  `uvm_info("completion_body","completion_pre_body called",UVM_MEDIUM);
endfunction 
task my_fsm_sequence::completion_body(); 
  `uvm_info("completion_body","completion_body called",UVM_MEDIUM);
endtask 

// Show coverage at the end of the sequence
function void my_fsm_sequence::completion_post_body();
    `uvm_info("completion_post_body","==================",UVM_MEDIUM);
    `uvm_info("completion_post_body","Completion        ",UVM_MEDIUM);
    `uvm_info("completion_post_body","==================",UVM_MEDIUM);
    `uvm_info("completion_post_body",$sformatf("- nr of iterations : %d",this.get_current_iteration()),UVM_MEDIUM);
    if ( get_current_iteration() >= max_iter )
      `uvm_info("completion_post_body",$sformatf("- Max iterations %d reached",this.max_iter),UVM_MEDIUM);
  `uvm_info("completion_post_body","- state      coverage: %d %%",cg.states.get_coverage());
  `uvm_info("completion_post_body","- transition coverage: %d %%",cg.transitions.get_coverage());
  `uvm_info("completion_post_body","- Total      coverage: %d %%",cg.get_coverage());
endfunction

// ----------------------------------------------
// Graph Based Sequence body
// ----------------------------------------------
task my_fsm_sequence::body();
  if (!randomization_done)
  `uvm_fatal("F_NORAND","Sequence not randomized. Please randomize the sequence before calling start()")
  randsequence(__START__)
    IDLE : IDLE_act IDLE_sel;
    READ : READ_act READ_sel;
    WRITE : WRITE_act WRITE_sel;
    DONE : DONE_act DONE_sel;
    __START__ : __START___act __START___sel;

    IDLE_act : {
      prepare_context();
      fork IDLE_pre_body(); state_pre_body(IDLE); join
      fork IDLE_body(); state_body(IDLE); join
      fork IDLE_post_body(); state_post_body(IDLE); join
    };
    READ_act : {
      prepare_context();
      fork READ_pre_body(); state_pre_body(READ); join
      fork READ_body(); state_body(READ); join
      fork READ_post_body(); state_post_body(READ); join
    };
    WRITE_act : {
      prepare_context();
      fork WRITE_pre_body(); state_pre_body(WRITE); join
      fork WRITE_body(); state_body(WRITE); join
      fork WRITE_post_body(); state_post_body(WRITE); join
    };
    DONE_act : {
      prepare_context();
      fork DONE_pre_body(); state_pre_body(DONE); join
      fork DONE_body(); state_body(DONE); join
      fork DONE_post_body(); state_post_body(DONE); join
    };
    __START___act : {
      prepare_context();
      fork __START___pre_body(); state_pre_body(__START__); join
      fork __START___body(); state_body(__START__); join
      fork __START___post_body(); state_post_body(__START__); join
    };

    IDLE_sel : _END_:=weight_end | IDLE_to_READ:=weight[IDLE][READ]; // ну вот тут вроде как четкая последовательность
    READ_sel : _END_:=weight_end | READ_to_WRITE:=weight[READ][WRITE];
    WRITE_sel : _END_:=weight_end | WRITE_to_DONE:=weight[WRITE][DONE];
    DONE_sel : _END_:=weight_end | DONE_to_DONE:=weight[DONE][DONE];
    __START___sel : _END_:=weight_end | __START___to_IDLE:=weight[__START__][IDLE]; // стартовое состояние

    IDLE_to_READ : { 
      prepare_context();
      fork IDLE_to_READ_pre_body(); transition_pre_body(IDLE,READ); join
      fork IDLE_to_READ_body(); transition_body(IDLE,READ); join
      fork IDLE_to_READ_post_body(); transition_post_body(IDLE,READ); join
      update_transition(IDLE,READ);
    } /* ... to ... */ READ;
    READ_to_WRITE : { 
      prepare_context();
      fork READ_to_WRITE_pre_body(); transition_pre_body(READ,WRITE); join
      fork READ_to_WRITE_body(); transition_body(READ,WRITE); join
      fork READ_to_WRITE_post_body(); transition_post_body(READ,WRITE); join
      update_transition(READ,WRITE);
    } /* ... to ... */ WRITE;
    WRITE_to_DONE : { 
      prepare_context();
      fork WRITE_to_DONE_pre_body(); transition_pre_body(WRITE,DONE); join
      fork WRITE_to_DONE_body(); transition_body(WRITE,DONE); join
      fork WRITE_to_DONE_post_body(); transition_post_body(WRITE,DONE); join
      update_transition(WRITE,DONE);
    } /* ... to ... */ DONE;
    DONE_to_DONE : { 
      prepare_context();
      fork DONE_to_DONE_pre_body(); transition_pre_body(DONE,DONE); join
      fork DONE_to_DONE_body(); transition_body(DONE,DONE); join
      fork DONE_to_DONE_post_body(); transition_post_body(DONE,DONE); join
      update_transition(DONE,DONE);
    } /* ... to ... */ DONE;
    __START___to_IDLE : { 
      prepare_context();
      fork __START___to_IDLE_pre_body(); transition_pre_body(__START__,IDLE); join
      fork __START___to_IDLE_body(); transition_body(__START__,IDLE); join
      fork __START___to_IDLE_post_body(); transition_post_body(__START__,IDLE); join
      update_transition(__START__,IDLE);
    } /* ... to ... */ IDLE;
    _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
  endsequence
endtask : body
