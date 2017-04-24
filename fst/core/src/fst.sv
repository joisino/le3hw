`include "inst_mem.sv"
`include "main_mem.sv"
`include "core.sv"
`include "ledcounter.sv"

module fst
  #( parameter C = 2 )
   ( input logic clk_in, reset_n_in,
     input logic [15:0]  in_dat,
     output logic [7:0]  seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h,
     output logic [7:0]  controll,
     output logic        halting,
     output logic [15:0] pc_out );
   
   logic         clk_n;
   logic 	 reset;
   logic         out_en;
   logic [15:0]  out_dat;
   logic         is_halt;
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
   logic [31:0]  counter;
   logic 	 clk;
   logic 	 reset_n;
   
   assign pc_out = pc;

   assign clk_n = ~clk;
   assign reset = ~reset_n | halting;

   pll( clk_in, clk );

   integer i;
   for( i = 0; i < C; i++ ) begin : generate_core
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
                 .* );
   end

   inst_memA inst_memA( .clk(clk_n), .pc(pc[0]), .inst(inst[0]) );
   inst_memB inst_memB( .clk(clk_n), .pc(pc[1]), .inst(inst[1]) );

   main_mem main_mem( .clk(clk_n), .* );
   
   ledcounter cnter( .clk(clk), .reset_n(reset_n), .stp(halting), .* );
   
   always_ff @( posedge clk ) begin
      halting <= halting | is_halt;
      if( !reset_n ) begin
	 halting <= 0;
      end

      reset_n <= reset_n_in;
   end
   
endmodule
