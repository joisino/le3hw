module inst_mem( input logic clk,
                 input logic [15:0]  nextpc,
                 output logic [15:0] inst );

   imem imem( nextpc, clk, 0, 0, inst );
   
endmodule
