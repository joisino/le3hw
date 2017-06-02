module inst_memD( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemD imemD( pc, clk, 0, 0, inst );
   
endmodule
