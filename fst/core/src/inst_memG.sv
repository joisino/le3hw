module inst_memG( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemG imemG( pc, clk, 0, 0, inst );
   
endmodule
