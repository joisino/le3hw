`timescale 1 ns/ 100 ps
module testbench
  #( parameter C = 2 )
   ();

   logic clk, reset;

   logic [15:0]  pc [C-1:0];
   logic [15:0]  inst [C-1:0];
   logic [15:0]  main_mem_read_adr [C-1:0];
   logic [15:0]  main_mem_write_adr [C-1:0];
   logic [15:0]  main_mem_write_dat [C-1:0];
   logic [C-1:0] main_mem_write;
   logic [C-1:0] main_mem_read;
   logic [9:0]   lock_adr [C-1:0];
   logic [C-1:0] lock_en;
   logic [C-1:0] unlock_en;
   logic [15:0]  main_mem_dat;
   logic [C-1:0] main_mem_ac;
   logic [C-1:0] lock_ac;

   logic [15:0]  in_dat;
   logic         out_en;
   logic [15:0]  out_dat;
   logic [C-1:0] is_halt;

   for( genvar i = 0; i < C; i++ ) begin : generate_core
      core core( .main_mem_read_adr(main_mem_read_adr[i]),
                 .main_mem_write_adr(main_mem_write_adr[i]),
                 .main_mem_write_dat(main_mem_write_dat[i]),
                 .main_mem_write(main_mem_write[i]),
                 .main_mem_read(main_mem_read[i]),
                 .main_mem_dat(main_mem_dat),
                 .main_mem_ac(main_mem_ac[i]),
                 .lock_adr(lock_adr[i]),
                 .lock_en(lock_en[i]),
                 .unlock_en(unlock_en[i]),
                 .lock_ac(lock_ac[i]),
                 .pc(pc[i]),
                 .inst(inst[i]),
                 .is_halt(is_halt[i]),
                 .* );
   end

   imemA imemA( .clk(clk), .pc(pc[0]), .inst(inst[0]) );
   imemB imemB( .clk(clk), .pc(pc[1]), .inst(inst[1]) );
   dmem dmem( .* );
   
   always
     begin
        clk = 1;
        #5;
        assert( (reset == 1) | (is_halt==0) ) else $stop;
        clk = 0;
        assert( (reset == 1) | (is_halt==0) ) else $stop;
        #5;
     end
   
   initial begin
      reset = 1;
      #63;
      reset = 0;
   end
   
endmodule
