// SVGraph my_fsm
// File    my_fsm_covergroups.svh


// Global Coverage is reached when all state and transitions are covered
  covergroup my_fsm_cg with function sample(my_fsm_state_t current_state);

    option.per_instance = 0;

    // State coverage
    states : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 5; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 10;
      bins state      [] = { IDLE,READ,WRITE,DONE };
      ignore_bins unknown = { UNKNOWN };
    }

    // Global Transition Coverage
    transitions : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 5; //< The weight is set to the number of transitions so that states have as much weight as the all transations together
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins transition[] =
         (IDLE => READ)
        ,(READ => WRITE)
        ,(WRITE => DONE)
        ,(DONE => DONE)
;    }

        // Individual Edge Coverpoints, allow fine grain objective setup
    IDLE_to_READ : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins IDLE_to_READ = ( IDLE => READ ); 
    }
    READ_to_WRITE : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins READ_to_WRITE = ( READ => WRITE ); 
    }
    WRITE_to_DONE : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins WRITE_to_DONE = ( WRITE => DONE ); 
    }
    DONE_to_DONE : coverpoint current_state {
      option.goal     = 100;
      option.weight   = 1;
      option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.
      bins DONE_to_DONE = ( DONE => DONE ); 
    }

  endgroup

