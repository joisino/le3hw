module inst_memB( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemB imemB( pc, clk, 0, 0, inst );
   
endmodule
