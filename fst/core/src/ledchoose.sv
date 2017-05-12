module ledchoose( input logic [7:0] seg_cnt_a, seg_cnt_b, seg_cnt_c, seg_cnt_d, seg_cnt_e, seg_cnt_f, seg_cnt_g, seg_cnt_h,
                  input logic [7:0]  seg_out_a, seg_out_b, seg_out_c, seg_out_d,
                  input logic [7:0]  out_en,
                  output logic [7:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h,
                  output logic [7:0] controll );

   always_comb begin
      if( out_en == 0 ) begin
         seg_a <= seg_cnt_a;
         seg_b <= seg_cnt_b;
         seg_c <= seg_cnt_c;
         seg_d <= seg_cnt_d;
         seg_e <= seg_cnt_e;
         seg_f <= seg_cnt_f;
         seg_g <= seg_cnt_g;
         seg_h <= seg_cnt_h;
         controll <= 8'b0000_0001;
      end else begin
         seg_a <= seg_out_a;
         seg_b <= seg_out_b;
         seg_c <= seg_out_c;
         seg_d <= seg_out_d;
         seg_e <= 0;
         seg_f <= 0;
         seg_g <= 0;
         seg_h <= 0;
         controll <= 8'b0000_0010;
      end
   end

endmodule
                  
