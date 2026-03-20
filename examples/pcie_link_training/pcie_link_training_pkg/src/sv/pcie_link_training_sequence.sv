// SVGraph pcie_link_training
// File    pcie_link_training_sequence.sv

// ----------------------------------------------
// Constructor 
// ----------------------------------------------
function pcie_link_training_sequence::new(string name="pcie_link_training_sequence");
  super.new(name);
endfunction : new


// ----------------------------------------------
// Utility Functions 
// ----------------------------------------------
function void pcie_link_training_sequence::goto(pcie_link_training_state_t next);
  super.goto(next);
endfunction : goto
function void pcie_link_training_sequence::exit();
  super.exit();
endfunction : exit

// ----------------------------------------------
// Common tasks and functions hooks
// ----------------------------------------------
function void pcie_link_training_sequence::state_pre_body(pcie_link_training_state_t state); 
endfunction
task          pcie_link_training_sequence::state_body(pcie_link_training_state_t state); 
endtask
function void pcie_link_training_sequence::state_post_body(pcie_link_training_state_t state);
endfunction


function void pcie_link_training_sequence::transition_pre_body(pcie_link_training_state_t src,dst); 
endfunction
task          pcie_link_training_sequence::transition_body(pcie_link_training_state_t src,dst); 
endtask
function void pcie_link_training_sequence::transition_post_body(pcie_link_training_state_t src,dst);
endfunction


// ----------------------------------------------
// State tasks and functions hooks
// ----------------------------------------------
// STATE:Detect Hooks to be implemented in children classes
function void pcie_link_training_sequence::Detect_pre_body();
endfunction
task          pcie_link_training_sequence::Detect_body();
endtask
function void pcie_link_training_sequence::Detect_post_body();
endfunction

// STATE:Polling Hooks to be implemented in children classes
function void pcie_link_training_sequence::Polling_pre_body();
endfunction
task          pcie_link_training_sequence::Polling_body();
endtask
function void pcie_link_training_sequence::Polling_post_body();
endfunction

// STATE:Configuration Hooks to be implemented in children classes
function void pcie_link_training_sequence::Configuration_pre_body();
endfunction
task          pcie_link_training_sequence::Configuration_body();
endtask
function void pcie_link_training_sequence::Configuration_post_body();
endfunction

// STATE:L0 Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0_pre_body();
endfunction
task          pcie_link_training_sequence::L0_body();
endtask
function void pcie_link_training_sequence::L0_post_body();
endfunction

// STATE:Recovery Hooks to be implemented in children classes
function void pcie_link_training_sequence::Recovery_pre_body();
endfunction
task          pcie_link_training_sequence::Recovery_body();
endtask
function void pcie_link_training_sequence::Recovery_post_body();
endfunction

// STATE:L1 Hooks to be implemented in children classes
function void pcie_link_training_sequence::L1_pre_body();
endfunction
task          pcie_link_training_sequence::L1_body();
endtask
function void pcie_link_training_sequence::L1_post_body();
endfunction

// STATE:L0s Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0s_pre_body();
endfunction
task          pcie_link_training_sequence::L0s_body();
endtask
function void pcie_link_training_sequence::L0s_post_body();
endfunction

// STATE:L2 Hooks to be implemented in children classes
function void pcie_link_training_sequence::L2_pre_body();
endfunction
task          pcie_link_training_sequence::L2_body();
endtask
function void pcie_link_training_sequence::L2_post_body();
endfunction

// STATE:starting Hooks to be implemented in children classes
function void pcie_link_training_sequence::starting_pre_body();
endfunction
task          pcie_link_training_sequence::starting_body();
endtask
function void pcie_link_training_sequence::starting_post_body();
endfunction

// ----------------------------------------------
// Transition tasks and functions hooks
// ----------------------------------------------
// TRANSITION:Detect to Polling: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Detect_to_Polling_pre_body();
endfunction
task          pcie_link_training_sequence::Detect_to_Polling_body();
endtask
function void pcie_link_training_sequence::Detect_to_Polling_post_body();
endfunction

// TRANSITION:Polling to Detect: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Polling_to_Detect_pre_body();
endfunction
task          pcie_link_training_sequence::Polling_to_Detect_body();
endtask
function void pcie_link_training_sequence::Polling_to_Detect_post_body();
endfunction

// TRANSITION:Polling to Configuration: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Polling_to_Configuration_pre_body();
endfunction
task          pcie_link_training_sequence::Polling_to_Configuration_body();
endtask
function void pcie_link_training_sequence::Polling_to_Configuration_post_body();
endfunction

// TRANSITION:Configuration to L0: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Configuration_to_L0_pre_body();
endfunction
task          pcie_link_training_sequence::Configuration_to_L0_body();
endtask
function void pcie_link_training_sequence::Configuration_to_L0_post_body();
endfunction

// TRANSITION:Configuration to Recovery: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Configuration_to_Recovery_pre_body();
endfunction
task          pcie_link_training_sequence::Configuration_to_Recovery_body();
endtask
function void pcie_link_training_sequence::Configuration_to_Recovery_post_body();
endfunction

// TRANSITION:Configuration to Detect: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Configuration_to_Detect_pre_body();
endfunction
task          pcie_link_training_sequence::Configuration_to_Detect_body();
endtask
function void pcie_link_training_sequence::Configuration_to_Detect_post_body();
endfunction

// TRANSITION:L0 to L1: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0_to_L1_pre_body();
endfunction
task          pcie_link_training_sequence::L0_to_L1_body();
endtask
function void pcie_link_training_sequence::L0_to_L1_post_body();
endfunction

// TRANSITION:L0 to L0s: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0_to_L0s_pre_body();
endfunction
task          pcie_link_training_sequence::L0_to_L0s_body();
endtask
function void pcie_link_training_sequence::L0_to_L0s_post_body();
endfunction

// TRANSITION:L0 to L2: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0_to_L2_pre_body();
endfunction
task          pcie_link_training_sequence::L0_to_L2_body();
endtask
function void pcie_link_training_sequence::L0_to_L2_post_body();
endfunction

// TRANSITION:L0 to Recovery: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0_to_Recovery_pre_body();
endfunction
task          pcie_link_training_sequence::L0_to_Recovery_body();
endtask
function void pcie_link_training_sequence::L0_to_Recovery_post_body();
endfunction

// TRANSITION:Recovery to Configuration: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Recovery_to_Configuration_pre_body();
endfunction
task          pcie_link_training_sequence::Recovery_to_Configuration_body();
endtask
function void pcie_link_training_sequence::Recovery_to_Configuration_post_body();
endfunction

// TRANSITION:Recovery to L0: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Recovery_to_L0_pre_body();
endfunction
task          pcie_link_training_sequence::Recovery_to_L0_body();
endtask
function void pcie_link_training_sequence::Recovery_to_L0_post_body();
endfunction

// TRANSITION:Recovery to Detect: Hooks to be implemented in children classes
function void pcie_link_training_sequence::Recovery_to_Detect_pre_body();
endfunction
task          pcie_link_training_sequence::Recovery_to_Detect_body();
endtask
function void pcie_link_training_sequence::Recovery_to_Detect_post_body();
endfunction

// TRANSITION:L1 to Recovery: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L1_to_Recovery_pre_body();
endfunction
task          pcie_link_training_sequence::L1_to_Recovery_body();
endtask
function void pcie_link_training_sequence::L1_to_Recovery_post_body();
endfunction

// TRANSITION:L0s to L0: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0s_to_L0_pre_body();
endfunction
task          pcie_link_training_sequence::L0s_to_L0_body();
endtask
function void pcie_link_training_sequence::L0s_to_L0_post_body();
endfunction

// TRANSITION:L0s to Recovery: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L0s_to_Recovery_pre_body();
endfunction
task          pcie_link_training_sequence::L0s_to_Recovery_body();
endtask
function void pcie_link_training_sequence::L0s_to_Recovery_post_body();
endfunction

// TRANSITION:L2 to Detect: Hooks to be implemented in children classes
function void pcie_link_training_sequence::L2_to_Detect_pre_body();
endfunction
task          pcie_link_training_sequence::L2_to_Detect_body();
endtask
function void pcie_link_training_sequence::L2_to_Detect_post_body();
endfunction

// TRANSITION:starting to Detect: Hooks to be implemented in children classes
function void pcie_link_training_sequence::starting_to_Detect_pre_body();
endfunction
task          pcie_link_training_sequence::starting_to_Detect_body();
endtask
function void pcie_link_training_sequence::starting_to_Detect_post_body();
endfunction

// ----------------------------------------------
// Completion hook
// ----------------------------------------------
function void pcie_link_training_sequence::completion_pre_body(); 
  `uvm_info("completion_body","completion_pre_body called",UVM_MEDIUM);
endfunction 
task pcie_link_training_sequence::completion_body(); 
  `uvm_info("completion_body","completion_body called",UVM_MEDIUM);
endtask 

// Show coverage at the end of the sequence
function void pcie_link_training_sequence::completion_post_body();
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
task pcie_link_training_sequence::body();
  randsequence(starting)
    Detect : Detect_act Detect_sel;
    Polling : Polling_act Polling_sel;
    Configuration : Configuration_act Configuration_sel;
    L0 : L0_act L0_sel;
    Recovery : Recovery_act Recovery_sel;
    L1 : L1_act L1_sel;
    L0s : L0s_act L0s_sel;
    L2 : L2_act L2_sel;
    starting : starting_act starting_sel;

    Detect_act : {
      prepare_context();
      fork Detect_pre_body(); state_pre_body(Detect); join
      fork Detect_body(); state_body(Detect); join
      fork Detect_post_body(); state_post_body(Detect); join
    };
    Polling_act : {
      prepare_context();
      fork Polling_pre_body(); state_pre_body(Polling); join
      fork Polling_body(); state_body(Polling); join
      fork Polling_post_body(); state_post_body(Polling); join
    };
    Configuration_act : {
      prepare_context();
      fork Configuration_pre_body(); state_pre_body(Configuration); join
      fork Configuration_body(); state_body(Configuration); join
      fork Configuration_post_body(); state_post_body(Configuration); join
    };
    L0_act : {
      prepare_context();
      fork L0_pre_body(); state_pre_body(L0); join
      fork L0_body(); state_body(L0); join
      fork L0_post_body(); state_post_body(L0); join
    };
    Recovery_act : {
      prepare_context();
      fork Recovery_pre_body(); state_pre_body(Recovery); join
      fork Recovery_body(); state_body(Recovery); join
      fork Recovery_post_body(); state_post_body(Recovery); join
    };
    L1_act : {
      prepare_context();
      fork L1_pre_body(); state_pre_body(L1); join
      fork L1_body(); state_body(L1); join
      fork L1_post_body(); state_post_body(L1); join
    };
    L0s_act : {
      prepare_context();
      fork L0s_pre_body(); state_pre_body(L0s); join
      fork L0s_body(); state_body(L0s); join
      fork L0s_post_body(); state_post_body(L0s); join
    };
    L2_act : {
      prepare_context();
      fork L2_pre_body(); state_pre_body(L2); join
      fork L2_body(); state_body(L2); join
      fork L2_post_body(); state_post_body(L2); join
    };
    starting_act : {
      prepare_context();
      fork starting_pre_body(); state_pre_body(starting); join
      fork starting_body(); state_body(starting); join
      fork starting_post_body(); state_post_body(starting); join
    };

    Detect_sel : _END_:=weight_end | Detect_to_Polling:=weight[Detect][Polling];
    Polling_sel : _END_:=weight_end | Polling_to_Detect:=weight[Polling][Detect] | Polling_to_Configuration:=weight[Polling][Configuration];
    Configuration_sel : _END_:=weight_end | Configuration_to_L0:=weight[Configuration][L0] | Configuration_to_Recovery:=weight[Configuration][Recovery] | Configuration_to_Detect:=weight[Configuration][Detect];
    L0_sel : _END_:=weight_end | L0_to_L1:=weight[L0][L1] | L0_to_L0s:=weight[L0][L0s] | L0_to_L2:=weight[L0][L2] | L0_to_Recovery:=weight[L0][Recovery];
    Recovery_sel : _END_:=weight_end | Recovery_to_Configuration:=weight[Recovery][Configuration] | Recovery_to_L0:=weight[Recovery][L0] | Recovery_to_Detect:=weight[Recovery][Detect];
    L1_sel : _END_:=weight_end | L1_to_Recovery:=weight[L1][Recovery];
    L0s_sel : _END_:=weight_end | L0s_to_L0:=weight[L0s][L0] | L0s_to_Recovery:=weight[L0s][Recovery];
    L2_sel : _END_:=weight_end | L2_to_Detect:=weight[L2][Detect];
    starting_sel : _END_:=weight_end | starting_to_Detect:=weight[starting][Detect];

    Detect_to_Polling : { 
      prepare_context();
      fork Detect_to_Polling_pre_body(); transition_pre_body(Detect,Polling); join
      fork Detect_to_Polling_body(); transition_body(Detect,Polling); join
      fork Detect_to_Polling_post_body(); transition_post_body(Detect,Polling); join
      update_transition(Detect,Polling);
    } /* ... to ... */ Polling;
    Polling_to_Detect : { 
      prepare_context();
      fork Polling_to_Detect_pre_body(); transition_pre_body(Polling,Detect); join
      fork Polling_to_Detect_body(); transition_body(Polling,Detect); join
      fork Polling_to_Detect_post_body(); transition_post_body(Polling,Detect); join
      update_transition(Polling,Detect);
    } /* ... to ... */ Detect;
    Polling_to_Configuration : { 
      prepare_context();
      fork Polling_to_Configuration_pre_body(); transition_pre_body(Polling,Configuration); join
      fork Polling_to_Configuration_body(); transition_body(Polling,Configuration); join
      fork Polling_to_Configuration_post_body(); transition_post_body(Polling,Configuration); join
      update_transition(Polling,Configuration);
    } /* ... to ... */ Configuration;
    Configuration_to_L0 : { 
      prepare_context();
      fork Configuration_to_L0_pre_body(); transition_pre_body(Configuration,L0); join
      fork Configuration_to_L0_body(); transition_body(Configuration,L0); join
      fork Configuration_to_L0_post_body(); transition_post_body(Configuration,L0); join
      update_transition(Configuration,L0);
    } /* ... to ... */ L0;
    Configuration_to_Recovery : { 
      prepare_context();
      fork Configuration_to_Recovery_pre_body(); transition_pre_body(Configuration,Recovery); join
      fork Configuration_to_Recovery_body(); transition_body(Configuration,Recovery); join
      fork Configuration_to_Recovery_post_body(); transition_post_body(Configuration,Recovery); join
      update_transition(Configuration,Recovery);
    } /* ... to ... */ Recovery;
    Configuration_to_Detect : { 
      prepare_context();
      fork Configuration_to_Detect_pre_body(); transition_pre_body(Configuration,Detect); join
      fork Configuration_to_Detect_body(); transition_body(Configuration,Detect); join
      fork Configuration_to_Detect_post_body(); transition_post_body(Configuration,Detect); join
      update_transition(Configuration,Detect);
    } /* ... to ... */ Detect;
    L0_to_L1 : { 
      prepare_context();
      fork L0_to_L1_pre_body(); transition_pre_body(L0,L1); join
      fork L0_to_L1_body(); transition_body(L0,L1); join
      fork L0_to_L1_post_body(); transition_post_body(L0,L1); join
      update_transition(L0,L1);
    } /* ... to ... */ L1;
    L0_to_L0s : { 
      prepare_context();
      fork L0_to_L0s_pre_body(); transition_pre_body(L0,L0s); join
      fork L0_to_L0s_body(); transition_body(L0,L0s); join
      fork L0_to_L0s_post_body(); transition_post_body(L0,L0s); join
      update_transition(L0,L0s);
    } /* ... to ... */ L0s;
    L0_to_L2 : { 
      prepare_context();
      fork L0_to_L2_pre_body(); transition_pre_body(L0,L2); join
      fork L0_to_L2_body(); transition_body(L0,L2); join
      fork L0_to_L2_post_body(); transition_post_body(L0,L2); join
      update_transition(L0,L2);
    } /* ... to ... */ L2;
    L0_to_Recovery : { 
      prepare_context();
      fork L0_to_Recovery_pre_body(); transition_pre_body(L0,Recovery); join
      fork L0_to_Recovery_body(); transition_body(L0,Recovery); join
      fork L0_to_Recovery_post_body(); transition_post_body(L0,Recovery); join
      update_transition(L0,Recovery);
    } /* ... to ... */ Recovery;
    Recovery_to_Configuration : { 
      prepare_context();
      fork Recovery_to_Configuration_pre_body(); transition_pre_body(Recovery,Configuration); join
      fork Recovery_to_Configuration_body(); transition_body(Recovery,Configuration); join
      fork Recovery_to_Configuration_post_body(); transition_post_body(Recovery,Configuration); join
      update_transition(Recovery,Configuration);
    } /* ... to ... */ Configuration;
    Recovery_to_L0 : { 
      prepare_context();
      fork Recovery_to_L0_pre_body(); transition_pre_body(Recovery,L0); join
      fork Recovery_to_L0_body(); transition_body(Recovery,L0); join
      fork Recovery_to_L0_post_body(); transition_post_body(Recovery,L0); join
      update_transition(Recovery,L0);
    } /* ... to ... */ L0;
    Recovery_to_Detect : { 
      prepare_context();
      fork Recovery_to_Detect_pre_body(); transition_pre_body(Recovery,Detect); join
      fork Recovery_to_Detect_body(); transition_body(Recovery,Detect); join
      fork Recovery_to_Detect_post_body(); transition_post_body(Recovery,Detect); join
      update_transition(Recovery,Detect);
    } /* ... to ... */ Detect;
    L1_to_Recovery : { 
      prepare_context();
      fork L1_to_Recovery_pre_body(); transition_pre_body(L1,Recovery); join
      fork L1_to_Recovery_body(); transition_body(L1,Recovery); join
      fork L1_to_Recovery_post_body(); transition_post_body(L1,Recovery); join
      update_transition(L1,Recovery);
    } /* ... to ... */ Recovery;
    L0s_to_L0 : { 
      prepare_context();
      fork L0s_to_L0_pre_body(); transition_pre_body(L0s,L0); join
      fork L0s_to_L0_body(); transition_body(L0s,L0); join
      fork L0s_to_L0_post_body(); transition_post_body(L0s,L0); join
      update_transition(L0s,L0);
    } /* ... to ... */ L0;
    L0s_to_Recovery : { 
      prepare_context();
      fork L0s_to_Recovery_pre_body(); transition_pre_body(L0s,Recovery); join
      fork L0s_to_Recovery_body(); transition_body(L0s,Recovery); join
      fork L0s_to_Recovery_post_body(); transition_post_body(L0s,Recovery); join
      update_transition(L0s,Recovery);
    } /* ... to ... */ Recovery;
    L2_to_Detect : { 
      prepare_context();
      fork L2_to_Detect_pre_body(); transition_pre_body(L2,Detect); join
      fork L2_to_Detect_body(); transition_body(L2,Detect); join
      fork L2_to_Detect_post_body(); transition_post_body(L2,Detect); join
      update_transition(L2,Detect);
    } /* ... to ... */ Detect;
    starting_to_Detect : { 
      prepare_context();
      fork starting_to_Detect_pre_body(); transition_pre_body(starting,Detect); join
      fork starting_to_Detect_body(); transition_body(starting,Detect); join
      fork starting_to_Detect_post_body(); transition_post_body(starting,Detect); join
      update_transition(starting,Detect);
    } /* ... to ... */ Detect;
    _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
  endsequence
endtask : body
