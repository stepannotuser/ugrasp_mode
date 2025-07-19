// SVGraph sw_control
// File    sw_control_sequence.sv

// ----------------------------------------------
// Constructor 
// ----------------------------------------------
function sw_control_sequence::new(string name="sw_control_sequence");
  super.new(name);
endfunction : new


// ----------------------------------------------
// Utility Functions 
// ----------------------------------------------
function void sw_control_sequence::goto(sw_control_state_t next);
  super.goto(next);
endfunction : goto
function void sw_control_sequence::exit();
  super.exit();
endfunction : exit

// ----------------------------------------------
// Common tasks and functions hooks
// ----------------------------------------------
function void sw_control_sequence::state_pre_body(sw_control_state_t state); 
endfunction
task          sw_control_sequence::state_body(sw_control_state_t state); 
endtask
function void sw_control_sequence::state_post_body(sw_control_state_t state);
endfunction


function void sw_control_sequence::transition_pre_body(sw_control_state_t src,dst); 
endfunction
task          sw_control_sequence::transition_body(sw_control_state_t src,dst); 
endtask
function void sw_control_sequence::transition_post_body(sw_control_state_t src,dst);
endfunction


// ----------------------------------------------
// State tasks and functions hooks
// ----------------------------------------------
// STATE:Idle Hooks to be implemented in children classes
function void sw_control_sequence::Idle_pre_body();
endfunction
task          sw_control_sequence::Idle_body();
endtask
function void sw_control_sequence::Idle_post_body();
endfunction

// STATE:Configure Hooks to be implemented in children classes
function void sw_control_sequence::Configure_pre_body();
endfunction
task          sw_control_sequence::Configure_body();
endtask
function void sw_control_sequence::Configure_post_body();
endfunction

// STATE:InitTxBuffers Hooks to be implemented in children classes
function void sw_control_sequence::InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::InitTxBuffers_body();
endtask
function void sw_control_sequence::InitTxBuffers_post_body();
endfunction

// STATE:TxControl Hooks to be implemented in children classes
function void sw_control_sequence::TxControl_pre_body();
endfunction
task          sw_control_sequence::TxControl_body();
endtask
function void sw_control_sequence::TxControl_post_body();
endfunction

// STATE:WaitForInterrupt Hooks to be implemented in children classes
function void sw_control_sequence::WaitForInterrupt_pre_body();
endfunction
task          sw_control_sequence::WaitForInterrupt_body();
endtask
function void sw_control_sequence::WaitForInterrupt_post_body();
endfunction

// STATE:ReadRxBuffer Hooks to be implemented in children classes
function void sw_control_sequence::ReadRxBuffer_pre_body();
endfunction
task          sw_control_sequence::ReadRxBuffer_body();
endtask
function void sw_control_sequence::ReadRxBuffer_post_body();
endfunction

// STATE:__START__ Hooks to be implemented in children classes
function void sw_control_sequence::__START___pre_body();
endfunction
task          sw_control_sequence::__START___body();
endtask
function void sw_control_sequence::__START___post_body();
endfunction

// ----------------------------------------------
// Transition tasks and functions hooks
// ----------------------------------------------
// TRANSITION:Idle to Configure: Hooks to be implemented in children classes
function void sw_control_sequence::Idle_to_Configure_pre_body();
endfunction
task          sw_control_sequence::Idle_to_Configure_body();
endtask
function void sw_control_sequence::Idle_to_Configure_post_body();
endfunction

// TRANSITION:Idle to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::Idle_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::Idle_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::Idle_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:Idle to TxControl: Hooks to be implemented in children classes
function void sw_control_sequence::Idle_to_TxControl_pre_body();
endfunction
task          sw_control_sequence::Idle_to_TxControl_body();
endtask
function void sw_control_sequence::Idle_to_TxControl_post_body();
endfunction

// TRANSITION:Configure to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::Configure_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::Configure_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::Configure_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:Configure to WaitForInterrupt: Hooks to be implemented in children classes
function void sw_control_sequence::Configure_to_WaitForInterrupt_pre_body();
endfunction
task          sw_control_sequence::Configure_to_WaitForInterrupt_body();
endtask
function void sw_control_sequence::Configure_to_WaitForInterrupt_post_body();
endfunction

// TRANSITION:InitTxBuffers to TxControl: Hooks to be implemented in children classes
function void sw_control_sequence::InitTxBuffers_to_TxControl_pre_body();
endfunction
task          sw_control_sequence::InitTxBuffers_to_TxControl_body();
endtask
function void sw_control_sequence::InitTxBuffers_to_TxControl_post_body();
endfunction

// TRANSITION:InitTxBuffers to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::InitTxBuffers_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::InitTxBuffers_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::InitTxBuffers_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:TxControl to WaitForInterrupt: Hooks to be implemented in children classes
function void sw_control_sequence::TxControl_to_WaitForInterrupt_pre_body();
endfunction
task          sw_control_sequence::TxControl_to_WaitForInterrupt_body();
endtask
function void sw_control_sequence::TxControl_to_WaitForInterrupt_post_body();
endfunction

// TRANSITION:TxControl to TxControl: Hooks to be implemented in children classes
function void sw_control_sequence::TxControl_to_TxControl_pre_body();
endfunction
task          sw_control_sequence::TxControl_to_TxControl_body();
endtask
function void sw_control_sequence::TxControl_to_TxControl_post_body();
endfunction

// TRANSITION:TxControl to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::TxControl_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::TxControl_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::TxControl_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:WaitForInterrupt to ReadRxBuffer: Hooks to be implemented in children classes
function void sw_control_sequence::WaitForInterrupt_to_ReadRxBuffer_pre_body();
endfunction
task          sw_control_sequence::WaitForInterrupt_to_ReadRxBuffer_body();
endtask
function void sw_control_sequence::WaitForInterrupt_to_ReadRxBuffer_post_body();
endfunction

// TRANSITION:WaitForInterrupt to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::WaitForInterrupt_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::WaitForInterrupt_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::WaitForInterrupt_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:WaitForInterrupt to Idle: Hooks to be implemented in children classes
function void sw_control_sequence::WaitForInterrupt_to_Idle_pre_body();
endfunction
task          sw_control_sequence::WaitForInterrupt_to_Idle_body();
endtask
function void sw_control_sequence::WaitForInterrupt_to_Idle_post_body();
endfunction

// TRANSITION:WaitForInterrupt to TxControl: Hooks to be implemented in children classes
function void sw_control_sequence::WaitForInterrupt_to_TxControl_pre_body();
endfunction
task          sw_control_sequence::WaitForInterrupt_to_TxControl_body();
endtask
function void sw_control_sequence::WaitForInterrupt_to_TxControl_post_body();
endfunction

// TRANSITION:ReadRxBuffer to Idle: Hooks to be implemented in children classes
function void sw_control_sequence::ReadRxBuffer_to_Idle_pre_body();
endfunction
task          sw_control_sequence::ReadRxBuffer_to_Idle_body();
endtask
function void sw_control_sequence::ReadRxBuffer_to_Idle_post_body();
endfunction

// TRANSITION:ReadRxBuffer to Configure: Hooks to be implemented in children classes
function void sw_control_sequence::ReadRxBuffer_to_Configure_pre_body();
endfunction
task          sw_control_sequence::ReadRxBuffer_to_Configure_body();
endtask
function void sw_control_sequence::ReadRxBuffer_to_Configure_post_body();
endfunction

// TRANSITION:ReadRxBuffer to InitTxBuffers: Hooks to be implemented in children classes
function void sw_control_sequence::ReadRxBuffer_to_InitTxBuffers_pre_body();
endfunction
task          sw_control_sequence::ReadRxBuffer_to_InitTxBuffers_body();
endtask
function void sw_control_sequence::ReadRxBuffer_to_InitTxBuffers_post_body();
endfunction

// TRANSITION:ReadRxBuffer to WaitForInterrupt: Hooks to be implemented in children classes
function void sw_control_sequence::ReadRxBuffer_to_WaitForInterrupt_pre_body();
endfunction
task          sw_control_sequence::ReadRxBuffer_to_WaitForInterrupt_body();
endtask
function void sw_control_sequence::ReadRxBuffer_to_WaitForInterrupt_post_body();
endfunction

// TRANSITION:__START__ to Idle: Hooks to be implemented in children classes
function void sw_control_sequence::__START___to_Idle_pre_body();
endfunction
task          sw_control_sequence::__START___to_Idle_body();
endtask
function void sw_control_sequence::__START___to_Idle_post_body();
endfunction

// ----------------------------------------------
// Completion hook
// ----------------------------------------------
function void sw_control_sequence::completion_pre_body(); 
  `uvm_info("completion_body","completion_pre_body called",UVM_MEDIUM);
endfunction 
task sw_control_sequence::completion_body(); 
  `uvm_info("completion_body","completion_body called",UVM_MEDIUM);
endtask 

// Show coverage at the end of the sequence
function void sw_control_sequence::completion_post_body();
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
task sw_control_sequence::body();
  randsequence(__START__)
    Idle : Idle_act Idle_sel;
    Configure : Configure_act Configure_sel;
    InitTxBuffers : InitTxBuffers_act InitTxBuffers_sel;
    TxControl : TxControl_act TxControl_sel;
    WaitForInterrupt : WaitForInterrupt_act WaitForInterrupt_sel;
    ReadRxBuffer : ReadRxBuffer_act ReadRxBuffer_sel;
    __START__ : __START___act __START___sel;

    Idle_act : {
      prepare_context();
      fork Idle_pre_body(); state_pre_body(Idle); join
      fork Idle_body(); state_body(Idle); join
      fork Idle_post_body(); state_post_body(Idle); join
    };
    Configure_act : {
      prepare_context();
      fork Configure_pre_body(); state_pre_body(Configure); join
      fork Configure_body(); state_body(Configure); join
      fork Configure_post_body(); state_post_body(Configure); join
    };
    InitTxBuffers_act : {
      prepare_context();
      fork InitTxBuffers_pre_body(); state_pre_body(InitTxBuffers); join
      fork InitTxBuffers_body(); state_body(InitTxBuffers); join
      fork InitTxBuffers_post_body(); state_post_body(InitTxBuffers); join
    };
    TxControl_act : {
      prepare_context();
      fork TxControl_pre_body(); state_pre_body(TxControl); join
      fork TxControl_body(); state_body(TxControl); join
      fork TxControl_post_body(); state_post_body(TxControl); join
    };
    WaitForInterrupt_act : {
      prepare_context();
      fork WaitForInterrupt_pre_body(); state_pre_body(WaitForInterrupt); join
      fork WaitForInterrupt_body(); state_body(WaitForInterrupt); join
      fork WaitForInterrupt_post_body(); state_post_body(WaitForInterrupt); join
    };
    ReadRxBuffer_act : {
      prepare_context();
      fork ReadRxBuffer_pre_body(); state_pre_body(ReadRxBuffer); join
      fork ReadRxBuffer_body(); state_body(ReadRxBuffer); join
      fork ReadRxBuffer_post_body(); state_post_body(ReadRxBuffer); join
    };
    __START___act : {
      prepare_context();
      fork __START___pre_body(); state_pre_body(__START__); join
      fork __START___body(); state_body(__START__); join
      fork __START___post_body(); state_post_body(__START__); join
    };

    Idle_sel : _END_:=weight_end | Idle_to_Configure:=weight[Idle][Configure] | Idle_to_InitTxBuffers:=weight[Idle][InitTxBuffers] | Idle_to_TxControl:=weight[Idle][TxControl];
    Configure_sel : _END_:=weight_end | Configure_to_InitTxBuffers:=weight[Configure][InitTxBuffers] | Configure_to_WaitForInterrupt:=weight[Configure][WaitForInterrupt];
    InitTxBuffers_sel : _END_:=weight_end | InitTxBuffers_to_TxControl:=weight[InitTxBuffers][TxControl] | InitTxBuffers_to_InitTxBuffers:=weight[InitTxBuffers][InitTxBuffers];
    TxControl_sel : _END_:=weight_end | TxControl_to_WaitForInterrupt:=weight[TxControl][WaitForInterrupt] | TxControl_to_TxControl:=weight[TxControl][TxControl] | TxControl_to_InitTxBuffers:=weight[TxControl][InitTxBuffers];
    WaitForInterrupt_sel : _END_:=weight_end | WaitForInterrupt_to_ReadRxBuffer:=weight[WaitForInterrupt][ReadRxBuffer] | WaitForInterrupt_to_InitTxBuffers:=weight[WaitForInterrupt][InitTxBuffers] | WaitForInterrupt_to_Idle:=weight[WaitForInterrupt][Idle] | WaitForInterrupt_to_TxControl:=weight[WaitForInterrupt][TxControl];
    ReadRxBuffer_sel : _END_:=weight_end | ReadRxBuffer_to_Idle:=weight[ReadRxBuffer][Idle] | ReadRxBuffer_to_Configure:=weight[ReadRxBuffer][Configure] | ReadRxBuffer_to_InitTxBuffers:=weight[ReadRxBuffer][InitTxBuffers] | ReadRxBuffer_to_WaitForInterrupt:=weight[ReadRxBuffer][WaitForInterrupt];
    __START___sel : _END_:=weight_end | __START___to_Idle:=weight[__START__][Idle];

    Idle_to_Configure : { 
      prepare_context();
      fork Idle_to_Configure_pre_body(); transition_pre_body(Idle,Configure); join
      fork Idle_to_Configure_body(); transition_body(Idle,Configure); join
      fork Idle_to_Configure_post_body(); transition_post_body(Idle,Configure); join
      update_transition(Idle,Configure);
    } /* ... to ... */ Configure;
    Idle_to_InitTxBuffers : { 
      prepare_context();
      fork Idle_to_InitTxBuffers_pre_body(); transition_pre_body(Idle,InitTxBuffers); join
      fork Idle_to_InitTxBuffers_body(); transition_body(Idle,InitTxBuffers); join
      fork Idle_to_InitTxBuffers_post_body(); transition_post_body(Idle,InitTxBuffers); join
      update_transition(Idle,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    Idle_to_TxControl : { 
      prepare_context();
      fork Idle_to_TxControl_pre_body(); transition_pre_body(Idle,TxControl); join
      fork Idle_to_TxControl_body(); transition_body(Idle,TxControl); join
      fork Idle_to_TxControl_post_body(); transition_post_body(Idle,TxControl); join
      update_transition(Idle,TxControl);
    } /* ... to ... */ TxControl;
    Configure_to_InitTxBuffers : { 
      prepare_context();
      fork Configure_to_InitTxBuffers_pre_body(); transition_pre_body(Configure,InitTxBuffers); join
      fork Configure_to_InitTxBuffers_body(); transition_body(Configure,InitTxBuffers); join
      fork Configure_to_InitTxBuffers_post_body(); transition_post_body(Configure,InitTxBuffers); join
      update_transition(Configure,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    Configure_to_WaitForInterrupt : { 
      prepare_context();
      fork Configure_to_WaitForInterrupt_pre_body(); transition_pre_body(Configure,WaitForInterrupt); join
      fork Configure_to_WaitForInterrupt_body(); transition_body(Configure,WaitForInterrupt); join
      fork Configure_to_WaitForInterrupt_post_body(); transition_post_body(Configure,WaitForInterrupt); join
      update_transition(Configure,WaitForInterrupt);
    } /* ... to ... */ WaitForInterrupt;
    InitTxBuffers_to_TxControl : { 
      prepare_context();
      fork InitTxBuffers_to_TxControl_pre_body(); transition_pre_body(InitTxBuffers,TxControl); join
      fork InitTxBuffers_to_TxControl_body(); transition_body(InitTxBuffers,TxControl); join
      fork InitTxBuffers_to_TxControl_post_body(); transition_post_body(InitTxBuffers,TxControl); join
      update_transition(InitTxBuffers,TxControl);
    } /* ... to ... */ TxControl;
    InitTxBuffers_to_InitTxBuffers : { 
      prepare_context();
      fork InitTxBuffers_to_InitTxBuffers_pre_body(); transition_pre_body(InitTxBuffers,InitTxBuffers); join
      fork InitTxBuffers_to_InitTxBuffers_body(); transition_body(InitTxBuffers,InitTxBuffers); join
      fork InitTxBuffers_to_InitTxBuffers_post_body(); transition_post_body(InitTxBuffers,InitTxBuffers); join
      update_transition(InitTxBuffers,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    TxControl_to_WaitForInterrupt : { 
      prepare_context();
      fork TxControl_to_WaitForInterrupt_pre_body(); transition_pre_body(TxControl,WaitForInterrupt); join
      fork TxControl_to_WaitForInterrupt_body(); transition_body(TxControl,WaitForInterrupt); join
      fork TxControl_to_WaitForInterrupt_post_body(); transition_post_body(TxControl,WaitForInterrupt); join
      update_transition(TxControl,WaitForInterrupt);
    } /* ... to ... */ WaitForInterrupt;
    TxControl_to_TxControl : { 
      prepare_context();
      fork TxControl_to_TxControl_pre_body(); transition_pre_body(TxControl,TxControl); join
      fork TxControl_to_TxControl_body(); transition_body(TxControl,TxControl); join
      fork TxControl_to_TxControl_post_body(); transition_post_body(TxControl,TxControl); join
      update_transition(TxControl,TxControl);
    } /* ... to ... */ TxControl;
    TxControl_to_InitTxBuffers : { 
      prepare_context();
      fork TxControl_to_InitTxBuffers_pre_body(); transition_pre_body(TxControl,InitTxBuffers); join
      fork TxControl_to_InitTxBuffers_body(); transition_body(TxControl,InitTxBuffers); join
      fork TxControl_to_InitTxBuffers_post_body(); transition_post_body(TxControl,InitTxBuffers); join
      update_transition(TxControl,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    WaitForInterrupt_to_ReadRxBuffer : { 
      prepare_context();
      fork WaitForInterrupt_to_ReadRxBuffer_pre_body(); transition_pre_body(WaitForInterrupt,ReadRxBuffer); join
      fork WaitForInterrupt_to_ReadRxBuffer_body(); transition_body(WaitForInterrupt,ReadRxBuffer); join
      fork WaitForInterrupt_to_ReadRxBuffer_post_body(); transition_post_body(WaitForInterrupt,ReadRxBuffer); join
      update_transition(WaitForInterrupt,ReadRxBuffer);
    } /* ... to ... */ ReadRxBuffer;
    WaitForInterrupt_to_InitTxBuffers : { 
      prepare_context();
      fork WaitForInterrupt_to_InitTxBuffers_pre_body(); transition_pre_body(WaitForInterrupt,InitTxBuffers); join
      fork WaitForInterrupt_to_InitTxBuffers_body(); transition_body(WaitForInterrupt,InitTxBuffers); join
      fork WaitForInterrupt_to_InitTxBuffers_post_body(); transition_post_body(WaitForInterrupt,InitTxBuffers); join
      update_transition(WaitForInterrupt,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    WaitForInterrupt_to_Idle : { 
      prepare_context();
      fork WaitForInterrupt_to_Idle_pre_body(); transition_pre_body(WaitForInterrupt,Idle); join
      fork WaitForInterrupt_to_Idle_body(); transition_body(WaitForInterrupt,Idle); join
      fork WaitForInterrupt_to_Idle_post_body(); transition_post_body(WaitForInterrupt,Idle); join
      update_transition(WaitForInterrupt,Idle);
    } /* ... to ... */ Idle;
    WaitForInterrupt_to_TxControl : { 
      prepare_context();
      fork WaitForInterrupt_to_TxControl_pre_body(); transition_pre_body(WaitForInterrupt,TxControl); join
      fork WaitForInterrupt_to_TxControl_body(); transition_body(WaitForInterrupt,TxControl); join
      fork WaitForInterrupt_to_TxControl_post_body(); transition_post_body(WaitForInterrupt,TxControl); join
      update_transition(WaitForInterrupt,TxControl);
    } /* ... to ... */ TxControl;
    ReadRxBuffer_to_Idle : { 
      prepare_context();
      fork ReadRxBuffer_to_Idle_pre_body(); transition_pre_body(ReadRxBuffer,Idle); join
      fork ReadRxBuffer_to_Idle_body(); transition_body(ReadRxBuffer,Idle); join
      fork ReadRxBuffer_to_Idle_post_body(); transition_post_body(ReadRxBuffer,Idle); join
      update_transition(ReadRxBuffer,Idle);
    } /* ... to ... */ Idle;
    ReadRxBuffer_to_Configure : { 
      prepare_context();
      fork ReadRxBuffer_to_Configure_pre_body(); transition_pre_body(ReadRxBuffer,Configure); join
      fork ReadRxBuffer_to_Configure_body(); transition_body(ReadRxBuffer,Configure); join
      fork ReadRxBuffer_to_Configure_post_body(); transition_post_body(ReadRxBuffer,Configure); join
      update_transition(ReadRxBuffer,Configure);
    } /* ... to ... */ Configure;
    ReadRxBuffer_to_InitTxBuffers : { 
      prepare_context();
      fork ReadRxBuffer_to_InitTxBuffers_pre_body(); transition_pre_body(ReadRxBuffer,InitTxBuffers); join
      fork ReadRxBuffer_to_InitTxBuffers_body(); transition_body(ReadRxBuffer,InitTxBuffers); join
      fork ReadRxBuffer_to_InitTxBuffers_post_body(); transition_post_body(ReadRxBuffer,InitTxBuffers); join
      update_transition(ReadRxBuffer,InitTxBuffers);
    } /* ... to ... */ InitTxBuffers;
    ReadRxBuffer_to_WaitForInterrupt : { 
      prepare_context();
      fork ReadRxBuffer_to_WaitForInterrupt_pre_body(); transition_pre_body(ReadRxBuffer,WaitForInterrupt); join
      fork ReadRxBuffer_to_WaitForInterrupt_body(); transition_body(ReadRxBuffer,WaitForInterrupt); join
      fork ReadRxBuffer_to_WaitForInterrupt_post_body(); transition_post_body(ReadRxBuffer,WaitForInterrupt); join
      update_transition(ReadRxBuffer,WaitForInterrupt);
    } /* ... to ... */ WaitForInterrupt;
    __START___to_Idle : { 
      prepare_context();
      fork __START___to_Idle_pre_body(); transition_pre_body(__START__,Idle); join
      fork __START___to_Idle_body(); transition_body(__START__,Idle); join
      fork __START___to_Idle_post_body(); transition_post_body(__START__,Idle); join
      update_transition(__START__,Idle);
    } /* ... to ... */ Idle;
    _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
  endsequence
endtask : body
