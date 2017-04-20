module regfile( input logic clk, reset, en,
                input logic [2:0]   rr1, rr2, wr,
                input logic [15:0]  wd,
                input logic [2:0]   register_invalid [7:0],
                output logic [15:0] rd1, rd2 );

   logic [15:0] rf[7:0];

   always_ff @( posedge clk )
     if( reset ) begin
        rf[0] = 0;
        rf[1] = 0;
        rf[2] = 0;
        rf[3] = 0;
        rf[4] = 0;
        rf[5] = 0;
        rf[6] = 0;
        rf[7] = 0;
     end
     else if( en ) rf[wr] = wd;

   always_comb begin
      if( register_invalid[rr1] == 4 )
        rd1 <= wd;
      else
        rd1 <= rf[rr1];

      if( register_invalid[rr2] == 4 )
        rd2 <= wd;
      else
        rd2 <= rf[rr2];
   end
endmodule
