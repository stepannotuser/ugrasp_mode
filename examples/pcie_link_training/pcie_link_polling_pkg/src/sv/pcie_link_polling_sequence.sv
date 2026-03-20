// SVGraph pcie_link_polling
// File    pcie_link_polling_sequence.sv

// ----------------------------------------------
// Constructor 
// ----------------------------------------------
function pcie_link_polling_sequence::new(string name="pcie_link_polling_sequence");
  super.new(name);
endfunction : new


// ----------------------------------------------
// Utility Functions 
// ----------------------------------------------
function void pcie_link_polling_sequence::goto(pcie_link_polling_state_t next);
  super.goto(next);
endfunction : goto
function void pcie_link_polling_sequence::exit();
  super.exit();
endfunction : exit

// ----------------------------------------------
// Common tasks and functions hooks
// ----------------------------------------------
function void pcie_link_polling_sequence::state_pre_body(pcie_link_polling_state_t state); 
endfunction
task          pcie_link_polling_sequence::state_body(pcie_link_polling_state_t state); 
endtask
function void pcie_link_polling_sequence::state_post_body(pcie_link_polling_state_t state);
endfunction


function void pcie_link_polling_sequence::transition_pre_body(pcie_link_polling_state_t src,dst); 
endfunction
task          pcie_link_polling_sequence::transition_body(pcie_link_polling_state_t src,dst); 
endtask
function void pcie_link_polling_sequence::transition_post_body(pcie_link_polling_state_t src,dst);
endfunction


// ----------------------------------------------
// State tasks and functions hooks
// ----------------------------------------------
// STATE:Entry_from_Detect Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Entry_from_Detect_pre_body();
endfunction
task          pcie_link_polling_sequence::Entry_from_Detect_body();
endtask
function void pcie_link_polling_sequence::Entry_from_Detect_post_body();
endfunction

// STATE:Polling_Active Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Active_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Active_body();
endtask
function void pcie_link_polling_sequence::Polling_Active_post_body();
endfunction

// STATE:Polling_Compliance Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Compliance_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Compliance_body();
endtask
function void pcie_link_polling_sequence::Polling_Compliance_post_body();
endfunction

// STATE:Polling_Configuration Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Configuration_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Configuration_body();
endtask
function void pcie_link_polling_sequence::Polling_Configuration_post_body();
endfunction

// STATE:Exit_to_Detect Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Exit_to_Detect_pre_body();
endfunction
task          pcie_link_polling_sequence::Exit_to_Detect_body();
endtask
function void pcie_link_polling_sequence::Exit_to_Detect_post_body();
endfunction

// STATE:Exit_to_Configuration Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Exit_to_Configuration_pre_body();
endfunction
task          pcie_link_polling_sequence::Exit_to_Configuration_body();
endtask
function void pcie_link_polling_sequence::Exit_to_Configuration_post_body();
endfunction

// STATE:starting Hooks to be implemented in children classes
function void pcie_link_polling_sequence::starting_pre_body();
endfunction
task          pcie_link_polling_sequence::starting_body();
endtask
function void pcie_link_polling_sequence::starting_post_body();
endfunction

// ----------------------------------------------
// Transition tasks and functions hooks
// ----------------------------------------------
// TRANSITION:Entry_from_Detect to Polling_Active: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Entry_from_Detect_to_Polling_Active_pre_body();
endfunction
task          pcie_link_polling_sequence::Entry_from_Detect_to_Polling_Active_body();
endtask
function void pcie_link_polling_sequence::Entry_from_Detect_to_Polling_Active_post_body();
endfunction

// TRANSITION:Polling_Active to Polling_Compliance: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Active_to_Polling_Compliance_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Active_to_Polling_Compliance_body();
endtask
function void pcie_link_polling_sequence::Polling_Active_to_Polling_Compliance_post_body();
endfunction

// TRANSITION:Polling_Active to Polling_Configuration: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Active_to_Polling_Configuration_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Active_to_Polling_Configuration_body();
endtask
function void pcie_link_polling_sequence::Polling_Active_to_Polling_Configuration_post_body();
endfunction

// TRANSITION:Polling_Active to Exit_to_Detect: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Active_to_Exit_to_Detect_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Active_to_Exit_to_Detect_body();
endtask
function void pcie_link_polling_sequence::Polling_Active_to_Exit_to_Detect_post_body();
endfunction

// TRANSITION:Polling_Compliance to Polling_Active: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Compliance_to_Polling_Active_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Compliance_to_Polling_Active_body();
endtask
function void pcie_link_polling_sequence::Polling_Compliance_to_Polling_Active_post_body();
endfunction

// TRANSITION:Polling_Configuration to Exit_to_Detect: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Detect_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Detect_body();
endtask
function void pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Detect_post_body();
endfunction

// TRANSITION:Polling_Configuration to Exit_to_Configuration: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Configuration_pre_body();
endfunction
task          pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Configuration_body();
endtask
function void pcie_link_polling_sequence::Polling_Configuration_to_Exit_to_Configuration_post_body();
endfunction

// TRANSITION:starting to Entry_from_Detect: Hooks to be implemented in children classes
function void pcie_link_polling_sequence::starting_to_Entry_from_Detect_pre_body();
endfunction
task          pcie_link_polling_sequence::starting_to_Entry_from_Detect_body();
endtask
function void pcie_link_polling_sequence::starting_to_Entry_from_Detect_post_body();
endfunction

// ----------------------------------------------
// Completion hook
// ----------------------------------------------
function void pcie_link_polling_sequence::completion_pre_body(); 
  `uvm_info("completion_body","completion_pre_body called",UVM_MEDIUM);
endfunction 
task pcie_link_polling_sequence::completion_body(); 
  `uvm_info("completion_body","completion_body called",UVM_MEDIUM);
endtask 

// Show coverage at the end of the sequence
function void pcie_link_polling_sequence::completion_post_body();
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
task pcie_link_polling_sequence::body();
  randsequence(starting)
    Entry_from_Detect : Entry_from_Detect_act Entry_from_Detect_sel;
    Polling_Active : Polling_Active_act Polling_Active_sel;
    Polling_Compliance : Polling_Compliance_act Polling_Compliance_sel;
    Polling_Configuration : Polling_Configuration_act Polling_Configuration_sel;
    Exit_to_Detect : Exit_to_Detect_act Exit_to_Detect_sel;
    Exit_to_Configuration : Exit_to_Configuration_act Exit_to_Configuration_sel;
    starting : starting_act starting_sel;

    Entry_from_Detect_act : {
      prepare_context();
      fork Entry_from_Detect_pre_body(); state_pre_body(Entry_from_Detect); join
      fork Entry_from_Detect_body(); state_body(Entry_from_Detect); join
      fork Entry_from_Detect_post_body(); state_post_body(Entry_from_Detect); join
    };
    Polling_Active_act : {
      prepare_context();
      fork Polling_Active_pre_body(); state_pre_body(Polling_Active); join
      fork Polling_Active_body(); state_body(Polling_Active); join
      fork Polling_Active_post_body(); state_post_body(Polling_Active); join
    };
    Polling_Compliance_act : {
      prepare_context();
      fork Polling_Compliance_pre_body(); state_pre_body(Polling_Compliance); join
      fork Polling_Compliance_body(); state_body(Polling_Compliance); join
      fork Polling_Compliance_post_body(); state_post_body(Polling_Compliance); join
    };
    Polling_Configuration_act : {
      prepare_context();
      fork Polling_Configuration_pre_body(); state_pre_body(Polling_Configuration); join
      fork Polling_Configuration_body(); state_body(Polling_Configuration); join
      fork Polling_Configuration_post_body(); state_post_body(Polling_Configuration); join
    };
    Exit_to_Detect_act : {
      prepare_context();
      fork Exit_to_Detect_pre_body(); state_pre_body(Exit_to_Detect); join
      fork Exit_to_Detect_body(); state_body(Exit_to_Detect); join
      fork Exit_to_Detect_post_body(); state_post_body(Exit_to_Detect); join
    };
    Exit_to_Configuration_act : {
      prepare_context();
      fork Exit_to_Configuration_pre_body(); state_pre_body(Exit_to_Configuration); join
      fork Exit_to_Configuration_body(); state_body(Exit_to_Configuration); join
      fork Exit_to_Configuration_post_body(); state_post_body(Exit_to_Configuration); join
    };
    starting_act : {
      prepare_context();
      fork starting_pre_body(); state_pre_body(starting); join
      fork starting_body(); state_body(starting); join
      fork starting_post_body(); state_post_body(starting); join
    };

    Entry_from_Detect_sel : _END_:=weight_end | Entry_from_Detect_to_Polling_Active:=weight[Entry_from_Detect][Polling_Active];
    Polling_Active_sel : _END_:=weight_end | Polling_Active_to_Polling_Compliance:=weight[Polling_Active][Polling_Compliance] | Polling_Active_to_Polling_Configuration:=weight[Polling_Active][Polling_Configuration] | Polling_Active_to_Exit_to_Detect:=weight[Polling_Active][Exit_to_Detect];
    Polling_Compliance_sel : _END_:=weight_end | Polling_Compliance_to_Polling_Active:=weight[Polling_Compliance][Polling_Active];
    Polling_Configuration_sel : _END_:=weight_end | Polling_Configuration_to_Exit_to_Detect:=weight[Polling_Configuration][Exit_to_Detect] | Polling_Configuration_to_Exit_to_Configuration:=weight[Polling_Configuration][Exit_to_Configuration];
    Exit_to_Detect_sel : _END_:=weight_end;
    Exit_to_Configuration_sel : _END_:=weight_end;
    starting_sel : _END_:=weight_end | starting_to_Entry_from_Detect:=weight[starting][Entry_from_Detect];

    Entry_from_Detect_to_Polling_Active : { 
      prepare_context();
      fork Entry_from_Detect_to_Polling_Active_pre_body(); transition_pre_body(Entry_from_Detect,Polling_Active); join
      fork Entry_from_Detect_to_Polling_Active_body(); transition_body(Entry_from_Detect,Polling_Active); join
      fork Entry_from_Detect_to_Polling_Active_post_body(); transition_post_body(Entry_from_Detect,Polling_Active); join
      update_transition(Entry_from_Detect,Polling_Active);
    } /* ... to ... */ Polling_Active;
    Polling_Active_to_Polling_Compliance : { 
      prepare_context();
      fork Polling_Active_to_Polling_Compliance_pre_body(); transition_pre_body(Polling_Active,Polling_Compliance); join
      fork Polling_Active_to_Polling_Compliance_body(); transition_body(Polling_Active,Polling_Compliance); join
      fork Polling_Active_to_Polling_Compliance_post_body(); transition_post_body(Polling_Active,Polling_Compliance); join
      update_transition(Polling_Active,Polling_Compliance);
    } /* ... to ... */ Polling_Compliance;
    Polling_Active_to_Polling_Configuration : { 
      prepare_context();
      fork Polling_Active_to_Polling_Configuration_pre_body(); transition_pre_body(Polling_Active,Polling_Configuration); join
      fork Polling_Active_to_Polling_Configuration_body(); transition_body(Polling_Active,Polling_Configuration); join
      fork Polling_Active_to_Polling_Configuration_post_body(); transition_post_body(Polling_Active,Polling_Configuration); join
      update_transition(Polling_Active,Polling_Configuration);
    } /* ... to ... */ Polling_Configuration;
    Polling_Active_to_Exit_to_Detect : { 
      prepare_context();
      fork Polling_Active_to_Exit_to_Detect_pre_body(); transition_pre_body(Polling_Active,Exit_to_Detect); join
      fork Polling_Active_to_Exit_to_Detect_body(); transition_body(Polling_Active,Exit_to_Detect); join
      fork Polling_Active_to_Exit_to_Detect_post_body(); transition_post_body(Polling_Active,Exit_to_Detect); join
      update_transition(Polling_Active,Exit_to_Detect);
    } /* ... to ... */ Exit_to_Detect;
    Polling_Compliance_to_Polling_Active : { 
      prepare_context();
      fork Polling_Compliance_to_Polling_Active_pre_body(); transition_pre_body(Polling_Compliance,Polling_Active); join
      fork Polling_Compliance_to_Polling_Active_body(); transition_body(Polling_Compliance,Polling_Active); join
      fork Polling_Compliance_to_Polling_Active_post_body(); transition_post_body(Polling_Compliance,Polling_Active); join
      update_transition(Polling_Compliance,Polling_Active);
    } /* ... to ... */ Polling_Active;
    Polling_Configuration_to_Exit_to_Detect : { 
      prepare_context();
      fork Polling_Configuration_to_Exit_to_Detect_pre_body(); transition_pre_body(Polling_Configuration,Exit_to_Detect); join
      fork Polling_Configuration_to_Exit_to_Detect_body(); transition_body(Polling_Configuration,Exit_to_Detect); join
      fork Polling_Configuration_to_Exit_to_Detect_post_body(); transition_post_body(Polling_Configuration,Exit_to_Detect); join
      update_transition(Polling_Configuration,Exit_to_Detect);
    } /* ... to ... */ Exit_to_Detect;
    Polling_Configuration_to_Exit_to_Configuration : { 
      prepare_context();
      fork Polling_Configuration_to_Exit_to_Configuration_pre_body(); transition_pre_body(Polling_Configuration,Exit_to_Configuration); join
      fork Polling_Configuration_to_Exit_to_Configuration_body(); transition_body(Polling_Configuration,Exit_to_Configuration); join
      fork Polling_Configuration_to_Exit_to_Configuration_post_body(); transition_post_body(Polling_Configuration,Exit_to_Configuration); join
      update_transition(Polling_Configuration,Exit_to_Configuration);
    } /* ... to ... */ Exit_to_Configuration;
    starting_to_Entry_from_Detect : { 
      prepare_context();
      fork starting_to_Entry_from_Detect_pre_body(); transition_pre_body(starting,Entry_from_Detect); join
      fork starting_to_Entry_from_Detect_body(); transition_body(starting,Entry_from_Detect); join
      fork starting_to_Entry_from_Detect_post_body(); transition_post_body(starting,Entry_from_Detect); join
      update_transition(starting,Entry_from_Detect);
    } /* ... to ... */ Entry_from_Detect;
    _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
  endsequence
endtask : body
