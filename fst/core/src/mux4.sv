module mux4
  #(parameter width = 16)
   ( input logic [width-1:0] a, b, c, d,
     input logic [1:0] en,
     output logic [width-1:0] e );

   always_comb begin
      case(en)
        0:
          e = a;
        1:
          e = b;
        2:
          e = c;
        3:
          e = d;
      endcase // case (en)
   end
endmodule

