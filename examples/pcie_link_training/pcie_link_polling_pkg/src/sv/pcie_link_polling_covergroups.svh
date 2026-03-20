// SVGraph pcie_link_polling
// File    pcie_link_polling_covergroups.svh


// Global Coverage is reached when all state and transitions are covered
  covergroup pcie_link_polling_cg with function sample(pcie_link_polling_state_t current_state);

    option.per_instance = 0;

    // State coverage
    states : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 8; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 10;
      bins state      [] = { [current_state.first():current_state.last()] };
      ignore_bins unknown = { UNKNOWN };
    }

    // Global Transition Coverage
    transitions : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 8; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins transition[] =
         (Entry_from_Detect => Polling_Active)
        ,(Polling_Active => Polling_Compliance)
        ,(Polling_Active => Polling_Configuration)
        ,(Polling_Active => Exit_to_Detect)
        ,(Polling_Compliance => Polling_Active)
        ,(Polling_Configuration => Exit_to_Detect)
        ,(Polling_Configuration => Exit_to_Configuration)
        ,(starting => Entry_from_Detect)
;    }

        // Individual Edge Coverpoints, allow fine grain objective setup
    Entry_from_Detect_to_Polling_Active : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Entry_from_Detect_to_Polling_Active = ( Entry_from_Detect => Polling_Active ); 
    }
    Polling_Active_to_Polling_Compliance : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Active_to_Polling_Compliance = ( Polling_Active => Polling_Compliance ); 
    }
    Polling_Active_to_Polling_Configuration : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Active_to_Polling_Configuration = ( Polling_Active => Polling_Configuration ); 
    }
    Polling_Active_to_Exit_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Active_to_Exit_to_Detect = ( Polling_Active => Exit_to_Detect ); 
    }
    Polling_Compliance_to_Polling_Active : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Compliance_to_Polling_Active = ( Polling_Compliance => Polling_Active ); 
    }
    Polling_Configuration_to_Exit_to_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Configuration_to_Exit_to_Detect = ( Polling_Configuration => Exit_to_Detect ); 
    }
    Polling_Configuration_to_Exit_to_Configuration : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Polling_Configuration_to_Exit_to_Configuration = ( Polling_Configuration => Exit_to_Configuration ); 
    }
    starting_to_Entry_from_Detect : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins starting_to_Entry_from_Detect = ( starting => Entry_from_Detect ); 
    }

  endgroup

