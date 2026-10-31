module shifter (
    input [31:0] a,           
    input [4:0]  shift_amt,      
    input        shift_type,  
    output reg [31:0] y      
);

always @(*) begin
    case (shift_type)
        1'b0: y = a << shift_amt;                
        1'b1: y = a >> shift_amt;   
        default: y = 32'b0;
    endcase
end

endmodule