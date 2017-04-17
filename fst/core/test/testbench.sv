`timescale 1 ns/ 1ps
module testbench();

   logic clk, reset;
   logic [15:0] inst_mem_adr;
   logic [15:0] inst;

   logic [15:0] main_mem_read_adr;
   logic [15:0] main_mem_dat;
   logic        main_mem_write;
   logic [15:0] main_mem_write_adr;
   logic [15:0] main_mem_write_dat;

   logic [15:0] in_dat;
   logic        out_en;
   logic [15:0] out_dat;
   logic        is_halt;

   core core( .* );
   // core core( .clk(clk), .reset(reset), .inst_mem_adr(inst_mem_adr), .inst(inst), .main_mem_read_adr(main_mem_read_adr), .main_mem_dat(main_mem_dat), .main_mem_write(main_mem_write), .main_mem_write_adr(main_mem_write_adr), .main_mem_write_dat(main_mem_write_dat), .in_dat(in_dat), .out_en(out_en), .out_dat(out_dat), .is_halt(is_halt) );
   imem imem( .* );
   dmem dmem( .* );
   
   always
     begin
        clk = 1;
        #25;
        assert( (reset == 1) | (!is_halt) ) else $stop;
        clk = 0;
        assert( (reset == 1) | (!is_halt) ) else $stop;
        #25;
     end
   
   initial begin
      reset = 1;
      #130;
      reset = 0;
   end
   
endmodule
