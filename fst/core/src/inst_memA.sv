module inst_memA( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemA imemA( pc, clk, 0, 0, inst );
   
endmodule
