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
    wire [DATA_WIDTH-1:0] pc_in;
    wire [DATA_WIDTH-1:0] pcf;
    wire [DATA_WIDTH-1:0] instr;
    wire [DATA_WIDTH-1:0] pc_plus4;

    // Control_Unit //
    wire                regdst;
    wire                alusrc;
    wire                memtoreg;
    wire                regwrite;
    wire                memwrite;
    wire                branch;
    wire                pcsrc;
    wire                jump;
    wire [aluctl_w-1:0] alucontrol;

    // Data //
    wire [DATA_WIDTH-1:0] SrcA;
    wire [DATA_WIDTH-1:0] SrcB;
    wire [DATA_WIDTH-1:0] write_data;
    wire [4:0]            writereg;
    wire [DATA_WIDTH-1:0] signimm;
    wire [31:0]           shift_2;
    wire [31:0]           pc_branch;
    wire                  zero;
    wire [31:0]           alu_result;
    wire                  sign;
    wire                  overflow;
    wire [DATA_WIDTH-1:0] read_data;

//=============== MODULES ===============//
    // Fetch modules
    mux2 #(
        .WIDTH(DATA_WIDTH)
     ) pc_mux2 (
        .d0(pc_plus4),
        .d1(pc_branch),
        .s (pcsrc),
        .y (pc_in)
    );

    d_ff #(
        .DATA_WIDTH(DATA_WIDTH)
     ) pc_ff (
        .clk(clk),
        .rst(rst),
        .d  (pc_in),
        .q  (pcf)
    );

    adder pc4_adder (
        .a(pcf),
        .b({DATA_WIDTH{1'd4}}),
        .y(pc_plus4)
    );

    imem imem (
        .a (pcf[7:2]),
        .rd(instr)
    );

    // Decode modules

    // Execute modules

    // Memory modules

    // Writeback modules


endmodule

module d_ff #(
    parameter DATA_WIDTH = 32
) (
    input  wire clk,
    input  wire rst,
    input  wire [DATA_WIDTH-1:0] d,
    output reg  [DATA_WIDTH-1:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= {DATA_WIDTH{1'b0}};
        else
            q <= d;
    end
    
endmodule
