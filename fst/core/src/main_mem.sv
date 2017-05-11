module main_mem( input logic clk,
                 input logic [15:0]  main_mem_read_adr,
                 output logic [15:0] main_mem_dat,
                 input logic         main_mem_write,
                 input logic [15:0]  main_mem_write_adr,
                 input logic [15:0]  main_mem_write_dat );

   logic [15:0] adr;

   always_comb begin
      if( main_mem_write ) adr <= main_mem_write_adr;
      else adr <= main_mem_read_adr;
   end
   
   dmem dmem( adr, clk, main_mem_write_dat, main_mem_write, main_mem_dat );
   
endmodule
