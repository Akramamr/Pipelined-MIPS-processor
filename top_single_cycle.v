/*
* FILE   : top_single_cycle.v
* AUTHOR : Tony Anwar
* Top Module for single cycle
*/
module top_single_cycle #(
//=============== PARAMETERS ===============//
    parameter op_w       = 6, //opcode width
    parameter func_w     = 6 , // funct port width
    parameter aluctl_w   = 4, // alucontrol output width
    parameter mem_depth  = 64,
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
    wire [DATA_WIDTH-1:0] pc_jump_in;
    wire [DATA_WIDTH-1:0] pc_jump_out;
    wire [27:0]           pc_jump_shifted;
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
    wire [31:0]           signimm_shift2;
    wire [31:0]           pc_branch;
    wire                  zero;
    wire [31:0]           alu_result;
    wire                  sign;
    wire                  overflow;
    wire [DATA_WIDTH-1:0] read_data;
    wire [DATA_WIDTH-1:0] result;

//=============== MODULES ===============//
    // Fetch modules //
    mux2 #(
        .WIDTH(DATA_WIDTH)
     ) pc_mux2 (
        .d0(pc_plus4),
        .d1(pc_branch),
        .s (pcsrc),
        .y (pc_in)
    );

    assign pc_jump_in = {pc_plus4[31:28], pc_jump_shifted};
    mux2 #(
        .WIDTH(DATA_WIDTH)
     ) pc_jump_mux2 (
        .d0(pc_in),
        .d1(pc_jump_in),
        .s (jump),
        .y (pc_jump_out)
    );

    d_ff #(
        .DATA_WIDTH(DATA_WIDTH)
     ) pc_ff (
        .clk(clk),
        .rst(rst),
        .d  (pc_jump_out),
        .q  (pcf)
    );

    adder pc4_adder (
        .a(pcf),
        .b({{(DATA_WIDTH-3){1'b0}}, 3'd4}),
        .y(pc_plus4)
    );

    imem instr_mem (
        .a (pcf[7:2]),
        .rd(instr)
    );

    shifter jumb_shifter (
        .a         (instr[25:0]),
        .shift_amt (5'd2),
        .shift_type(1'b0),
        .y         (pc_jump_shifted)
    );

    // Control Unit //
    control_unit #(
        .op_w    (op_w     /* default 6 */),
        .func_w  (func_w   /* default 6 */),
        .aluctl_w(aluctl_w /* default 3 */)
    ) control_unit_module (
        .opcode    (instr[31:26]),
        .funct     (instr[5:0]),
        .zero      (zero),
        .regdst    (regdst),
        .alusrc    (alusrc),
        .memtoreg  (memtoreg),
        .regwrite  (regwrite),
        .memwrite  (memwrite),
        .branch    (branch),
        .pcsrc     (pcsrc),
        .jump      (jump),
        .alucontrol(alucontrol)
    );

    // Decode modules //
    reg_file #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .REG_COUNT  (REG_COUNT),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_reg_file (
        .clk        (clk),
        .rst        (rst),
        .rd_reg1    (instr[25:21]),
        .rd_reg2    (instr[20:16]),
        .wr_reg     (writereg),
        .en_reg_wr  (regwrite),
        .wr_data    (result),
        .rd_data1   (SrcA),
        .rd_data2   (write_data)
    );

    sign_ext #(
        .INS_WIDTH (INS_WIDTH),
        .OUT_WIDTH (DATA_WIDTH)
    ) u_sign_ext (
        .instruction (instr[15:0]),
        .ext_out     (signimm)
    );


    // Execute modules
    // write reg mux
    mux2 #(
        .WIDTH(5)
    ) write_reg_mux (
        .d0 (instr[20:16]),
        .d1 (instr[15:11]),
        .s  (regdst),
        .y  (writereg)
    );

    // scrB mux
    mux2 #(
        .WIDTH(DATA_WIDTH)
        ) alu_src_mux (
        .d0 (write_data),
        .d1 (signimm),
        .s  (alusrc),
        .y  (SrcB)
    );

    // alu
    alu alu_module (
        .a         (SrcA),
        .b         (SrcB),
        .shamt     (instr[10:6]),
        .alucontrol(alucontrol),
        .result    (alu_result),
        .zero      (zero),
        .sign      (sign),
        .overflow  (overflow)
    );

    // shift by 2
    shifter shiftby2 (
        .a         (signimm),
        .shift_amt (5'd2),
        .shift_type(1'b0),
        .y         (signimm_shift2)
    );

    // adder pcbranch
       adder branch_adder (
        .a (signimm_shift2),
        .b (pc_plus4),
        .y (pc_branch)
    );

    // Memory modules //
    dmem #(
        .size     (DATA_WIDTH /* default 32 */),
        .mem_depth(mem_depth /* default 64 */)
    ) dmem_module (
        .clk(clk),
        .we (memwrite),
        .a  (alu_result),
        .wd (write_data),
        .rd (read_data)
    );

    // Writeback modules //
    mux2 #(
        .WIDTH(DATA_WIDTH /* default 8 */)
     ) alu_mux2 (
        .d0(alu_result),
        .d1(read_data),
        .s (memtoreg),
        .y (result)
    );

    // outputs
    assign pc_out         = pcf;
    assign alu_result_out = alu_result;
    assign write_data_out = write_data;


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
