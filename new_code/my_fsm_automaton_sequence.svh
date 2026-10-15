// Auto-generated automaton sequence
// Walk (6 transitions): IDLE -> A -> B -> C -> A -> B -> D

class my_fsm_automaton_sequence extends my_fsm_user_sequence;
  `uvm_object_utils(my_fsm_automaton_sequence)

  function new(string name="my_fsm_automaton_sequence");
    super.new(name);
  endfunction : new

  // Public coverage accessors for reporting
  function real get_state_coverage();
    return cg.states.get_coverage();
  endfunction

  function real get_transition_coverage();
    return cg.transitions.get_coverage();
  endfunction

  function real get_total_coverage();
    return cg.get_coverage();
  endfunction

  // Coverage goal setters
  function void set_state_at_least(int n);
    cg.states.option.at_least = n;
  endfunction

  function void set_transition_at_least(int n);
    cg.transitions.option.at_least = n;
  endfunction


  virtual task body();
    if (!randomization_done)
      `uvm_fatal("F_NORAND","Sequence not randomized. Please randomize before start()")

    // Set initial state (protected members accessible from subclass)
    current_state  = IDLE;
    cg.sample(IDLE);  // sample initial state to enable first transition coverage
    previous_state = IDLE;

    // --- state IDLE (step 0) ---
    IDLE_pre_body();  state_pre_body(IDLE);
    IDLE_body();      state_body(IDLE);
    IDLE_post_body(); state_post_body(IDLE);

    // --- transition IDLE -> A ---
    IDLE_to_A_pre_body();  transition_pre_body(IDLE, A);
    IDLE_to_A_body();      transition_body(IDLE, A);
    IDLE_to_A_post_body(); transition_post_body(IDLE, A);
    update_transition(IDLE, A);

    // --- state A (step 1) ---
    A_pre_body();  state_pre_body(A);
    A_body();      state_body(A);
    A_post_body(); state_post_body(A);

    // --- transition A -> B ---
    A_to_B_pre_body();  transition_pre_body(A, B);
    A_to_B_body();      transition_body(A, B);
    A_to_B_post_body(); transition_post_body(A, B);
    update_transition(A, B);

    // --- state B (step 2) ---
    B_pre_body();  state_pre_body(B);
    B_body();      state_body(B);
    B_post_body(); state_post_body(B);

    // --- transition B -> C ---
    B_to_C_pre_body();  transition_pre_body(B, C);
    B_to_C_body();      transition_body(B, C);
    B_to_C_post_body(); transition_post_body(B, C);
    update_transition(B, C);

    // --- state C (step 3) ---
    C_pre_body();  state_pre_body(C);
    C_body();      state_body(C);
    C_post_body(); state_post_body(C);

    // --- transition C -> A ---
    C_to_A_pre_body();  transition_pre_body(C, A);
    C_to_A_body();      transition_body(C, A);
    C_to_A_post_body(); transition_post_body(C, A);
    update_transition(C, A);

    // --- state A (step 4) ---
    A_pre_body();  state_pre_body(A);
    A_body();      state_body(A);
    A_post_body(); state_post_body(A);

    // --- transition A -> B ---
    A_to_B_pre_body();  transition_pre_body(A, B);
    A_to_B_body();      transition_body(A, B);
    A_to_B_post_body(); transition_post_body(A, B);
    update_transition(A, B);

    // --- state B (step 5) ---
    B_pre_body();  state_pre_body(B);
    B_body();      state_body(B);
    B_post_body(); state_post_body(B);

    // --- transition B -> D ---
    B_to_D_pre_body();  transition_pre_body(B, D);
    B_to_D_body();      transition_body(B, D);
    B_to_D_post_body(); transition_post_body(B, D);
    update_transition(B, D);

    // --- state D (step 6) ---
    D_pre_body();  state_pre_body(D);
    D_body();      state_body(D);
    D_post_body(); state_post_body(D);

    // --- completion ---
    completion_pre_body();
    completion_body();
    completion_post_body();
  endtask : body

endclass : my_fsm_automaton_sequence
