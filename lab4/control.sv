module control (input  logic Clk, Reset, Run, ClearA_LoadB, M,
                output logic Clr_Ld, Shift, Add, Sub );
                enum logic [4:0] {A,B,C,D,E,F,G,H,I,J,K,L,N,O,P,Q,R,S} curr_state, next_state;

always_ff @ (posedge Clk or posedge Reset )
begin
 if (Reset) // Asynchronous Reset
 curr_state <= A; // A is the reset/start state
 else
 curr_state <= next_state;
end

always_comb
begin
next_state = curr_state; //should never happen

unique case (curr_state)

A : if (Run)                     // reset/stable
next_state = B;
B : next_state = C;              //add
C : next_state = D;              //shift
D : next_state = E;              //add
E : next_state = F;              //shift
F : next_state = G;              //add
G : next_state = H;              //shift
H : next_state = I;              //add
I : next_state = J;              //shift
J : next_state = K;              //add
K : next_state = L;              //shift
L : next_state = N;              //add
N : next_state = O;              //shift
O : next_state = P;              //add
P : next_state = Q;              //shift
Q : next_state = R;              //add/sub
R : next_state = S;              //shift
S : if (~Run)                    //hold until run is off
next_state = A;

endcase

 case (curr_state)
    A: begin
        if(ClearA_LoadB)
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        Add = 1'b0;
        Sub = 1'b0;
    end

    B: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    D: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    F: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    H: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    J: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end
    

    L: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    O: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b1;
        Sub = 1'b0;
        end
    end

    Q: begin
        Clr_Ld = 1'b0;
        Shift = 1'b0;
        if(M) begin
        Add = 1'b0;
        Sub = 1'b1;
        end
    end

    S: begin    
        if(ClearA_LoadB)
        Clr_Ld = 1'b1;           //might be 1'b1
        Shift = 1'b0;
        Add = 1'b0;
        Sub = 1'b0;  
    end

    default: begin
        Clr_Ld = 1'b0;
        Shift = 1'b1;
        Add = 1'b0;
        Sub = 1'b0;
    end

 endcase
end
endmodule