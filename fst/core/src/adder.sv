module adder
  #( parameter width = 16 )
   ( input logic [width-1:0] a, b,
     output logic [width-1:0] c,
     output logic carry );

   logic [width:0] buffer;

   always_comb begin
      buffer = a + b;
      c = buffer[width-1:0];
      carry = buffer[width];
   end
endmodule
