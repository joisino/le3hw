module controller( input logic        flushed,
                   input logic [15:0] inst_id,
                   input logic        S_wb, Z_wb, C_wb, V_wb,

                   input logic [2:0]  jump_state,
                   output logic [2:0] jump_inst,

                   input logic [2:0]  register_invalid [7:0],
                   output logic       from_main_mem_id,

                   input logic        jump_pred, 
                   input logic        jump_pred_miss,
                   input logic        jump_pred_adr_miss,
                   input logic        jump_pred_busy, 

                   output logic       flush_decode,
                   
                   output logic       en_ifid, flush_ifid,
                   output logic       en_idex, flush_idex,
                   output logic       en_exmem, flush_exmem,
                   output logic       en_memwb, flush_memwb,
                   output logic       en_pc,

                   output logic       regwrite_cur, 
                   
                   output logic       is_halt_id, 
                   output logic       main_mem_write_id,
                   output logic       jump,
                   output logic       regwrite_id, regwrite_adr_controll,
                   output logic       out_en_id,
                   output logic [1:0] ALUsrcA_controll_id, ALUsrcB_controll_id,
                   output logic [1:0] forwardingA_controll_id, forwardingB_controll_id,
                   output logic [1:0] forwarding_ra_controll_id,
                   output logic [3:0] ALUop_id,
                   output logic [1:0] regwrite_dat_controll_id );

   logic [1:0] op;
   logic [2:0] ra, rb;

   logic [3:0] ty;

   logic data_hazard;

   logic use_ra, use_rb;

   assign regwrite_cur = regwrite_id & (!flush_idex) & en_idex;

   always_comb begin
      op <= inst_id[15:14];
      ra <= inst_id[13:11];
      rb <= inst_id[10:8];
      ty <= inst_id[7:4];
   end

   always_comb begin
      data_hazard <= 0;
      if( ( use_ra & register_invalid[ra] == 1 ) |
          ( use_rb & register_invalid[rb] == 1 ) )
        data_hazard <= 1;
   end
   
   always_comb begin
      case( jump_state )
        1: // B
          jump <= 1;
        2: // BE
          jump <= Z_wb;
        3: // BLT
          jump <= S_wb ^ V_wb;
        4: // BLE
          jump <= Z_wb | ( S_wb ^ V_wb );
        5: // BNE
          jump <= !Z_wb;
	default:
	  jump <= 0;
      endcase
   end

   always_comb begin
      en_ifid <= 1;
      flush_ifid <= 0;
      en_idex <= 1;
      flush_idex <= 0;
      en_exmem <= 1;
      flush_exmem <= 0;
      en_memwb <= 1;
      flush_memwb <= 0;
      en_pc <= 1;
      flush_decode <= 0;
      if( jump_pred_miss | jump_pred_adr_miss ) begin
         flush_ifid <= 1;
         flush_idex <= 1;
         flush_exmem <= 1;
         // flush_memwb <= 1; // when jump, mem phase dealing with jump inst
          flush_decode <= 1;
      end else if( data_hazard | ( jump_pred_busy & jump_inst != 0 ) ) begin
         en_pc <= 0;
         en_ifid <= 0;
         flush_idex <= 1;
      end else if( jump_pred ) begin
         flush_ifid <= 1;
      end
   end

   always_comb begin
      forwardingA_controll_id <= 0;
      forwardingB_controll_id <= 0;
      forwarding_ra_controll_id <= 0;

      if( ALUsrcA_controll_id == 0 )
         case( register_invalid[rb] )
           2: forwardingA_controll_id <= 1;
           3: forwardingA_controll_id <= 2;
         endcase
      
      if( ALUsrcB_controll_id == 0 )
        case( register_invalid[ra] )
          2: forwardingB_controll_id <= 1;
          3: forwardingB_controll_id <= 2;
        endcase

      case( register_invalid[ra] )
        2: forwarding_ra_controll_id <= 1;
        3: forwarding_ra_controll_id <= 2;
      endcase
   end
   
   always_comb begin
      jump_inst <= 0;
      is_halt_id <= 0;
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
      
      if( !flushed ) begin      
         case( op )
           0:  begin // LD
              use_rb <= 1;
              regwrite_id <= 1;
              ALUsrcB_controll_id <= 2;
              regwrite_adr_controll <= 1;
              from_main_mem_id <= 1;
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
                8, 9, 10, 11: begin
                   use_rb <= 1;
                   regwrite_id <= 1;
                   ALUsrcB_controll_id <= 1;
                end
                12: begin
                   regwrite_id <= 1;
                   ALUsrcA_controll_id <= 2;
                   ALUsrcB_controll_id <= 3;
                end
                13: begin
                   use_ra <= 1;
                   out_en_id <= 1;
                end
                15: begin
                   is_halt_id <= 1;
                end
              endcase
           end
         endcase
      end
   end
      
endmodule
