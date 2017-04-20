`timescale 1 ns/ 100 ps
module fst_testbench();

   logic clk, reset_n;
   logic [7:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h;
   logic [7:0] controll;
   logic halting;
   logic [7:0] pc;

   fst fst( .clk(clk), .reset_n(reset_n), .seg_a(seg_a), .seg_b(seg_b), .seg_c(seg_c), .seg_d(seg_d), .seg_e(seg_e), .seg_f(seg_f), .seg_g(seg_g), .seg_h(seg_h), .controll(controll),  .halting(halting), .pc_out(pc) );

   always
     begin
        clk = 1;
        #25;
        assert( (reset_n == 0) | (!halting) ) else $stop;
        clk = 0;
        assert( (reset_n == 0) | (!halting) ) else $stop;
        #25;
     end
   
   initial begin
      reset_n = 0;
      #130;
      reset_n = 1;
   end
   
endmodule
