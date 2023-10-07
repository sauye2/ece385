module lookahead_adder (               // figure 5
	input logic [15:0] A, B,
	input logic  cin,
	output logic [15:0] S,
	output logic cout);

    logic PG0, PG4, PG8, PG12, GG0, GG4, GG8, GG12;
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

                                                                                       // figure 4
        module CLA (
        input logic x0, x1, x2, x3, y0, y1, y2, y3, cinit, 
        output logic pg, gg, s0, s1, s2, s3);                 // z is Cin for each adder

        assign g0 = x0&y0;
        assign g1 = x1&y1;
        assign g2 = x2&y2;
        assign g3 = x3&y3;
        assign p0 = x0^y0;
        assign p1 = x1^y1;
        assign p2 = x2^y2;               
        assign p3 = x3^y3;

        assign c1 = cinit&&p0 || g0;
        assign c2 = cinit&&p0&&p1 || g0&&p1 || g1;
        assign c3 = cinit&&p0&&p1&&p2||g0&&p1&&p2 || g1&&p2 || g2;


        assign s0 = x0^y0^cinit;
        assign s1 = x1^y1^c1;
        assign s2 = x2^y2^c2;
        assign s3 = x3^y3^c3;

        assign pg = p0 && p1 && p2 && p3;
        assign gg = g3 || g2&&p3 || g1&&p3&&p2 || g0&&p3&&p2&&p1;
        
        endmodule
        
    CLA FA0(.x0(A[0]),.x1(A[1]),.x2(A[2]),.x3(A[3]), .y0(B[0]), .y1(B[1]), .y2(B[2]), .y3(B[3]), .cinit(cin), .s0(S[0]), .s1(S[1]), .s2(S[2]), .s3(S[3]), .pg(PG0), .gg(GG0));
    assign c4 = GG0 || cin&&PG0;
     
    CLA FA1(.x0(A[4]),.x1(A[5]),.x2(A[6]),.x3(A[7]), .y0(B[4]), .y1(B[5]), .y2(B[6]), .y3(B[7]), .cinit(c4), .s0(S[4]), .s1(S[5]), .s2(S[6]), .s3(S[7]), .pg(PG4), .gg(GG4));
    assign c8 = GG4 || GG0&&PG4 || cin&&PG0&&PG4;
     
    CLA FA2(.x0(A[8]),.x1(A[9]),.x2(A[10]),.x3(A[11]), .y0(B[8]), .y1(B[9]), .y2(B[10]), .y3(B[11]), .cinit(c8), .s0(S[8]), .s1(S[9]), .s2(S[10]), .s3(S[11]),.pg(PG8), .gg(GG8));
    assign c12 = GG8 || GG4&&PG8 || GG0&&PG8&&PG4 || cin&&PG8&&PG4&&PG0;
    
    CLA FA3(.x0(A[12]),.x1(A[13]),.x2(A[14]),.x3(A[15]), .y0(B[12]), .y1(B[13]), .y2(B[14]), .y3(B[15]), .cinit(c12), .s0(S[12]), .s1(S[13]), .s2(S[14]), .s3(S[15]), .pg(PG12), .gg(GG12));
    assign cout = GG12 || GG8&&PG12 || GG4&&PG12&&PG8 || GG0&&PG12&&PG8&&PG4 || cin&&PG12&&PG8&&PG4&&PG0;

endmodule