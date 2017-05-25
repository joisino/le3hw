module music( input logic       clk,
              input logic       reset,
              input logic       mflug,
              input logic [3:0] mperiod,
              output logic      mout );

   logic [15:0] adr;
   logic [15:0] cnta;
   logic [15:0] cntb;
   logic [31:0] cntc;
   logic [15:0] period;
   logic [15:0] perioda;
   logic [15:0] periodb;

   always_ff @(posedge clk) begin
      if( reset | (!mflug) ) begin
         mout <= 0;
         perioda <= 0;
         periodb <= 0;
         adr <= 0;
         cnta <= 0;
         cntb <= 0;
         cntc <= 0;
      end else begin
         periodb <= period;
         perioda <= ( periodb >> 1 );
         cnta <= cnta + 16'b1;
         if( cnta[10] ) begin
            cntb <= cntb + 16'b1;
            cntc <= cntc + 1;
            cnta <= 0;
         end
         if( periodb[14] ) begin
            adr <= 0;
         end
         if( cntc[14:11] == mperiod ) begin
            adr <= adr + 16'b1;
            cntb <= 0;
            cntc <= 0;
         end
         if( cntb == perioda ) begin
            mout <= 0;
         end else if( cntb == periodb ) begin
            mout <= 1;
            cntb <= 0;
         end
      end
   end

   mmem mmem( adr, clk, period );

endmodule
