module pri ( input logic [7:0] a,
             input logic [2:0]  c,
             output logic [2:0] q,
             output logic       en );

   logic [7:0] b;
   logic [2:0] res;

   assign b = { a , a } >> c;
   assign q = res + c;
   
   always_comb begin
      res <= 0;
      en <= 1;
      if( b[0] ) begin
         res <= 0;
      end else if( b[1] ) begin
         res <= 1;
      end else if( b[2] ) begin
         res <= 2;
      end else if( b[3] ) begin
         res <= 3;
      end else if( b[4] ) begin
         res <= 4;
      end else if( b[5] ) begin
         res <= 5;
      end else if( b[6] ) begin
         res <= 6;
      end else if( b[7] ) begin
         res <= 7;
      end else begin
         en <= 0;
      end
   end
   
endmodule
