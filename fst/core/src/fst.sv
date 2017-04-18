module fst( input logic clk, reset_n );
   
   logic         clk_n;
   logic 	 reset;
   logic [15:0]  in_dat;
   logic         out_en;
   logic [15:0]  out_dat;
   logic         is_halt;
   logic [15:0]  nextpc;
   logic [15:0]  inst;
   logic [15:0]  main_mem_read_adr;
   logic [15:0]  main_mem_dat;
   logic         main_mem_write;
   logic [15:0]  main_mem_write_adr;
   logic [15:0]  main_mem_write_dat;
   
   assign clk_n = ~clk;
   assign reset = ~reset_n;
   
   inst_mem inst_mem( .clk(clk), .* );
   main_mem main_mem( .clk(clk_n), .* );
   core core( .* );
   
endmodule
