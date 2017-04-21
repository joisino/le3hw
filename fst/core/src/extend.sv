module extend( input logic [7:0] a,
               output logic [15:0] res );

   logic [15:0] signed_a;
   
   signext sign_extend( a, signed_a );

   always_comb begin
      if( a[7:3] == 5'b10000 ) begin
         case( a[2:0] )
           0: res <= 16'b0000000010000000;
           1: res <= 16'b0000000100000000;
           2: res <= 16'b0000001000000000;
           3: res <= 16'b0000010000000000;
           4: res <= 16'b0000100000000000;
           5: res <= 16'b0001000000000000;
           6: res <= 16'b0010000000000000;
           7: res <= 16'b0100000000000000;
         endcase
      end else if( a[7:3] == 5'b10001 ) begin
         case( a[2:0] )
           0: res <= 16'b0000000011111111;
           1: res <= 16'b0000000111111111;
           2: res <= 16'b0000001111111111;
           3: res <= 16'b0000011111111111;
           4: res <= 16'b0000111111111111;
           5: res <= 16'b0001111111111111;
           6: res <= 16'b0011111111111111;
           7: res <= 16'b0111111111111111;
         endcase
      end else begin
         res <= signed_a;
      end
   end
   
endmodule
