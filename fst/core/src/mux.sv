module mux
  #(parameter width = 16)
   ( input logic [width-1:0] a, b,
     input logic en,
     output logic [width-1:0] c );
   
   assign c = en ? b : a;
endmodule
