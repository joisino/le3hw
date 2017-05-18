module inst_memF( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemF imemF( pc, clk, 0, 0, inst );
   
endmodule
