
module tb();
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import my_test_pkg::*;

  initial begin
    run_test("my_test");
  end

endmodule
