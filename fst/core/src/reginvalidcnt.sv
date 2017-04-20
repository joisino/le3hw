module reginvalidcnt( input logic clk, reset,
                      input logic [1:0] nex,
                      input logic [2:0] d,
                      output logic [2:0] q );

   always_ff @(posedge clk) begin
      if( reset )
        q <= 0;
      else begin
         if( nex == 0 ) begin
            case( d )
              1: q <= 3;
              2: q <= 3;
              3: q <= 4;
              default: q <= 0;
            endcase
         end else
           q <= nex;
      end
   end
endmodule
