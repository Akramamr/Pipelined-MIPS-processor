
module dmem #(parameter size = 32 , mem_depth = 64)(

    input clk , we ,
    input [size-1:0] a , wd,

    output [size-1:0] rd
);

    reg [size-1:0] RAM [0:mem_depth-1];


    assign rd = RAM [a[31:2]];   //this mean divide by 4 to treat mem as word    

    always @(posedge clk ) begin
        if(we)
        RAM[a[31:2]] <= wd;
        
    end

endmodule