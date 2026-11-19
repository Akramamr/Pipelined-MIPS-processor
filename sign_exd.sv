/*
* FILE   : sign_extend file
* AUTHOR : Tony Anwar
* sign extend module based on instructions and opcode
*/
module sign_ext #(
//=============== PARAMETERS ===============//
    parameter INS_WIDTH = 16,
    parameter OUT_WIDTH = 32
) (
//=============== INPUTS ===============//
    input  wire [INS_WIDTH-1:0] instruction,

//=============== OUTPUTS ===============//
    output wire [OUT_WIDTH-1:0] ext_out
);

//=============== OPCODE_SIG ===============//

    assign ext_out = {{OUT_WIDTH-12{instruction[INS_WIDTH-1]}},
                     instruction[INS_WIDTH-1:INS_WIDTH-12]};
    
endmodule