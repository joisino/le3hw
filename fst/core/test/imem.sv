module imem( input logic [15:0] pc,
             output logic [15:0] inst );

   logic [15:0] RAM[65535:0];

   initial
     $readmemb( "imem.bin", RAM );

   assign inst = RAM[pc];
endmodule
       

