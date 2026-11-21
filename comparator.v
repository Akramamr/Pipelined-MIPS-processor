module comparator #(parameter WIDTH = 32)
                (input [WIDTH-1:0] in0,in1,

                output EqualD);


assign EqualD = (in0 == in1);






endmodule