module inst_memC( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemC imemC( pc, clk, 0, 0, inst );
   
endmodule
