`timescale 1 ns/ 100 ps
module fst_testbench();

   logic clk, reset_n;
   logic [7:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h;
   logic [7:0] controll );

   fst fst( .clk(clk), .reset_n(reset_n), .* );

   always
     begin
        clk = 1;
        #25;
        assert( (reset_n == 0) | (!is_halt) ) else $stop;
        clk = 0;
        assert( (reset_n == 0) | (!is_halt) ) else $stop;
        #25;
     end
   
   initial begin
      reset_n = 0;
      #130;
      reset_n = 1;
   end
   
endmodule
