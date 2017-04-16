module controller( input logic [15:0] inst,
                   input logic        S, Z, C, V,

                   output logic       is_halt, 
                   output logic       main_mem_write,
                   output logic       jump,
                   output logic       regwrite, regwrite_adr_controll,
                   output logic       out_en,
                   output logic [1:0] ALUsrcA_controll, ALUsrcB_controll,
                   output logic [3:0] ALUop,
                   output logic [1:0] regwrite_controll,
                   output logic       SZCV_controll );

   logic [1:0] op;
   logic [2:0] ra, rb;

   logic [4:0] ty;

   always_comb begin
      op <= inst[15:14];
      ra <= inst[13:11];
      rb <= inst[10:8];
      ty <= inst[7:4];
   end

   
   always_comb begin

      is_halt <= 0;
      main_mem_write <= 0;
      jump <= 0;
      regwrite <= 0;
      regwrite_adr_controll <= 0;
      out_en <= 0;
      ALUsrcA_controll <= 0;
      ALUsrcB_controll <= 0;
      ALUop <= 15;
      regwrite_controll <= 0;
      SZCV_controll <= 0;
      
      case( op )
        0:  begin // LD
           regwrite <= 1;
           ALUsrcB_controll <= 2;
           regwrite_controll <= 2;
           regwrite_adr_controll <= 1;
        end
        1: begin // ST
           main_mem_write <= 1;
           ALUsrcB_controll <= 2;
        end
        2: begin
           case(ra)
             0: begin // LI
                regwrite <= 1;
                regwrite_controll <= 3;
             end
             4: begin // B
                jump <= 1;
                ALUsrcA_controll <= 1;
                ALUsrcB_controll <= 2;
             end
             7: begin
                ALUsrcA_controll <= 1;
                ALUsrcB_controll <= 2;
                case(rb)
                  0: // BE
                    jump <= Z;
                  1: // BLT
                    jump <= S ^ V;
                  2: // BLE
                    jump <= Z || ( S ^ V );
                  3: // BNE
                    jump <= !Z;
                endcase
             end
           endcase
        end
        3: begin
           ALUop <= ty;
           case(ty)
             0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11:
               SZCV_controll <= 1;
           endcase // case (ty)
           case(ty)
             0, 1, 2, 3, 4: begin
                regwrite <= 1;
             end
             5: begin 
             end
             6: begin
                regwrite <= 1;
                regwrite_controll <= 1;
             end
             8, 9, 10, 11: begin
                regwrite <= 1;
                ALUsrcB_controll <= 1;
             end
             12: begin
                regwrite <= 1;
                ALUsrcA_controll <= 2;
                ALUsrcB_controll <= 3;
             end
             13: begin
                out_en <= 1;
             end
             15: begin
                is_halt <= 1;
             end
           endcase
        end
      endcase
   end
   
   
   /*
   always_comb begin
      // is_halt
      if( op == 3 & ty == 15 )
        is_halt <= 1; // HLT
      else
        is_halt <= 0;
      
      // main_mem_write
      if( op == 1 )
        main_mem_write <= 1; // ST
      else
        main_mem_write <= 0;
      
      // jump
      if( op == 2 ) begin
         if( ra == 4 )
           jump <= 1; // B
         else begin
            case(rb)
              0: // BE
                jump <= Z;
              1: // BLT
                jump <= S ^ V;
              2: // BLE
                jump <= Z || ( S ^ V );
              3: // BNE
                jump <= !Z;
            endcase
         end
      end else
        jump <= 0;

      // regwrite
      if( op == 0 )
        regwrite <= 1;
      else if( op == 2 & ra == 0 )
        regwrite <= 1; // LI
      else if( op == 3 ) begin
         case( ty )
           0, 1, 2, 3, 4, 6, 8, 9, 10, 11, 12: // ADD SUB AND OR XOR MOV SLL SLR SRL SRA IN
             regwrite <= 1;
           default:
             regwrite <= 0;
         endcase
      end else
        regwrite <= 0;
      

      // regwrite_adr_controll
      if( op == 0 )
        regwrite_adr_controll <= 1; // LD
      else
        regwrite_adr_controll <= 0;

      if( op == 3 & ty == 13 )
        out_en <= 1; // OUT
      else
        out_en <= 0;

      // ALUsrcA_controll
      if( op == 2 )
        ALUsrcA_controll <= 1; // B BEQ BLT BLE BNE
      else if( op == 3 & ty == 12 )
        ALUsrcA_controll <= 2; // IN
      else
        ALUsrcA_controll <= 0;

      // ALUsrcB_controll
      if( op == 3 ) begin
         case( op )
           0, 1, 2, 3, 4, 5:
             ALUsrcB_controll <= 0;
           8, 9, 10, 11:
             ALUsrcB_controll <= 1;
           12:
             ALUsrcB_controll <= 3;
         endcase
      end else 
        ALUsrcB_controll <= 2; // LD ST B BEQ BLT BLE BNE

      // ALUop
      if( op == 3 )
        ALUop <= ty;
      else
        ALUop <= 15;
      
      // regwrite_controll
      if( op == 0 )
        regwrite_controll <= 2; // LD
      else if( op == 2 & ra == 0 )
        regwrite_controll <= 3; // LI
      else if( op == 3 & ty == 6 )
         regwrite_controll <= 1;
      else
        regwrite_controll <= 0;


      // SZCV_controll
      if( op == 3 ) begin
         case(ty)
           0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11:
             SZCV_controll <= 1;
           default:
             SZCV_controll <= 0;
         endcase // case (ty)
      end else
        SZCV_controll <= 0;
   end // always_comb
    */
      
endmodule
