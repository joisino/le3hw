`include "inst_memA.sv"
`include "inst_memB.sv"
`include "inst_memC.sv"
`include "inst_memD.sv"
`include "inst_memE.sv"
`include "inst_memF.sv"
`include "inst_memG.sv"
`include "inst_memH.sv"
`include "main_mem.sv"
`include "core.sv"
`include "ledcounter.sv"
`include "ledout.sv"
`include "music.sv"

module fst
  #( parameter C = 8 )
   ( input logic        clk_in, reset_n_in,
     input logic        mflug,
     input logic [3:0]  mperiod,  
     input logic [15:0] in_dat,
     output logic       mout,
     output logic [7:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h,
     output logic [7:0] controll,
     output logic [7:0] seg_x, seg_y,
     output logic [3:0] controll_x, controll_y,
     output logic       halting );
   
   logic         clk_n;
   logic 	 reset;
   logic [C-1:0] out_en;
   logic [15:0]  out_dat [C-1:0];
   logic [3:0]   out_pos [C-1:0];
   logic [C-1:0] is_halt;
   logic [15:0]  pc [C-1:0];
   logic [15:0]  inst [C-1:0];
   logic [15:0]  main_mem_read_adr [C-1:0];
   logic [15:0]  main_mem_write_adr [C-1:0];
   logic [15:0]  main_mem_write_dat [C-1:0];
   logic [C-1:0] main_mem_write;
   logic [C-1:0] main_mem_read;
   logic [C-1:0] main_mem_write_request;
   logic [C-1:0] main_mem_read_request;
   logic [3:0] 	 lock_adr [C-1:0];
   logic [C-1:0] lock_en;
   logic [C-1:0] unlock_en;
   logic [15:0]  main_mem_dat;
   logic [C-1:0] main_mem_ac;
   logic [C-1:0] lock_ac;
   logic [31:0]  counter;
   logic 	 clk;
   logic 	 reset_n;
   
   assign clk_n = ~clk;
   assign reset = ~reset_n | halting;

   pll( clk_in, clk );

   genvar i;
   generate
      for( i = 0; i < 8; i++ ) begin : generate_core
         core core( .main_mem_read_adr(main_mem_read_adr[i]),
                    .main_mem_write_adr(main_mem_write_adr[i]),
                    .main_mem_write_dat(main_mem_write_dat[i]),
                    .main_mem_write(main_mem_write[i]),
                    .main_mem_read(main_mem_read[i]),
                    .main_mem_write_request(main_mem_write_request[i]),
                    .main_mem_read_request(main_mem_read_request[i]),
                    .main_mem_dat(main_mem_dat),
                    .main_mem_ac(main_mem_ac[i]),
                    .lock_adr(lock_adr[i]),
                    .lock_en(lock_en[i]),
                    .unlock_en(unlock_en[i]),
                    .lock_ac(lock_ac[i]),
                    .pc(pc[i]),
                    .inst(inst[i]),
		    .is_halt(is_halt[i]),
                    .out_en(out_en[i]),
                    .out_dat(out_dat[i]),
                    .out_pos(out_pos[i]),
                    .* );
      end
   endgenerate

   inst_memA inst_memA( .clk(clk_n), .pc(pc[0]), .inst(inst[0]) );
   inst_memB inst_memB( .clk(clk_n), .pc(pc[1]), .inst(inst[1]) );
   inst_memC inst_memC( .clk(clk_n), .pc(pc[2]), .inst(inst[2]) );
   inst_memD inst_memD( .clk(clk_n), .pc(pc[3]), .inst(inst[3]) );
   inst_memE inst_memE( .clk(clk_n), .pc(pc[4]), .inst(inst[4]) );
   inst_memF inst_memF( .clk(clk_n), .pc(pc[5]), .inst(inst[5]) );
   inst_memG inst_memG( .clk(clk_n), .pc(pc[6]), .inst(inst[6]) );
   inst_memH inst_memH( .clk(clk_n), .pc(pc[7]), .inst(inst[7]) );

   main_mem main_mem( .clk(clk_n), .* );
   
   ledcounter cnter( .clk(clk), .reset_n(reset_n), .stp(halting), .* );
   ledout lout( .* );

   music music( .* );
   
   always_ff @( posedge clk ) begin
      halting <= halting | ( is_halt != 0 );
      if( !reset_n ) begin
	 halting <= 0;
      end

      reset_n <= reset_n_in;
   end
   
endmodule
