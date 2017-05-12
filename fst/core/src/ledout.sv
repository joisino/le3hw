module ledout( input logic        clk,
               input logic        reset,
               input logic [7:0]  out_en,
               input logic [15:0] out_dat [7:0],
               input logic [3:0]  out_pos [7:0],
               output logic [7:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_h,
               output logic [7:0] controll );

   logic [4:0] cnt;
   
   logic [15:0] dat;
   logic [7:0] seg_out_a, seg_out_b, seg_out_c, seg_out_d;

   logic [7:0] segs [63:0];
   
   leddecoder la( out_dat[0][3:0], seg_out_a );
   leddecoder lb( out_dat[0][7:4], seg_out_b );
   leddecoder lc( out_dat[0][11:8], seg_out_c );
   leddecoder ld( out_dat[0][15:12], seg_out_d );

   always_ff @( posedge clk ) begin
      if( reset ) begin
         cnt <= 0;
      end else begin
         cnt <= cnt + 5'b00001;
      end
   end

   always_ff @( posedge clk ) begin
      if( reset ) begin
         integer i;
         for( i = 0; i < 64; i++ ) begin
            segs[i] <= 0;
         end
      end else if( out_en[0] ) begin
         segs[ ( out_pos[0] << 2 ) + 0 ] <= seg_out_a;
         segs[ ( out_pos[0] << 2 ) + 1 ] <= seg_out_b;
         segs[ ( out_pos[0] << 2 ) + 2 ] <= seg_out_c;
         segs[ ( out_pos[0] << 2 ) + 3 ] <= seg_out_d;
      end
   end
   
   always_ff @( posedge clk ) begin
      if( cnt[0] == 0 ) begin
         controll <= 0;
      end else begin
         controll <= ( 8'b0000_0001 << cnt[3:1] );
         seg_a <= segs[ ( cnt[3:1] << 3 ) + 0 ];
         seg_b <= segs[ ( cnt[3:1] << 3 ) + 1 ];
         seg_c <= segs[ ( cnt[3:1] << 3 ) + 2 ];
         seg_d <= segs[ ( cnt[3:1] << 3 ) + 3 ];
         seg_e <= segs[ ( cnt[3:1] << 3 ) + 4 ];
         seg_f <= segs[ ( cnt[3:1] << 3 ) + 5 ];
         seg_g <= segs[ ( cnt[3:1] << 3 ) + 6 ];
         seg_h <= segs[ ( cnt[3:1] << 3 ) + 7 ];
      end
   end
   
endmodule
   
