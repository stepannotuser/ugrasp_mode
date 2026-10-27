
module tb();
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ghostsd_test_pkg::*;

  initial begin
    run_test("ghostsd");
  end

endmodule
