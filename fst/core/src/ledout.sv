module ledout( input logic clk,
               input logic reset,
               input logic [7:0]  out_en,
               input logic [15:0] out_dat [7:0],
               output logic [7:0] seg_out,
               output logic [3:0] controll_out );

   logic [15:0] dat;
   logic [7:0] seg_out_a, seg_out_b, seg_out_c, seg_out_d;
   
   leddecoder la( dat[3:0], seg_out_a );
   leddecoder lb( dat[7:4], seg_out_b );
   leddecoder lc( dat[11:8], seg_out_c );
   leddecoder ld( dat[15:12], seg_out_d );

   always_ff @( posedge clk ) begin
      if( reset ) begin
         dat <= 0;
      end if( out_en[0] ) begin
         dat <= out_dat[0];
      end else if( out_en[1] ) begin
         dat <= out_dat[1];
      end else if( out_en[2] ) begin
         dat <= out_dat[2];
      end else if( out_en[3] ) begin
         dat <= out_dat[3];
      end else if( out_en[4] ) begin
         dat <= out_dat[4];
      end else if( out_en[5] ) begin
         dat <= out_dat[5];
      end else if( out_en[6] ) begin
         dat <= out_dat[6];
      end else if( out_en[7] ) begin
         dat <= out_dat[7];
      end 
   end

   always_ff @( posedge clk ) begin
      if( reset ) begin
         controll_out <= 4'b0001;
      end else begin
         controll_out <= { controll_out, controll_out } >> 1;
      end
   end

   always_ff @( posedge clk ) begin
      if( controll_out == 4'b0001 ) begin
         seg_out <= seg_out_a;
      end else if( controll_out == 4'b0010 ) begin
         seg_out <= seg_out_b;
      end else if( controll_out == 4'b0100 ) begin
         seg_out <= seg_out_c;
      end else if( controll_out == 4'b1000 ) begin
         seg_out <= seg_out_d;
      end else begin
         seg_out <= 8'b0000_0000;
      end
   end
   
endmodule
   
