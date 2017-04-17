module inst_mem( input logic clk,
                 input logic [15:0]  inst_mem,
                 output logic [15:0] inst );

   mem mem( inst_mem, clk, 0, 0, inst );
   
endmodule
