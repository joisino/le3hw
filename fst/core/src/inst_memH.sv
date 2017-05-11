module inst_memH( input logic clk,
                 input logic [15:0]  pc,
                 output logic [15:0] inst );
   
   imemH imemH( pc, clk, 0, 0, inst );
   
endmodule
