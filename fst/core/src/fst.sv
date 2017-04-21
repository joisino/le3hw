`include "inst_mem.sv"
`include "main_mem.sv"
`include "core.sv"
`include "ledcounter.sv"

module fst( input logic clk_in, reset_n_in,
	    input logic [15:0] 	in_dat,
	    output logic [7:0] 	seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h,
	    output logic [7:0] 	controll,
            output logic 	halting,
            output logic [15:0] pc_out );
   
   logic         clk_n;
   logic 	 reset;
   logic         out_en;
   logic [15:0]  out_dat;
   logic         is_halt;
   logic [15:0]  pc;
   logic [15:0]  inst;
   logic [15:0]  main_mem_read_adr;
   logic [15:0]  main_mem_dat;
   logic         main_mem_write;
   logic [15:0]  main_mem_write_adr;
   logic [15:0]  main_mem_write_dat;
   logic [31:0]  counter;
   logic 	 clk;
   logic 	 reset_n;
   
   assign pc_out = pc;

   assign clk_n = ~clk;
   assign reset = ~reset_n | halting;

   pll( clk_in, clk );
   
   inst_mem inst_mem( .clk(clk_n), .* );
   main_mem main_mem( .clk(clk_n), .* );
   core core( .* );

   ledcounter cnter( .clk(clk), .reset_n(reset_n), .stp(halting), .* );
   
   always_ff @( posedge clk ) begin
      halting = halting | is_halt;
      if( !reset_n ) begin
	 halting = 0;
      end

      reset_n <= reset_n_in;
   end
   
endmodule
