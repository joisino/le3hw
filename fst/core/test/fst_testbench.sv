`timescale 1 ns/ 100 ps
module fst_testbench();

   logic clk, reset_n;
   logic [15:0] pc_out;

   fst fst( .clk(clk), .reset_n(reset_n), .pc_out(pc_out) );
   
   always
     begin
        clk = 1;
        #100;
        clk = 0;
        #100;
     end
   
   initial begin
      reset_n = 0;
      #230;
      reset_n = 1;
   end
   
endmodule
