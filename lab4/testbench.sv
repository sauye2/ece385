module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset_Load_Clear, Run, Xval;
logic [7:0] SW;
logic [7:0] Aval;
logic [7:0] Bval;
logic [7:0] hex_segA;
logic [3:0] hex_gridA;

// To store expected results
logic [15:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
multiplier_toplevel testbench(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset_Load_Clear = 1;		// Toggle Rest
Run = 1;
// 1) 7*59
#2 Reset_Load_Clear = 0;
SW = 8'b00111011;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;
#22 SW = 8'b00000111;
#2 Run=0;
#33 Run = 1;
ans_1a = 8'h01;
ans_2b = 8'h9d;
if (Aval != ans_1a)	
	ErrorCnt++;
if (Bval != ans_2b)
    ErrorCnt++;
// 2) -7*59
#22 SW = 8'b00111011;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;
#22 SW = 8'b11111001;
#2 Run=0;
#33 Run = 1;
ans_1a = 8'hfe;
ans_2b = 8'h63;
if (Aval != ans_1a)	
	ErrorCnt++;
if (Bval != ans_2b)
    ErrorCnt++;
// 3) 7*-59
#22 SW = 8'b11000101;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;
#22 SW = 8'b00000111;
#2 Run=0;
#33 Run = 1;
ans_1a = 8'hfe;
ans_2b = 8'h63;
if (Aval != ans_1a)	
	ErrorCnt++;
if (Bval != ans_2b)
    ErrorCnt++;
// 4) -7*-59
#22 SW = 8'b11000101;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;
#22 SW = 8'b11111001;
#2 Run=0;
#33 Run = 1;
ans_1a = 8'h01;
ans_2b = 8'h9d;
if (Aval != ans_1a)	
	ErrorCnt++;
if (Bval != ans_2b)
    ErrorCnt++;

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
