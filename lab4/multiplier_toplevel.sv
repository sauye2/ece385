module multiplier_toplevel  (input Clk, Reset_Load_Clear, Run, 
						input [7:0]			SW,
						output logic [7:0] Aval, Bval,
						output logic Xval,
                        output  logic   [7:0]   hex_segA,
                        output  logic   [3:0]   hex_gridA);

		// Declare temporary values used by other modules
		logic Add, Sub, Shift, Clr_Ld, M, AOUTPUT;
		logic [7:0] A, B;
		logic [7:0] sum;
		logic x1;
		logic Load_A;
		assign Load_A = Add ^ Sub;
		assign Aval = A;
		assign Bval = B;
		 	
		// Control unit allows the register to load once, and not during full duration of button press
		control control(.Clk(Clk), .Reset(Reset_Load_Clear), .Run(Run), .ClearA_LoadB(Reset_Load_Clear), .M(M), .Clr_Ld(Clr_Ld), .Shift(Shift), .Add(Add), .Sub(Sub));

		add_sub add_sub(.A(A), .B(SW), .fn(Sub), .S(sum), .X(x1));

		reg_8 reg_A(.Clk(Clk), .Reset(Reset_Load_Clear), .Shift_In(Xval), .Load(Load_A), .Shift_En(Shift), .D(sum), .Shift_Out(AOUTPUT), .Data_Out(A));
		reg_8 reg_B(.Clk(Clk), .Reset(Clr_Ld), .Shift_In(AOUTPUT), .Load(Reset_Load_Clear), .Shift_En(Shift), .D(SW), .Shift_Out(M), .Data_Out(B));

		reg_x reg_x(.Clk(Clk), .Reset(Reset_Load_Clear), .Load(Load_A), .D(x1), .Data_Out(Xval));

		// Hex units that display contents of SW and register R in hex
	    HexDriver HexA (
			.clk(Clk),
			.reset(Reset_Load_Clear),
			.in({Aval[7:4],  Aval[3:0], Bval[7:4], Bval[3:0]}),
			.hex_seg(hex_segA),
			.hex_grid(hex_gridA)
		);
								
		
endmodule