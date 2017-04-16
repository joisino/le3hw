module dmem( input logic clk, main_mem_write,
             input logic [15:0] main_mem_read_adr, main_mem_write_adr, main_mem_write_dat,
             output logic [15:0] main_mem_dat );

   logic [15:0] RAM[65535:0];

   assign main_mem_dat = RAM[main_mem_read_adr];

   always_ff @(posedge clk)
     if( main_mem_write ) RAM[main_mem_write_adr] = main_mem_write_dat;
endmodule
 

