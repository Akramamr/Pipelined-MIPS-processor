/*
* FILE   : sign_extend file
* AUTHOR : Tony Anwar
* sign extend module based on instructions and opcode
*/
module sign_ext #(
//=============== PARAMETERS ===============//
    parameter INS_WIDTH = 32,
    parameter OUT_WIDTH = 64
) (
//=============== INPUTS ===============//
    input  wire [INS_WIDTH-1:0] instruction,

//=============== OUTPUTS ===============//
    output reg [OUT_WIDTH-1:0] ext_out
);

//=============== OPCODE_SIG ===============//
    reg [6:0] opcode;

    always @(*) begin
        opcode = instruction[6:0];
        case (opcode)
            // I-type
            7'b0000_011: ext_out = {{OUT_WIDTH-12{instruction[INS_WIDTH-1]}},
                                    instruction[INS_WIDTH-1:INS_WIDTH-13]}; 

            // S-type
            7'b0100_011: ext_out = {{OUT_WIDTH-12{instruction[INS_WIDTH-1]}},
                                    instruction[INS_WIDTH-1:INS_WIDTH-7], instruction[11:7]};

            // SB-type
            7'b1100_011: ext_out = {{OUT_WIDTH-12{instruction[INS_WIDTH-1]}},
                                    instruction[INS_WIDTH-1], instruction[7], instruction[INS_WIDTH-2:INS_WIDTH-7],
                                    instruction[11:8]};

            default:     ext_out = {OUT_WIDTH{1'b0}};
        endcase
    end

/*
    PLEASE REVISE if the instruction should not be parameterized to replace
    the code above with one below.
*/
    //     always @(*) begin
    //     case (opcode)
    //         // I-type
    //         7'b0000_011: ext_out = {{OUT_WIDTH-12{instruction[31]}},
    //                                 instruction[31:19]}; 

    //         // S-type
    //         7'b0100_011: ext_out = {{OUT_WIDTH-12{instruction[31]}},
    //                                 instruction[31:25], instruction[11:7]};

    //         // SB-type
    //         7'b1100_011: ext_out = {{OUT_WIDTH-12{instruction[31]}},
    //                                 instruction[31], instruction[7], instruction[30:25],
    //                                 instruction[11:8]};
    //         default:     ext_out = {OUT_WIDTH{1'b0}};
    //     endcase
    // end

    
endmodule