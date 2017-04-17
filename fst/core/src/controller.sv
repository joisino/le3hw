module controller( input logic [15:0] inst_id,
                   // input logic        S_wb, Z_wb, C_wb, V_wb,

                   output logic       is_halt, 
                   output logic       main_mem_write_id,
                   // output logic       jump,
                   output logic       regwrite_id, regwrite_adr_controll,
                   output logic       out_en,
                   output logic [1:0] ALUsrcA_controll_id, ALUsrcB_controll_id,
                   output logic [3:0] ALUop_id,
                   output logic [1:0] regwrite_dat_controll_id );
                   // output logic       SZCV_controll );

   logic [1:0] op;
   logic [2:0] ra, rb;

   logic [4:0] ty;

   always_comb begin
      op <= inst_id[15:14];
      ra <= inst_id[13:11];
      rb <= inst_id[10:8];
      ty <= inst_id[7:4];
   end

   
   always_comb begin

      is_halt <= 0;
      main_mem_write_id <= 0;
      // jump <= 0;
      regwrite_id <= 0;
      regwrite_adr_controll <= 0;
      out_en <= 0;
      ALUsrcA_controll_id <= 0;
      ALUsrcB_controll_id <= 0;
      ALUop_id <= 15;
      regwrite_dat_controll_id <= 0;
      // SZCV_controll <= 0;
      
      case( op )
        0:  begin // LD
           regwrite_id <= 1;
           ALUsrcB_controll_id <= 2;
           regwrite_dat_controll_id <= 2;
           regwrite_adr_controll <= 1;
        end
        1: begin // ST
           main_mem_write_id <= 1;
           ALUsrcB_controll_id <= 2;
        end
        2: begin
           case(ra)
             0: begin // LI
                regwrite_id <= 1;
                regwrite_dat_controll_id <= 3;
             end
             4: begin // B
                // jump <= 1;
                ALUsrcA_controll_id <= 1;
                ALUsrcB_controll_id <= 2;
             end
             7: begin
                ALUsrcA_controll_id <= 1;
                ALUsrcB_controll_id <= 2;
                /*
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
                 */
             end
           endcase
        end
        3: begin
           ALUop_id <= ty;
           /*
           case(ty)
             0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11:
               // SZCV_controll <= 1;
           endcase 
            */
           case(ty)
             0, 1, 2, 3, 4: begin
                regwrite_id <= 1;
             end
             5: begin 
             end
             6: begin
                regwrite_id <= 1;
                regwrite_dat_controll_id <= 1;
             end
             8, 9, 10, 11: begin
                regwrite_id <= 1;
                ALUsrcB_controll_id <= 1;
             end
             12: begin
                regwrite_id <= 1;
                ALUsrcA_controll_id <= 2;
                ALUsrcB_controll_id <= 3;
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
      
endmodule
