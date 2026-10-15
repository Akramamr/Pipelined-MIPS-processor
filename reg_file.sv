/*
* FILE   : reg_file
* AUTHOR : Tony Anwar
* register file module
*/
module reg_file #(
//=============== PARAMETERS ===============//
    parameter ADDR_WIDTH = 5,
    parameter REG_COUNT  = 32,
    parameter DATA_WIDTH = 32
) (
//=============== INPUTS ===============//
    input  wire clk,    
    input  wire rst,    
    input  wire [ADDR_WIDTH-1:0] rd_reg1,
    input  wire [ADDR_WIDTH-1:0] rd_reg2,    
    input  wire [ADDR_WIDTH-1:0] wr_reg,
    input  wire en_reg_wr,    
    input  wire [DATA_WIDTH-1:0] wr_data,

//=============== OUTPUTS ===============//
    output wire [DATA_WIDTH-1:0] rd_data1,   
    output wire [DATA_WIDTH-1:0] rd_data2   
);

//=============== REG ===============//
    reg [DATA_WIDTH-1:0] registers [REG_COUNT-1:0];
    integer i;

//=============== SEQ_LOGIC ===============//
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < REG_COUNT; i = i+1) begin
                    registers[i] <= {DATA_WIDTH{1'b0}};
            end
        end

        else if(en_reg_wr) begin
            registers[wr_reg] <= wr_data;
        end
        // No end else as registers keeps the previous value
    end

//=============== COMB_LOGIC ===============//
    assign rd_data1 = registers[rd_reg1];
    assign rd_data2 = registers[rd_reg2];
    
endmodule