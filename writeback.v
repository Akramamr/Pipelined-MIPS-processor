module writeback(
input clk, rst,
input ResultSrcW,
input [31:0] PCPlus4W, ALU_ResultW, ReadDataW,
output [31:0] ResultW
);

mux2 result_mux (    
                .d0(ALU_ResultW),
                .d1(ReadDataW),
                .s(ResultSrcW),
                .y(ResultW)
                );
endmodule