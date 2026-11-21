module hazard_unit(input [4:0] rsD,rtD,rtE,rsE,
                   input [4:0] WriteRegM,WriteRegW,WriteRegE,
                   input RegWriteM,RegWriteE,RegWriteW,
                                //RegWriteE
                   input BranchD,MemtoRegM,MemtoRegE,


                   output forwardAD,forwardBD,
                   output reg [1:0] forwardAE,forwardBE,
                   output stallF,stallD,flushE);



wire lwstall,branchstall;



//SOLVING DATA HAZARDS WITH FORWARDING
always @(*) begin
    
    if ((rsE !=0 ) && (rsE == WriteRegM ) && RegWriteM)
        forwardAE = 2'b10;
    else if (((rsE !=0 ) && (rsE == WriteRegW ) && RegWriteW)) begin
        forwardAE = 2'b01;
        
    end
    else forwardAE =2'b00;
end

always @(*) begin
    
    if ((rtE !=0 ) && (rtE == WriteRegM ) && RegWriteM)
        forwardBE = 2'b10;
    else if (((rtE !=0 ) && (rtE == WriteRegW ) && RegWriteW)) begin
        forwardBE = 2'b01;
        
    end
    else forwardBE = 2'b00;

end



//LOAD USE HAZARD HANDLING

assign lwstall =(( rsD == rtE) || (rtD == rtE)) && MemtoRegE;



//BRANCH HAZARD HANDLING

assign forwardAD = (rsD != 0) && (rsD == WriteRegM) && RegWriteM;
assign forwardBD = (rtD != 0) && (rtD == WriteRegM) && RegWriteM;

assign branchstall = BranchD && RegWriteE && (WriteRegE == rsD || WriteRegE ==rtD ) || 
              BranchD && MemtoRegM && (WriteRegM == rsD || WriteRegM == rtD );


assign stallF = lwstall || branchstall;
assign flushE = lwstall || branchstall;
assign stallD = lwstall || branchstall;





endmodule