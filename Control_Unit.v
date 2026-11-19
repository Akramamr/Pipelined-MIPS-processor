module control_unit#(
    parameter op_w = 6, //opcode width
    parameter func_w = 6 , // funct port width
    parameter aluctl_w = 3, // alucontrol output width

    //opcodes

    localparam  [op_w -1 : 0]   op_rtype     = 6'b000000, 
    localparam  [op_w -1 : 0]   op_lw        = 6'b100011, 
    localparam  [op_w -1 : 0]   op_sw        = 6'b101011, 
    localparam  [op_w -1 : 0]   op_beq       = 6'b000100, 
    localparam  [op_w -1 : 0]   op_addi      = 6'b001000, 
    localparam  [op_w -1 : 0]   op_j         = 6'b000010, 

    // Funct codes (R-type) 

    localparam  [func_w -1 : 0] f_add        = 6'b100000, 
    localparam  [func_w -1 : 0] f_sub        = 6'b100010, 
    localparam  [func_w -1 : 0] f_and        = 6'b100100, 
    localparam  [func_w -1 : 0] f_or         = 6'b100101, 
    localparam  [func_w -1 : 0] f_slt        = 6'b101010, 

    //Alu control 

    localparam  [aluctl_w -1 : 0] alu_add    = 3'b010, 
    localparam  [aluctl_w -1 : 0] alu_sub    = 3'b110, 
    localparam  [aluctl_w -1 : 0] alu_and    = 3'b000, 
    localparam  [aluctl_w -1 : 0] alu_or     = 3'b001, 
    localparam  [aluctl_w -1 : 0] alu_slt    = 3'b111
)(

    input [op_w-1 : 0 ] opcode,
    input [func_w-1: 0] funct,
    input               zero,

    output regdst,
    output alusrc,
    output memtoreg,
    output regwrite,
    output memwrite,
    output branch,
    output pcsrc,
    output jump,
    output [aluctl_w-1:0] alucontrol

);

    wire       [1:0]             ALU_op ;
    reg        [8:0]             controls;
    reg [aluctl_w-1 : 0 ]        alu_r;
    assign pcsrc = branch & zero; //zero flag cntrl
    

    assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, ALU_op, jump} = controls;
    assign alucontrol = alu_r;

    always @(*) begin

        case (opcode)
            op_rtype   : controls = 9'b1_1_0_0_0_0_10_0;
            op_lw      : controls = 9'b1_0_1_0_0_1_00_0;
            op_sw      : controls = 9'b0_0_1_0_1_0_00_0;
            op_beq     : controls = 9'b0_0_0_1_0_0_01_0;
            op_addi    : controls = 9'b1_0_1_0_0_0_00_0;
            op_j       : controls = 9'b0_0_0_0_0_0_00_1;
            default: controls = 9'b0;
        endcase


        case (ALU_op)
            2'b00 : alu_r = alu_add;
            2'b01 : alu_r = alu_sub;
            default: case (funct)
                f_add : alu_r = alu_add;
                f_sub : alu_r = alu_sub;
                f_and : alu_r = alu_and;
                f_or  : alu_r = alu_or ;
                f_slt : alu_r = alu_slt;
                default:alu_r = alu_and;
            endcase
        endcase
        
    end




endmodule
