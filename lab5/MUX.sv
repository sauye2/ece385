module MUX_MIO (
    input logic[15:0] Data_to_CPU,
    input logic[15:0] Data_Bus,
    input logic MIO_EN,
    output logic[15:0] MDR_In
);

always_comb
begin
    case(MIO_EN)
        1'b0: MDR_In = Data_Bus;
        1'b1: MDR_In = Data_to_CPU;
    endcase
end
endmodule

module MUX_PC (
    input logic[15:0] Data_Bus,
    input logic[15:0] Data_Adder,
    input logic[15:0] PC_Next,
    input logic[1:0] Select,
    output logic[15:0] PC_In
);


always_comb
begin
    case (Select)
        default: PC_In = PC_Next;
        2'b10: PC_In = Data_Adder;
        2'b11: PC_In = Data_Bus;
    endcase
end
endmodule

module MUX_Data_Bus(
    input logic[15:0] PC,
    input logic[15:0] MDR,
    input logic[15:0] Data_Adder,
    input logic[15:0] Data_ALU,
    input logic GatePC, GateMDR, GateMARMUX, GateALU,
    output logic[15:0] Data_Bus
);


always_comb
begin
    if (GatePC == 1'b1)
        Data_Bus = PC;
    else if (GateMDR == 1'b1)
        Data_Bus = MDR;
    else if (GateMARMUX == 1'b1)
        Data_Bus = Data_Adder;
    else if (GateALU == 1'b1)
        Data_Bus = Data_ALU;
	 else
		  Data_Bus = 16'b0;
end
endmodule


module MUX_ADDR1(
    input logic[15:0] SR1_OUT,
    input logic[15:0] PC,
    input logic Select,
    output logic[15:0] ADDR1_OUT
);

always_comb
begin
    case (Select)
        1'b0: ADDR1_OUT = PC;
        1'b1: ADDR1_OUT = SR1_OUT;
    endcase
end
endmodule


module MUX_ADDR2(
    input logic[15:0] SEXT6,
    input logic[15:0] SEXT9,
    input logic[15:0] SEXT11,
    input logic [1:0] Select,
    output logic[15:0] ADDR2_OUT
);

always_comb
begin
    case(Select)
        2'b00: ADDR2_OUT = 16'b0;
        2'b01: ADDR2_OUT = SEXT6;
        2'b10: ADDR2_OUT = SEXT9;
        2'b11: ADDR2_OUT = SEXT11;
    endcase
end
endmodule


module MUX_DR(
    input logic[2:0] IR,
    input logic Select,
    output logic[2:0] DR_Out
);

always_comb
begin
    case (Select)
        1'b0: DR_Out = IR;        // IR[11:9]
        1'b1: DR_Out = 3'b111;
    endcase
end
endmodule

module MUX_SR1(
    input logic[2:0] IR68,
    input logic[2:0] IR911,
    input logic Select,
    output logic[2:0] SR1_Out
);

always_comb
begin
    case (Select)
        1'b0: SR1_Out = IR68;
        1'b1: SR1_Out = IR911;
    endcase
end
endmodule

module MUX_SR2(
    input logic[15:0] SEXT5,
    input logic[15:0] SR2_OUT,
    input logic Select,
    output logic[15:0] SR2MUX_OUT
);

always_comb
begin
    case (Select)
        1'b0: SR2MUX_OUT = SR2_OUT;
        1'b1: SR2MUX_OUT = SEXT5;
    endcase
end
endmodule