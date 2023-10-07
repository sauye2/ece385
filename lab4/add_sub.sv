    module full_adder (input logic x, y, z,
        output logic s, c );


        assign s = x^y^z;
        assign c = (x&y)|(y&z)|(x&z);
    endmodule



module add_sub
(
	input logic [7:0] A, B,
    input logic fn,
	output logic [7:0] S,
    output logic X);
	
    logic   c1, c2, c3, c4, c5, c6, c7, c8, BB8;
    logic [7:0] BB;      

    assign BB = (B ^ {8{fn}});

    full_adder FA0(.x(A[0]), .y(BB[0]), .z(fn), .s(S[0]), .c(c1));
    full_adder FA1(.x(A[1]), .y(BB[1]), .z(c1), .s(S[1]), .c(c2));
    full_adder FA2(.x(A[2]), .y(BB[2]), .z(c2), .s(S[2]), .c(c3));
    full_adder FA3(.x(A[3]), .y(BB[3]), .z(c3), .s(S[3]), .c(c4));
    full_adder FA4(.x(A[4]), .y(BB[4]), .z(c4), .s(S[4]), .c(c5));
    full_adder FA5(.x(A[5]), .y(BB[5]), .z(c5), .s(S[5]), .c(c6));
    full_adder FA6(.x(A[6]), .y(BB[6]), .z(c6), .s(S[6]), .c(c7));
    full_adder FA7(.x(A[7]), .y(BB[7]), .z(c7), .s(S[7]), .c(c8));
    full_adder FA8(.x(A[7]), .y(BB[7]), .z(c8), .s(X), .c());


endmodule