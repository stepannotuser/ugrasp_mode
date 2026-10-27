class ghostsd_user_sequence extends ghostsd_sequence;
  `uvm_object_utils(ghostsd_user_sequence)

  function new(string name = "ghostsd_user_sequence");
    super.new(name);
  endfunction : new

  task IDLE_to_CMD55_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD55_to_ACMD41_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD55_to_ACMD23_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD55_to_CMD6_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD55_to_IDLE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task ACMD41_to_IDLE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task ACMD41_to_CMD2_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task ACMD41_to_CMD55_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD2_to_CMD3_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD3_to_CMD9_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD9_to_CMD7_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD7_to_CMD55_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD6_to_CMD13_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD6_to_CMD6_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD6_to_IDLE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD18_to_CMD15_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD18_to_READ_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task READ_to_CMD12_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD12_to_CMD13_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD12_to_CMD55_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task ACMD23_to_OTP_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task OTP_to_CMD25_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD25_to_WRITE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task WRITE_to_CMD12_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task WRITE_to_CMD13_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD13_to_WRITE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD13_to_CMD13_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD13_to_CMD15_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD13_to_CMD18_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task CMD15_to_IDLE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

  task ugrasp_pre_run_to_IDLE_body();
    $display("%s", current_state.name());
    `uvm_do(req)
  endtask

endclass : ghostsd_user_sequence
