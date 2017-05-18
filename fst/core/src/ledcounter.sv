`include "tencounter.sv"
`include "leddecoder.sv"

module ledcounter( input logic        clk,
		   input logic        reset_n,
		   input logic        stp,
		   output logic [7:0] seg_x, seg_y,
                   output logic [3:0] controll_x, controll_y );

   logic [5:0] cnt;
 
   logic [3:0] ca, cb, cc, cd, ce, cf, cg, ch;
   logic       carry_a, carry_b, carry_c, carry_d, carry_e, carry_f, carry_g, carry_h;

   logic [7:0] seg_cnt_a, seg_cnt_b, seg_cnt_c, seg_cnt_d, seg_cnt_e, seg_cnt_f, seg_cnt_g, seg_cnt_h;
   
   tenc ta( .ad(1), .cur(ca), .nex(ca), .carry(carry_a), .* );
   tenc tb( .ad(carry_a), .cur(cb), .nex(cb), .carry(carry_b), .* );
   tenc tc( .ad(carry_b), .cur(cc), .nex(cc), .carry(carry_c), .* );
   tenc td( .ad(carry_c), .cur(cd), .nex(cd), .carry(carry_d), .* );
   tenc te( .ad(carry_d), .cur(ce), .nex(ce), .carry(carry_e), .* );
   tenc tf( .ad(carry_e), .cur(cf), .nex(cf), .carry(carry_f), .* );
   tenc tg( .ad(carry_f), .cur(cg), .nex(cg), .carry(carry_g), .* );
   tenc th( .ad(carry_g), .cur(ch), .nex(ch), .carry(carry_h), .* );

   leddecoder da( ca, seg_cnt_a );
   leddecoder db( cb, seg_cnt_b );
   leddecoder dc( cc, seg_cnt_c );
   leddecoder dd( cd, seg_cnt_d );
   leddecoder de( ce, seg_cnt_e );
   leddecoder df( cf, seg_cnt_f );
   leddecoder dg( cg, seg_cnt_g );
   leddecoder dh( ch, seg_cnt_h );

   always_ff @( posedge clk ) begin
      if( !reset_n ) begin
         cnt <= 0;
      end else begin
         cnt <= cnt + 6'b000001;
      end
   end
   
   always_ff @( posedge clk ) begin
      if( cnt[3:0] == 0 ) begin
         controll_x <= 4'b1111;
      end else if( cnt[5:4] == 0 ) begin
         controll_x <= 4'b1110;
         seg_x <= seg_cnt_e;
      end else if( cnt[5:4] == 1 ) begin
         controll_x <= 4'b1101;
         seg_x <= seg_cnt_f;
      end else if( cnt[5:4] == 2 ) begin
         controll_x <= 4'b1011;
         seg_x <= seg_cnt_g;
      end else if( cnt[5:4] == 3 ) begin
         controll_x <= 4'b0111;
         seg_x <= seg_cnt_h;
      end
   end

   always_ff @( posedge clk ) begin   
      if( cnt[3:0] == 0 ) begin
         controll_y <= 4'b1111;
      end else if( cnt[5:4] == 0 ) begin
         controll_y <= 4'b1110;
         seg_y <= seg_cnt_a;
      end else if( cnt[5:4] == 1 ) begin
         controll_y <= 4'b1101;
         seg_y <= seg_cnt_b;
      end else if( cnt[5:4] == 2 ) begin
         controll_y <= 4'b1011;
         seg_y <= seg_cnt_c;
      end else if( cnt[5:4] == 3 ) begin
         controll_y <= 4'b0111;
         seg_y <= seg_cnt_d;
      end
   end
   
endmodule
   
