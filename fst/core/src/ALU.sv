module ALU( input logic [3:0] op,
            input logic [15:0] a, b,
            output logic [15:0] res,
            output logic S, Z, C, V );
   
   always_comb begin
      C <= 0;
      res <= 0;

      case( op )
        0:
          { C, res } <= a + b;
        1, 5:
          { C, res } <= a - b;
        2:
          res <= a & b;
        3:
          res <= a | b;
        4:
          res <= a ^ b;
        6:
          res <= a + b;
        8:
          { C, res } <= a << b;
        9:
          res <= { a, a } >> (16-b[3:0]);
        10:
           { res, C } <= { a , 1'b0 } >> b;
        11:
           { res, C } <= { a , 1'b0 } >>> b;
        12:
          res <= a + b;
        15:
          res <= a + b;
      endcase // case ( op )
   end

   always_comb begin
      S <= res[15];
      Z <= ( res == 0 );
      case( op )
        0:
          V <= ( a[15] == b[15] ) & ( a[15] != res[15] );
        1, 5:
          V <= ( a[15] != b[15] ) & ( a[15] != res[15] );
        default:
          V <= 0;
      endcase
   end
   
endmodule      
        
