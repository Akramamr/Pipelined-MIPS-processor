module mux_4x1 #(parameter WIDTH = 32)
                (input [WIDTH-1:0] in0,in1,in2,in3,
                input [1:0] sel,
                output reg [WIDTH-1:0] out);



always @(*) begin
    case(sel) 
        00: out =in0;
        01: out =in1;
        10: out =in2;
        11: out =in3;
        default : out = {WIDTH{1'bx}};
    
    endcase
end







endmodule