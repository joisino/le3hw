module flopr
  #( parameter width = 16 )
   ( input logic clk, reset, en,
     input logic [width-1:0] d,
     output logic [width-1:0] q );

   always_ff @( posedge clk, posedge reset )
     if( reset ) q <= 0;
     else if( en ) q <= d;

endmodule
