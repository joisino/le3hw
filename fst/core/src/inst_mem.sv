module inst_mem( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imem imem( pc, clk, 0, 0, inst );
   
endmodule
