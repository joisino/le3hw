module ALU( input logic [3:0] op,
            input logic [15:0] a, b,
            output logic [15:0] res,
            output logic S, Z, C, V );

   logic [16:0] buffer;
   logic [31:0] buffer_to;
   
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
          res <= { a, a } >> b;
        10: begin
           if( b > 0 )
              { buffer, C } <= ( a >> (b-1) );
           else
             res <= a >> b;
        end
        11: begin
           if( b > 0 )
              { buffer, C } <= ( a >>> (b-1) );
           else
             res <= a >>> b;
        end
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
          V <= ( a[15] == b[15] ) & C;
        1, 5:
          V <= ( a[15] != b[15] ) & C;
        default:
          V <= 0;
      endcase
   end
   
endmodule      
        
