// SVGraph arp
// File    arp_sequence.sv

// ----------------------------------------------
// Constructor 
// ----------------------------------------------
function arp_sequence::new(string name="arp_sequence");
  super.new(name);
endfunction : new


// ----------------------------------------------
// Utility Functions 
// ----------------------------------------------
function void arp_sequence::goto(arp_state_t next);
  super.goto(next);
endfunction : goto
function void arp_sequence::exit();
  super.exit();
endfunction : exit

// ----------------------------------------------
// Common tasks and functions hooks
// ----------------------------------------------
function void arp_sequence::state_pre_body(arp_state_t state); 
endfunction
task          arp_sequence::state_body(arp_state_t state); 
endtask
function void arp_sequence::state_post_body(arp_state_t state);
endfunction


function void arp_sequence::transition_pre_body(arp_state_t src,dst); 
endfunction
task          arp_sequence::transition_body(arp_state_t src,dst); 
endtask
function void arp_sequence::transition_post_body(arp_state_t src,dst);
endfunction


// ----------------------------------------------
// State tasks and functions hooks
// ----------------------------------------------
// STATE:Idle Hooks to be implemented in children classes
function void arp_sequence::Idle_pre_body();
endfunction
task          arp_sequence::Idle_body();
endtask
function void arp_sequence::Idle_post_body();
endfunction

// STATE:RequestAddress Hooks to be implemented in children classes
function void arp_sequence::RequestAddress_pre_body();
endfunction
task          arp_sequence::RequestAddress_body();
endtask
function void arp_sequence::RequestAddress_post_body();
endfunction

// STATE:AddressConflict Hooks to be implemented in children classes
function void arp_sequence::AddressConflict_pre_body();
endfunction
task          arp_sequence::AddressConflict_body();
endtask
function void arp_sequence::AddressConflict_post_body();
endfunction

// STATE:AssignAddress Hooks to be implemented in children classes
function void arp_sequence::AssignAddress_pre_body();
endfunction
task          arp_sequence::AssignAddress_body();
endtask
function void arp_sequence::AssignAddress_post_body();
endfunction

// STATE:Ready Hooks to be implemented in children classes
function void arp_sequence::Ready_pre_body();
endfunction
task          arp_sequence::Ready_body();
endtask
function void arp_sequence::Ready_post_body();
endfunction

// STATE:starting Hooks to be implemented in children classes
function void arp_sequence::starting_pre_body();
endfunction
task          arp_sequence::starting_body();
endtask
function void arp_sequence::starting_post_body();
endfunction

// ----------------------------------------------
// Transition tasks and functions hooks
// ----------------------------------------------
// TRANSITION:Idle to RequestAddress: Hooks to be implemented in children classes
function void arp_sequence::Idle_to_RequestAddress_pre_body();
endfunction
task          arp_sequence::Idle_to_RequestAddress_body();
endtask
function void arp_sequence::Idle_to_RequestAddress_post_body();
endfunction

// TRANSITION:RequestAddress to AddressConflict: Hooks to be implemented in children classes
function void arp_sequence::RequestAddress_to_AddressConflict_pre_body();
endfunction
task          arp_sequence::RequestAddress_to_AddressConflict_body();
endtask
function void arp_sequence::RequestAddress_to_AddressConflict_post_body();
endfunction

// TRANSITION:RequestAddress to AssignAddress: Hooks to be implemented in children classes
function void arp_sequence::RequestAddress_to_AssignAddress_pre_body();
endfunction
task          arp_sequence::RequestAddress_to_AssignAddress_body();
endtask
function void arp_sequence::RequestAddress_to_AssignAddress_post_body();
endfunction

// TRANSITION:AddressConflict to RequestAddress: Hooks to be implemented in children classes
function void arp_sequence::AddressConflict_to_RequestAddress_pre_body();
endfunction
task          arp_sequence::AddressConflict_to_RequestAddress_body();
endtask
function void arp_sequence::AddressConflict_to_RequestAddress_post_body();
endfunction

// TRANSITION:AssignAddress to Ready: Hooks to be implemented in children classes
function void arp_sequence::AssignAddress_to_Ready_pre_body();
endfunction
task          arp_sequence::AssignAddress_to_Ready_body();
endtask
function void arp_sequence::AssignAddress_to_Ready_post_body();
endfunction

// TRANSITION:Ready to Idle: Hooks to be implemented in children classes
function void arp_sequence::Ready_to_Idle_pre_body();
endfunction
task          arp_sequence::Ready_to_Idle_body();
endtask
function void arp_sequence::Ready_to_Idle_post_body();
endfunction

// TRANSITION:starting to Idle: Hooks to be implemented in children classes
function void arp_sequence::starting_to_Idle_pre_body();
endfunction
task          arp_sequence::starting_to_Idle_body();
endtask
function void arp_sequence::starting_to_Idle_post_body();
endfunction

// ----------------------------------------------
// Completion hook
// ----------------------------------------------
function void arp_sequence::completion_pre_body(); 
  `uvm_info("completion_body","completion_pre_body called",UVM_MEDIUM);
endfunction 
task arp_sequence::completion_body(); 
  `uvm_info("completion_body","completion_body called",UVM_MEDIUM);
endtask 

// Show coverage at the end of the sequence
function void arp_sequence::completion_post_body();
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
task arp_sequence::body();
  randsequence(starting)
    Idle : Idle_act Idle_sel;
    RequestAddress : RequestAddress_act RequestAddress_sel;
    AddressConflict : AddressConflict_act AddressConflict_sel;
    AssignAddress : AssignAddress_act AssignAddress_sel;
    Ready : Ready_act Ready_sel;
    starting : starting_act starting_sel;

    Idle_act : {
      prepare_context();
      fork Idle_pre_body(); state_pre_body(Idle); join
      fork Idle_body(); state_body(Idle); join
      fork Idle_post_body(); state_post_body(Idle); join
    };
    RequestAddress_act : {
      prepare_context();
      fork RequestAddress_pre_body(); state_pre_body(RequestAddress); join
      fork RequestAddress_body(); state_body(RequestAddress); join
      fork RequestAddress_post_body(); state_post_body(RequestAddress); join
    };
    AddressConflict_act : {
      prepare_context();
      fork AddressConflict_pre_body(); state_pre_body(AddressConflict); join
      fork AddressConflict_body(); state_body(AddressConflict); join
      fork AddressConflict_post_body(); state_post_body(AddressConflict); join
    };
    AssignAddress_act : {
      prepare_context();
      fork AssignAddress_pre_body(); state_pre_body(AssignAddress); join
      fork AssignAddress_body(); state_body(AssignAddress); join
      fork AssignAddress_post_body(); state_post_body(AssignAddress); join
    };
    Ready_act : {
      prepare_context();
      fork Ready_pre_body(); state_pre_body(Ready); join
      fork Ready_body(); state_body(Ready); join
      fork Ready_post_body(); state_post_body(Ready); join
    };
    starting_act : {
      prepare_context();
      fork starting_pre_body(); state_pre_body(starting); join
      fork starting_body(); state_body(starting); join
      fork starting_post_body(); state_post_body(starting); join
    };

    Idle_sel : _END_:=weight_end | Idle_to_RequestAddress:=weight[Idle][RequestAddress];
    RequestAddress_sel : _END_:=weight_end | RequestAddress_to_AddressConflict:=weight[RequestAddress][AddressConflict] | RequestAddress_to_AssignAddress:=weight[RequestAddress][AssignAddress];
    AddressConflict_sel : _END_:=weight_end | AddressConflict_to_RequestAddress:=weight[AddressConflict][RequestAddress];
    AssignAddress_sel : _END_:=weight_end | AssignAddress_to_Ready:=weight[AssignAddress][Ready];
    Ready_sel : _END_:=weight_end | Ready_to_Idle:=weight[Ready][Idle];
    starting_sel : _END_:=weight_end | starting_to_Idle:=weight[starting][Idle];

    Idle_to_RequestAddress : { 
      prepare_context();
      fork Idle_to_RequestAddress_pre_body(); transition_pre_body(Idle,RequestAddress); join
      fork Idle_to_RequestAddress_body(); transition_body(Idle,RequestAddress); join
      fork Idle_to_RequestAddress_post_body(); transition_post_body(Idle,RequestAddress); join
      update_transition(Idle,RequestAddress);
    } /* ... to ... */ RequestAddress;
    RequestAddress_to_AddressConflict : { 
      prepare_context();
      fork RequestAddress_to_AddressConflict_pre_body(); transition_pre_body(RequestAddress,AddressConflict); join
      fork RequestAddress_to_AddressConflict_body(); transition_body(RequestAddress,AddressConflict); join
      fork RequestAddress_to_AddressConflict_post_body(); transition_post_body(RequestAddress,AddressConflict); join
      update_transition(RequestAddress,AddressConflict);
    } /* ... to ... */ AddressConflict;
    RequestAddress_to_AssignAddress : { 
      prepare_context();
      fork RequestAddress_to_AssignAddress_pre_body(); transition_pre_body(RequestAddress,AssignAddress); join
      fork RequestAddress_to_AssignAddress_body(); transition_body(RequestAddress,AssignAddress); join
      fork RequestAddress_to_AssignAddress_post_body(); transition_post_body(RequestAddress,AssignAddress); join
      update_transition(RequestAddress,AssignAddress);
    } /* ... to ... */ AssignAddress;
    AddressConflict_to_RequestAddress : { 
      prepare_context();
      fork AddressConflict_to_RequestAddress_pre_body(); transition_pre_body(AddressConflict,RequestAddress); join
      fork AddressConflict_to_RequestAddress_body(); transition_body(AddressConflict,RequestAddress); join
      fork AddressConflict_to_RequestAddress_post_body(); transition_post_body(AddressConflict,RequestAddress); join
      update_transition(AddressConflict,RequestAddress);
    } /* ... to ... */ RequestAddress;
    AssignAddress_to_Ready : { 
      prepare_context();
      fork AssignAddress_to_Ready_pre_body(); transition_pre_body(AssignAddress,Ready); join
      fork AssignAddress_to_Ready_body(); transition_body(AssignAddress,Ready); join
      fork AssignAddress_to_Ready_post_body(); transition_post_body(AssignAddress,Ready); join
      update_transition(AssignAddress,Ready);
    } /* ... to ... */ Ready;
    Ready_to_Idle : { 
      prepare_context();
      fork Ready_to_Idle_pre_body(); transition_pre_body(Ready,Idle); join
      fork Ready_to_Idle_body(); transition_body(Ready,Idle); join
      fork Ready_to_Idle_post_body(); transition_post_body(Ready,Idle); join
      update_transition(Ready,Idle);
    } /* ... to ... */ Idle;
    starting_to_Idle : { 
      prepare_context();
      fork starting_to_Idle_pre_body(); transition_pre_body(starting,Idle); join
      fork starting_to_Idle_body(); transition_body(starting,Idle); join
      fork starting_to_Idle_post_body(); transition_post_body(starting,Idle); join
      update_transition(starting,Idle);
    } /* ... to ... */ Idle;
    _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
  endsequence
endtask : body
