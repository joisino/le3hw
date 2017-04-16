module regfile( input logic clk, reset, en,
                input logic [2:0] rr1, rr2, wr,
                input logic [15:0] wd,
                output logic [15:0] rd1, rd2 );

   logic [15:0] rf[7:0];

   always_ff @( posedge clk, posedge reset )
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

   assign rd1 = rf[rr1];
   assign rd2 = rf[rr2];
endmodule
