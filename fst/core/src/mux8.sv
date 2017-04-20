module mux8
  #(parameter width = 16)
   ( input logic [width-1:0] a, b, c, d, e, f, g, h,
     input logic [2:0] en,
     output logic [width-1:0] res );

   always_comb begin
      case(en)
        0: res <= a;
        1: res <= b;
        2: res <= c;
        3: res <= d;
        4: res <= e;
        5: res <= f;
        6: res <= g;
        7: res <= h;
      endcase // case (en)
   end
endmodule

