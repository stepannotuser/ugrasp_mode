// SVGraph sw_control
// File    sw_control_covergroups.svh


// Global Coverage is reached when all state and transitions are covered
  covergroup sw_control_cg with function sample(sw_control_state_t current_state);

    option.per_instance = 0;

    // State coverage
    states : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 18; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 10;
      bins state      [] = { [current_state.first():current_state.last()] };
      ignore_bins unknown = { UNKNOWN };
    }

    // Global Transition Coverage
    transitions : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 18; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins transition[] =
         (Idle => Configure)
        ,(Configure => InitTxBuffers)
        ,(Configure => WaitForInterrupt)
        ,(InitTxBuffers => TxControl)
        ,(TxControl => WaitForInterrupt)
        ,(WaitForInterrupt => ReadRxBuffer)
        ,(WaitForInterrupt => InitTxBuffers)
        ,(WaitForInterrupt => Idle)
        ,(WaitForInterrupt => TxControl)
        ,(ReadRxBuffer => Idle)
        ,(ReadRxBuffer => Configure)
        ,(ReadRxBuffer => InitTxBuffers)
        ,(ReadRxBuffer => WaitForInterrupt)
        ,(Idle => InitTxBuffers)
        ,(Idle => TxControl)
        ,(InitTxBuffers => InitTxBuffers)
        ,(TxControl => TxControl)
        ,(TxControl => InitTxBuffers)
;    }

        // Individual Edge Coverpoints, allow fine grain objective setup
    Idle_to_Configure : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Idle_to_Configure = ( Idle => Configure ); 
    }
    Configure_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Configure_to_InitTxBuffers = ( Configure => InitTxBuffers ); 
    }
    Configure_to_WaitForInterrupt : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Configure_to_WaitForInterrupt = ( Configure => WaitForInterrupt ); 
    }
    InitTxBuffers_to_TxControl : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins InitTxBuffers_to_TxControl = ( InitTxBuffers => TxControl ); 
    }
    TxControl_to_WaitForInterrupt : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins TxControl_to_WaitForInterrupt = ( TxControl => WaitForInterrupt ); 
    }
    WaitForInterrupt_to_ReadRxBuffer : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins WaitForInterrupt_to_ReadRxBuffer = ( WaitForInterrupt => ReadRxBuffer ); 
    }
    WaitForInterrupt_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins WaitForInterrupt_to_InitTxBuffers = ( WaitForInterrupt => InitTxBuffers ); 
    }
    WaitForInterrupt_to_Idle : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins WaitForInterrupt_to_Idle = ( WaitForInterrupt => Idle ); 
    }
    WaitForInterrupt_to_TxControl : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins WaitForInterrupt_to_TxControl = ( WaitForInterrupt => TxControl ); 
    }
    ReadRxBuffer_to_Idle : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins ReadRxBuffer_to_Idle = ( ReadRxBuffer => Idle ); 
    }
    ReadRxBuffer_to_Configure : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins ReadRxBuffer_to_Configure = ( ReadRxBuffer => Configure ); 
    }
    ReadRxBuffer_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins ReadRxBuffer_to_InitTxBuffers = ( ReadRxBuffer => InitTxBuffers ); 
    }
    ReadRxBuffer_to_WaitForInterrupt : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins ReadRxBuffer_to_WaitForInterrupt = ( ReadRxBuffer => WaitForInterrupt ); 
    }
    Idle_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Idle_to_InitTxBuffers = ( Idle => InitTxBuffers ); 
    }
    Idle_to_TxControl : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Idle_to_TxControl = ( Idle => TxControl ); 
    }
    InitTxBuffers_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins InitTxBuffers_to_InitTxBuffers = ( InitTxBuffers => InitTxBuffers ); 
    }
    TxControl_to_TxControl : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins TxControl_to_TxControl = ( TxControl => TxControl ); 
    }
    TxControl_to_InitTxBuffers : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins TxControl_to_InitTxBuffers = ( TxControl => InitTxBuffers ); 
    }

  endgroup

