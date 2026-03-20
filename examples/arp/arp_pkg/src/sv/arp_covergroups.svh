// SVGraph arp
// File    arp_covergroups.svh


// Global Coverage is reached when all state and transitions are covered
  covergroup arp_cg with function sample(arp_state_t current_state);

    option.per_instance = 0;

    // State coverage
    states : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 7; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 10;
      bins state      [] = { [current_state.first():current_state.last()] };
      ignore_bins unknown = { UNKNOWN };
    }

    // Global Transition Coverage
    transitions : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 7; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins transition[] =
         (Idle => RequestAddress)
        ,(RequestAddress => AddressConflict)
        ,(RequestAddress => AssignAddress)
        ,(AddressConflict => RequestAddress)
        ,(AssignAddress => Ready)
        ,(Ready => Idle)
        ,(starting => Idle)
;    }

        // Individual Edge Coverpoints, allow fine grain objective setup
    Idle_to_RequestAddress : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Idle_to_RequestAddress = ( Idle => RequestAddress ); 
    }
    RequestAddress_to_AddressConflict : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins RequestAddress_to_AddressConflict = ( RequestAddress => AddressConflict ); 
    }
    RequestAddress_to_AssignAddress : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins RequestAddress_to_AssignAddress = ( RequestAddress => AssignAddress ); 
    }
    AddressConflict_to_RequestAddress : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins AddressConflict_to_RequestAddress = ( AddressConflict => RequestAddress ); 
    }
    AssignAddress_to_Ready : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins AssignAddress_to_Ready = ( AssignAddress => Ready ); 
    }
    Ready_to_Idle : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins Ready_to_Idle = ( Ready => Idle ); 
    }
    starting_to_Idle : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins starting_to_Idle = ( starting => Idle ); 
    }

  endgroup

