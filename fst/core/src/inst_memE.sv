module inst_memE( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemE imemE( pc, clk, 0, 0, inst );
   
endmodule
