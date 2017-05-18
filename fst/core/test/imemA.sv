module imemA( input logic clk,
             input logic [15:0]  pc,
             output logic [15:0] inst );

   logic [15:0] RAM[65535:0];

   initial
     $readmemb( "imemA.bin", RAM );

   always_ff @(negedge clk)
     inst <= RAM[pc];
endmodule
       

