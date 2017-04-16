module imem( input logic [15:0] inst_mem_adr,
             output logic [15:0] inst );

   logic [15:0] RAM[65535:0];

   initial
     $readmemb( "imem.bin", RAM );

   assign inst = RAM[inst_mem_adr];
endmodule
       

