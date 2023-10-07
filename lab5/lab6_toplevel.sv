`include "SLC3_2.sv"
import SLC3_2::*;
module lab6_toplevel( input logic [15:0] SW,
                      input logic Clk, Reset, Run, Continue);

logic Reset_S_H, Run_S_H, Continue_S_H;

slc3 my_slc(.*, .Reset(Reset_S_H), .Run(Run_S_H), .Continue(Continue_S_H));
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(Reset_S_H), .I_O(Data), .A(ADDR), .*);

sync Reset_sync (.Clk(Clk), .d(~Reset), .q(Reset_S_H));
sync Run_sync (.Clk(Clk), .d(~Run), .q(Run_S_H));
sync Continue_sync (.Clk(Clk), .d(~Continue), .q(Continue_S_H));

endmodule