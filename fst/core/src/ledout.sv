`include "tencounter.sv"
`include "leddecoder.sv"

module ledcounter( input logic [7:0] out_en,
                   input logic [15:0] out_dat [7:0],
                   output logic [7:0] seg_out_a, seg_out_b, seg_out_c, seg_out_d );

   logic [15:0] dat;
   
   leddecoder la( dat[3:0], seg_out_a );
   leddecoder lb( dat[7:4], seg_out_b );
   leddecoder lc( dat[11:8], seg_out_c );
   leddecoder ld( dat[15:12], seg_out_d );

   always_comb begin
      if( out_en[0] ) begin
         dat = out_dat[0];
      end else if( out_en[1] ) begin
         dat = out_dat[1];
      end else if( out_en[2] ) begin
         dat = out_dat[2];
      end else if( out_en[3] ) begin
         dat = out_dat[3];
      end else if( out_en[4] ) begin
         dat = out_dat[4];
      end else if( out_en[5] ) begin
         dat = out_dat[5];
      end else if( out_en[6] ) begin
         dat = out_dat[6];
      end else if( out_en[7] ) begin
         dat = out_dat[7];
      end else if( out_en[8] ) begin
         dat = out_dat[8];
      end else begin
         dat = 0;
      end
   end
   
endmodule
   
