module controller( input logic        flushed,
                   input logic [15:0] inst_id,

                   input logic [2:0]  jump_state,
                   output logic [2:0] jump_inst,

                   input logic [2:0]  register_invalid [7:0],
                   output logic       from_main_mem_id,
                   
                   output logic       is_halt_id, 
                   output logic       main_mem_write_id,
                   output logic       main_mem_read_id,
                   output logic       main_mem_write_request,
                   output logic       main_mem_read_request,
                   output logic       lock_en_id, unlock_en_id,

                   output logic       regwrite_id, regwrite_adr_controll,
                   output logic       out_en_id,
                   output logic [1:0] ALUsrcA_controll_id, ALUsrcB_controll_id,
                   output logic [3:0] ALUop_id,
                   output logic [1:0] regwrite_dat_controll_id,

                   output logic [3:0] d_id,

                   output logic       use_ra, use_rb,
                   output logic [2:0] ra, rb );

   logic [1:0] op;

   logic [3:0] ty;

   assign main_mem_write_request = main_mem_write_id;
   assign main_mem_read_request = main_mem_read_id;

   always_comb begin
      op <= inst_id[15:14];
      ra <= inst_id[13:11];
      rb <= inst_id[10:8];
      ty <= inst_id[7:4];
      d_id <= inst_id[3:0];
   end

   always_comb begin
      jump_inst <= 0;
      is_halt_id <= 0;
      main_mem_read_id <= 0; 
      main_mem_write_id <= 0;
      regwrite_id <= 0;
      regwrite_adr_controll <= 0;
      out_en_id <= 0;
      ALUsrcA_controll_id <= 0;
      ALUsrcB_controll_id <= 0;
      ALUop_id <= 15;
      regwrite_dat_controll_id <= 0;
      from_main_mem_id <= 0;
      use_ra <= 0;
      use_rb <= 0;
      lock_en_id <= 0;
      unlock_en_id <= 0;
      
      if( !flushed ) begin      
         case( op )
           0:  begin // LD
              use_rb <= 1;
              regwrite_id <= 1;
              ALUsrcB_controll_id <= 2;
              regwrite_adr_controll <= 1;
              from_main_mem_id <= 1;
              main_mem_read_id <= 1;
           end
           1: begin // ST
              use_ra <= 1;
              use_rb <= 1;
              main_mem_write_id <= 1;
              ALUsrcB_controll_id <= 2;
           end
           2: begin
              case(ra)
                0: begin // LI
                   regwrite_id <= 1;
                   regwrite_dat_controll_id <= 3;
                end
                1: begin // ADDI
                   use_rb <= 1;
                   regwrite_id <= 1;
                   ALUop_id <= 0;
                   ALUsrcB_controll_id <= 2;
                end
                2: begin // CMPI
                   use_rb <= 1;
                   ALUop_id <= 5;
                   ALUsrcB_controll_id <= 2;
                end
                3: begin // LOCK, UNLOCK
                   if( inst_id[0] ) begin // UNLOCK
                      unlock_en_id <= 1;
                   end else begin // LOCK
                      lock_en_id <= 1;
                   end
                end
                4: begin // B
                   jump_inst <= 1;
                   ALUsrcA_controll_id <= 1;
                   ALUsrcB_controll_id <= 2;
                end
                5: begin // BAL
                   jump_inst <= 1;
                   ALUsrcA_controll_id <= 1;
                   ALUsrcB_controll_id <= 2;
                   regwrite_id <= 1;
                   regwrite_dat_controll_id <= 2;
                   regwrite_adr_controll <= 0;
                end
                6: begin // BR
                   jump_inst <= 1;
                   ALUsrcB_controll_id <= 2;
                end
                7: begin
                   jump_inst <= 1;
                   ALUsrcA_controll_id <= 1;
                   ALUsrcB_controll_id <= 2;
                   case(rb)
                     0: // BE
                       jump_inst <= 2;
                     1: // BLT
                       jump_inst <= 3;
                     2: // BLE
                       jump_inst <= 4;
                     3: // BNE
                       jump_inst <= 5;
                     default:
                       is_halt_id <= 1;
                   endcase
                end
              endcase
           end
           3: begin
              ALUop_id <= ty;
              case(ty)
                0, 1, 2, 3, 4: begin
                   use_ra <= 1;
                   use_rb <= 1;
                   regwrite_id <= 1;
                end
                5: begin
                   use_ra <= 1;
                   use_rb <= 1;
                end
                6: begin // MOV
                   use_ra <= 1;
                   ALUsrcA_controll_id <= 2;
                   regwrite_id <= 1;
                   regwrite_dat_controll_id <= 0;
                end
                8, 9, 10, 11: begin // SHIFT
                   use_rb <= 1;
                   regwrite_id <= 1;
                   if( d_id == 0 ) begin
                      use_ra <= 1;
                   end else begin
                      ALUsrcB_controll_id <= 1;
                   end
                end
                12: begin
                   regwrite_id <= 1;
                   ALUsrcA_controll_id <= 2;
                   ALUsrcB_controll_id <= 3;
                end
                13: begin // OUT
                   use_ra <= 1;
                   use_rb <= 1;
                   out_en_id <= 1;
                end
                15: begin
                   is_halt_id <= 1;
                end
                default: begin
                   is_halt_id <= 1;
                end
              endcase
           end
         endcase
      end
   end
      
endmodule
