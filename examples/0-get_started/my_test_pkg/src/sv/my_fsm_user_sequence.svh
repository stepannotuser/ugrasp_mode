

class my_fsm_user_sequence extends simple_vip_sequence_item ;
  `uvm_object_utils(my_fsm_user_sequence)

  // constructor
  function new(string name = "my_fsm_user_sequence");
    super.new(name);
  endfunction : new

  task A_to_A_body();
    $display("%s",current_state.name());
  endtask

  task A_to_B_body();
    $display("%s",current_state.name());
  endtask

  task A_to_C_body();
    $display("%s",current_state.name());
  endtask

  task B_to_B_body();
    $display("%s",current_state.name());
  endtask

  task B_to_C_body();
    $display("%s",current_state.name());
  endtask

  task B_to_D_body();
    $display("%s",current_state.name());
  endtask

  task C_to_A_body();
    $display("%s",current_state.name());
  endtask

  task C_to_IDLE_body();
    $display("%s",current_state.name());
  endtask

  task D_to_B_body();
    $display("%s",current_state.name());
  endtask

  task D_to_IDLE_body();
    $display("%s",current_state.name());
  endtask

  task IDLE_to_A_body();
    $display("%s",current_state.name());
  endtask

  task IDLE_to_B_body();
    $display("%s",current_state.name());
  endtask

  task starting_to_IDLE_body();
    $display("%s",current_state.name());
  endtask


  

endclass : my_fsm_user_sequence

