// SVGraph pcie_link_training
// File    pcie_link_training_covergroups.svh


// Global Coverage is reached when all state and transitions are covered
  covergroup pcie_link_training_cg with function sample(pcie_link_training_state_t current_state);

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
         (Detect => Polling)
        ,(Polling => Detect)
        ,(Polling => Configuration)
        ,(Configuration => L0)
        ,(Configuration => Recovery)
        ,(Configuration => Detect)
        ,(L0 => L1)
        ,(L0 => L0s)
        ,(L0 => L2)
        ,(L0 => Recovery)
        ,(Recovery => Configuration)
        ,(Recovery => L0)
        ,(Recovery => Detect)
        ,(L1 => Recovery)
        ,(L0s => L0)
        ,(L0s => Recovery)
        ,(L2 => Detect)
        ,(starting => Detect)
;    }

        // Individual Edge Coverpoints, allow fine grain objective setup
    Detect_to_Polling : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Detect_to_Polling = ( Detect => Polling ); 
    }
    Polling_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_to_Detect = ( Polling => Detect ); 
    }
    Polling_to_Configuration : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_to_Configuration = ( Polling => Configuration ); 
    }
    Configuration_to_L0 : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Configuration_to_L0 = ( Configuration => L0 ); 
    }
    Configuration_to_Recovery : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Configuration_to_Recovery = ( Configuration => Recovery ); 
    }
    Configuration_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Configuration_to_Detect = ( Configuration => Detect ); 
    }
    L0_to_L1 : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0_to_L1 = ( L0 => L1 ); 
    }
    L0_to_L0s : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0_to_L0s = ( L0 => L0s ); 
    }
    L0_to_L2 : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0_to_L2 = ( L0 => L2 ); 
    }
    L0_to_Recovery : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0_to_Recovery = ( L0 => Recovery ); 
    }
    Recovery_to_Configuration : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Recovery_to_Configuration = ( Recovery => Configuration ); 
    }
    Recovery_to_L0 : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Recovery_to_L0 = ( Recovery => L0 ); 
    }
    Recovery_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Recovery_to_Detect = ( Recovery => Detect ); 
    }
    L1_to_Recovery : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L1_to_Recovery = ( L1 => Recovery ); 
    }
    L0s_to_L0 : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0s_to_L0 = ( L0s => L0 ); 
    }
    L0s_to_Recovery : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L0s_to_Recovery = ( L0s => Recovery ); 
    }
    L2_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins L2_to_Detect = ( L2 => Detect ); 
    }
    starting_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins starting_to_Detect = ( starting => Detect ); 
    }

  endgroup

