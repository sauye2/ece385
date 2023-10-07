module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    logic   c0, c1, c2, c3, c4, c5, c6, c7, c8, sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15, sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23;


    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

     module MUX(
            input logic select,
            input logic d0, d1,
            output logic sum);

            assign sum = (d0 & ~select) | (d1 & select);
    endmodule


    module CRA (
                input logic x0, x1, x2, x3, y0, y1, y2, y3,
                input logic c_in,
                output logic s0, s1, s2, s3,
                output logic c_out);
                logic z1, z2, z3;

            module full_adder (input logic x, y, z,
                        output logic s, c );
                            
            assign s = x^y^z;
            assign c = (x&y)|(y&z)|(x&z);
            endmodule

        full_adder RA0(.x(x0), .y(y0), .z(c_in), .s(s0), .c(z1));
        full_adder RA1(.x(x1), .y(y1), .z(z1), .s(s1), .c(z2));
        full_adder RA2(.x(x2), .y(y2), .z(z2), .s(s2), .c(z3));
        full_adder RA3(.x(x3), .y(y3), .z(z3), .s(s3), .c(c_out));
        endmodule

CRA FA0(.x0(A[0]), .x1(A[1]), .x2(A[2]), .x3(A[3]), .y0(B[0]), .y1(B[1]), .y2(B[2]), .y3(B[3]), .c_in(cin), .s0(S[0]), .s1(S[1]), .s2(S[2]), .s3(S[3]), .c_out(c0));

CRA FA1(.x0(A[4]), .x1(A[5]), .x2(A[6]), .x3(A[7]), .y0(B[4]), .y1(B[5]), .y2(B[6]), .y3(B[7]), .c_in(1'b0), .s0(sum0), .s1(sum1), .s2(sum2), .s3(sum3), .c_out(c1));             // cin = 0
CRA FA2(.x0(A[4]), .x1(A[5]), .x2(A[6]), .x3(A[7]), .y0(B[4]), .y1(B[5]), .y2(B[6]), .y3(B[7]), .c_in(1'b1), .s0(sum4), .s1(sum5), .s2(sum6), .s3(sum7), .c_out(c2));             // cin = 1

MUX M0(.select(c0), .d0(sum0), .d1(sum4), .sum(S[4]));         //determine S[4]
MUX M1(.select(c0), .d0(sum1), .d1(sum5), .sum(S[5]));
MUX M2(.select(c0), .d0(sum2), .d1(sum6), .sum(S[6]));
MUX M3(.select(c0), .d0(sum3), .d1(sum7), .sum(S[7]));
assign c3 = c1 | (c0 & c2);

CRA FA3(.x0(A[8]), .x1(A[9]), .x2(A[10]), .x3(A[11]), .y0(B[8]), .y1(B[9]), .y2(B[10]), .y3(B[11]), .c_in(1'b0), .s0(sum8), .s1(sum9), .s2(sum10), .s3(sum11), .c_out(c4));             // cin = 0
CRA FA4(.x0(A[8]), .x1(A[9]), .x2(A[10]), .x3(A[11]), .y0(B[8]), .y1(B[9]), .y2(B[10]), .y3(B[11]), .c_in(1'b1), .s0(sum12), .s1(sum13), .s2(sum14), .s3(sum15), .c_out(c5));             // cin = 1
MUX M4(.select(c3), .d0(sum8), .d1(sum12), .sum(S[8]));        
MUX M5(.select(c3), .d0(sum9), .d1(sum13), .sum(S[9]));
MUX M6(.select(c3), .d0(sum10), .d1(sum14), .sum(S[10]));
MUX M7(.select(c3), .d0(sum11), .d1(sum15), .sum(S[11]));
assign c6 = c4 | (c3 & c5);

CRA FA5(.x0(A[12]), .x1(A[13]), .x2(A[14]), .x3(A[15]), .y0(B[12]), .y1(B[13]), .y2(B[14]), .y3(B[15]), .c_in(1'b0), .s0(sum16), .s1(sum17), .s2(sum18), .s3(sum19), .c_out(c7));             // cin = 0
CRA FA6(.x0(A[12]), .x1(A[13]), .x2(A[14]), .x3(A[15]), .y0(B[12]), .y1(B[13]), .y2(B[14]), .y3(B[15]), .c_in(1'b1), .s0(sum20), .s1(sum21), .s2(sum22), .s3(sum23), .c_out(c8));             // cin = 1
MUX M8(.select(c6), .d0(sum16), .d1(sum20), .sum(S[12]));         
MUX M9(.select(c6), .d0(sum17), .d1(sum21), .sum(S[13]));
MUX M10(.select(c6), .d0(sum18), .d1(sum22), .sum(S[14]));
MUX M11(.select(c6), .d0(sum19), .d1(sum23), .sum(S[15]));
assign cout = c7 | (c6 & c8);

endmodule
