/*
* FILE   : top_single_cycle.v
* AUTHOR : Tony Anwar
* Top Module for single cycle
*/
module moduleName #(
//=============== PARAMETERS ===============//
    parameter op_w       = 6, //opcode width
    parameter func_w     = 6 , // funct port width
    parameter aluctl_w   = 3, // alucontrol output width
    parameter mem_depth  = 64,
    parameter MUX_WIDTH  = 8,
    parameter ADDR_WIDTH = 5,
    parameter REG_COUNT  = 32,
    parameter DATA_WIDTH = 32,
    parameter INS_WIDTH  = 16

) (
//=============== INPUTS ===============//
    input  wire                  clk,
    input  wire                  rst,

//=============== OUTPUTS ===============//
    output wire [DATA_WIDTH-1:0] pc_out,
    output wire [DATA_WIDTH-1:0] alu_result_out,
    output wire [DATA_WIDTH-1:0] write_data_out
);
//=============== SIGNALS ===============//
    // initatial //
    reg [DATA_WIDTH-1:0] pc_in;
    reg [DATA_WIDTH-1:0] pc;
    reg [DATA_WIDTH-1:0] instr;
    reg [DATA_WIDTH-1:0] pc_plus4;

    // Control_Unit //
    reg                regdst;
    reg                alusrc;
    reg                memtoreg;
    reg                regwrite;
    reg                memwrite;
    reg                branch;
    reg                pcsrc;
    reg                jump;
    reg [aluctl_w-1:0] alucontrol;

    // Data //
    reg [DATA_WIDTH-1:0] SrcA;
    reg [DATA_WIDTH-1:0] SrcB;
    reg [DATA_WIDTH-1:0] write_data;
    reg [4:0]            writereg;
    reg [DATA_WIDTH-1:0] signimm;
    reg [31:0]           shift_2;
    reg [31:0]           pc_branch;
    reg                  zero;
    reg [31:0]           alu_result;
    reg                  sign;
    reg                  overflow;
    reg [DATA_WIDTH-1:0] read_data;

//=============== MODULES ===============//


endmodule
