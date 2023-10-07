//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//------------------------------------------------------------------------------


module slc3(
	input logic [15:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [15:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [7:0] hex_seg,
	output logic [3:0] hex_grid,
	output logic [7:0] hex_segB,
	output logic [3:0] hex_gridB,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In, PC_In, MAR_In, IR_In;
logic [15:0] MAR, MDR, IR, PC;
logic [3:0] hex_4[3:0]; 

logic [15:0] PC_plus;
logic [15:0] Data_Bus;
logic [15:0] MDR_In2;
logic [2:0] NZP;
logic [2:0] NZP_In;
logic [15:0] SR1; 
logic [15:0] SR2; 
logic [2:0] DR_Out;
logic [2:0] SR1_Out;
logic [15:0] ADDR1_Out, ADDR2_Out, ADDR_Out, SR2MUX_OUT, ALU_OUT;
logic [15:0] SEXT5, SEXT6, SEXT9, SEXT11;
assign LED[15:0] = IR[15:0];



//HexDriver HexA (                            //week 1 show IR
//    .clk(Clk),
//    .reset(Reset),
//   .in({IR[15:12], IR[11:8], IR[7:4], IR[3:0]}),
//    .hex_seg(hex_seg),
//   .hex_grid(hex_grid)
//);

// You may use the second (right) HEX driver to display additional debug information
// For example, Prof. Cheng's solution code has PC being displayed on the right HEX
HexDriver HexA (                           
    .clk(Clk),
    .reset(Reset),
   .in({hex_4[3][3:0], hex_4[2][3:0], hex_4[1][3:0], hex_4[0][3:0]}),
    .hex_seg(hex_seg),
   .hex_grid(hex_grid)
);

HexDriver HexB (                
    .clk(Clk),
    .reset(Reset),
    .in({PC[15:12], PC[11:8], PC[7:4], PC[3:0]}),
    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
);
/// logic
assign PC_plus = PC + 1;


// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = { 4'b00, MAR }; ; 
assign MIO_EN = OE;

// Instantiate the rest of your modules here according to the block diagram of the SLC-3
// including your register file, ALU, etc..
reg_16 PC_reg(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .D(PC_In), .Data_Out(PC));
reg_16 MAR_reg(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .D(Data_Bus), .Data_Out(MAR));

reg_16 MDR_reg(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .D(MDR_In2), .Data_Out(MDR));
reg_16 IR_reg(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .D(MDR), .Data_Out(IR));

MUX_PC PC_mux(.Data_Bus(Data_Bus), .Data_Adder(ADDR_Out), .PC_Next(PC_plus), .Select(PCMUX), .PC_In(PC_In));            
MUX_MIO MDR_mux(.Data_to_CPU(MDR_In), .Data_Bus(Data_Bus), .MIO_EN(MIO_EN), .MDR_In(MDR_In2));
MUX_Data_Bus Bus_mux(.PC(PC), .MDR(MDR), .Data_Adder(ADDR_Out), .Data_ALU(ALU_OUT), .GatePC(GatePC), .GateMDR(GateMDR), .GateMARMUX(GateMARMUX), .GateALU(GateALU), .Data_Bus(Data_Bus)); 

nzp_logic NZP_logic(.D(Data_Bus), .Data_Out(NZP_In));
reg_3 NZP_reg(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(NZP_In), .Data_Out(NZP));
BEN_reg BEN_reg(.Clk(Clk), .Reset(Reset), .Load(LD_BEN), .D1(NZP), .D2(IR[11:9]), .Data_Out(BEN));                      //DK IF IT WORKS

MUX_DR DR_MUX(.IR(IR[11:9]), .Select(DRMUX), .DR_Out(DR_Out));
MUX_SR1 SR1_MUX(.IR68(IR[8:6]), .IR911(IR[11:9]), .Select(SR1MUX), .SR1_Out(SR1_Out));
reg_file reg_file(.Clk(Clk), .Reset(Reset), .Load(LD_REG), .DR_In(DR_Out), .SR1_In(SR1_Out), .SR2_In(IR[2:0]), .Data_Bus(Data_Bus), .SR1_Out(SR1), .SR2_Out(SR2));  

SEXT5 SEXT_5(.IR(IR[4:0]), .SEXT5(SEXT5));
SEXT6 SEXT_6(.IR(IR[5:0]), .SEXT6(SEXT6));
SEXT9 SEXT_9(.IR(IR[8:0]), .SEXT9(SEXT9));
SEXT11 SEXT_11(.IR(IR[10:0]), .SEXT11(SEXT11));

MUX_ADDR1 ADDR1_MUX(.SR1_OUT(SR1), .PC(PC), .Select(ADDR1MUX), .ADDR1_OUT(ADDR1_Out));
MUX_ADDR2 ADDR2_Mux(.SEXT6(SEXT6), .SEXT9(SEXT9), .SEXT11(SEXT11), .Select(ADDR2MUX), .ADDR2_OUT(ADDR2_Out));
ADD_ADDR ADD_ADDR(.ADDR1(ADDR1_Out), .ADDR2(ADDR2_Out), .ADDR_Out(ADDR_Out));                                         

MUX_SR2 SR2_MUX (.SEXT5(SEXT5), .SR2_OUT(SR2), .Select(SR2MUX), .SR2MUX_OUT(SR2MUX_OUT));
ALU ALU(.A(SR1), .B(SR2MUX_OUT), .Select(ALUK), .Out(ALU_OUT));


// Our I/O controller (note, this plugs into MDR/MAR)

Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]), 
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);
	
endmodule





