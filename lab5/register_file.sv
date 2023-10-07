module reg_file(input logic Clk, Reset, Load,
					 input logic [2:0] DR_In, 
					 input logic [2:0] SR1_In, 
					 input logic [2:0] SR2_In,
					 input logic [15:0] Data_Bus,
					 output logic [15:0] SR1_Out, 
					 output logic [15:0] SR2_Out);
					 
	logic [7:0][15:0] R;
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)				           //clear R0-R7 if reset is pressed
		begin
			R[0] <= 16'h0000;
			R[1] <= 16'h0000;
			R[2] <= 16'h0000;
			R[3] <= 16'h0000;
			R[4] <= 16'h0000;
			R[5] <= 16'h0000;
			R[6] <= 16'h0000;
			R[7] <= 16'h0000;
		end
		else

		begin
			if(Load)			
			begin
				case(DR_In)
					3'b000: R[0] <= Data_Bus;
					3'b001: R[1] <= Data_Bus;
					3'b010: R[2] <= Data_Bus;
					3'b011: R[3] <= Data_Bus;
					3'b100: R[4] <= Data_Bus;
					3'b101: R[5] <= Data_Bus;
					3'b110: R[6] <= Data_Bus;
					3'b111: R[7] <= Data_Bus;
				endcase
			end
		end
	end
		
	always_comb
	begin
		case(SR1_In)
			3'b000: SR1_Out = R[0];
			3'b001: SR1_Out = R[1];
			3'b010: SR1_Out = R[2];
			3'b011: SR1_Out = R[3];
			3'b100: SR1_Out = R[4];
			3'b101: SR1_Out = R[5];
			3'b110: SR1_Out = R[6];
			3'b111: SR1_Out = R[7];
		endcase
		case(SR2_In)
			3'b000: SR2_Out = R[0];
			3'b001: SR2_Out = R[1];
			3'b010: SR2_Out = R[2];
			3'b011: SR2_Out = R[3];
			3'b100: SR2_Out = R[4];
			3'b101: SR2_Out = R[5];
			3'b110: SR2_Out = R[6];
			3'b111: SR2_Out = R[7];
		endcase
	end

endmodule


