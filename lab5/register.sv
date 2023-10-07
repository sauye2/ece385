module reg_16 ( input						Clk, Reset, Load,
					input					[15:0] D,
					output logic 			[15:0] Data_Out);
					
		always_ff @ (posedge Clk)
		begin
				// Setting the output Q[16..0] of the register to zeros as Reset is pressed
				if(Reset) //notice that this is a synchronous reset
					Data_Out <= 16'h0;
				// Loading D into register when load button is pressed (will eiher be switches or result of sum)
				else if(Load)
					Data_Out <= D;
		end
		
endmodule

module reg_3 ( input						Clk, Reset, Load,
					input					[2:0] D,
					output logic 			[2:0] Data_Out);
					
		always_ff @ (posedge Clk)
		begin
				// Setting the output Q[16..0] of the register to zeros as Reset is pressed
				if(Reset) //notice that this is a synchronous reset
					Data_Out <= 3'h0;
				// Loading D into register when load button is pressed (will eiher be switches or result of sum)
				else if(Load)
					Data_Out <= D;
		end
		
		
endmodule

module BEN_reg ( input						Clk, Reset, Load,
					input					[2:0] D1, D2,
					output logic 			Data_Out);

logic BEN_In;
					
		always_ff @ (posedge Clk)
		begin
				// Setting the output Q[16..0] of the register to zeros as Reset is pressed
				if(Reset) //notice that this is a synchronous reset
					Data_Out <= 1'b0;
				// Loading D into register when load button is pressed (will eiher be switches or result of sum)
				else if(Load)
					Data_Out <= BEN_In;
		end

		always_comb
		begin
			BEN_In = (D2[2] & D1[2]) | (D2[1] & D1[1]) | (D2[0] & D1[0]);
		end

endmodule



