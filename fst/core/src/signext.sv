module signext( input logic [7:0] a,
                output logic [15:0] b );
   
   assign b = { {8{a[7]}}, a[7:0] };
endmodule
