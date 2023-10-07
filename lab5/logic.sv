module nzp_logic(input [15:0] D,
			 output logic [2:0]Data_Out );

		always_comb
		begin
			if(D == 16'h0000)
    			Data_Out = 3'b010;
			else if(D[15] == 1'b0)
    			Data_Out = 3'b001;
			else
    			Data_Out = 3'b100;
		end

endmodule

module SEXT5(input logic [4:0] IR,
				output logic [15:0] SEXT5);
	always_comb 
	begin
	if (IR[4])
		SEXT5 = {11'b11111111111, IR[4:0]};
	else 
		SEXT5 = {11'b00000000000, IR[4:0]};	
	end

endmodule

module SEXT6(input logic [5:0] IR,
			 output logic [15:0] SEXT6);
	always_comb 
	begin
	if (IR[5])
		SEXT6 = {10'b1111111111, IR[5:0]};
	else 
		SEXT6 = {10'b0000000000,IR[5:0]};	
	end

endmodule

module SEXT9(input logic [8:0] IR,
			 output logic [15:0] SEXT9);
	always_comb 
	begin
	if (IR[8])
		SEXT9 = {7'b1111111,IR[8:0]};
	else 
		SEXT9 = {7'b0000000,IR[8:0]};
	end

endmodule

module SEXT11(input logic [10:0] IR,
			  output logic [15:0] SEXT11);
	always_comb 
	begin
	if (IR[10])
		SEXT11 = {5'b11111,IR[10:0]};
	else 
		SEXT11 = {5'b00000,IR[10:0]};	
	end

endmodule

module ADD_ADDR(input logic [15:0] ADDR1,
                input logic [15:0] ADDR2,
				output logic [15:0] ADDR_Out);
	always_comb 
	begin
		ADDR_Out = ADDR1 + ADDR2;
	end

endmodule

module ALU(input logic [15:0] A,
		   input logic [15:0] B,
		   input logic [1:0] Select,
		   output logic [15:0] Out);
	
	always_comb
	begin
    	case(Select)
        	2'b00: Out = A + B;
        	2'b01: Out = A & B;
			2'b10: Out = ~A;
			2'b11: Out = A;
    	endcase
	end

endmodule