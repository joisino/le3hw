`include "jumpstate.sv"
`include "reginvalid.sv"

module decode( input logic         clk, reset,
               input logic         flushed,
               input logic [15:0]  inst_id,
               input logic         S_wb, Z_wb, C_wb, V_wb,
               input logic [15:0]  pcinc_id,
               input logic [2:0]   regwrite_adr,
               input logic [15:0]  regwrite_dat,
               input logic         regwrite,
               output logic [15:0] rd1_id , rd2_id,
               output logic [3:0]  d_id,
               output logic [15:0] extended_d_id,
               output logic [2:0]  regwrite_adr_id,
               output logic [2:0]  ALUsrcA_controll_id, ALUsrcB_controll_id,
               output logic [3:0]  ALUop_id,
               output logic [15:0] out_dat,
               output logic        out_en,
               output logic        is_halt_id,
               output logic        main_mem_write_id,
               output logic [1:0]  regwrite_dat_controll_id,
               output logic        from_main_mem_id, 
               output logic        regwrite_id,
               output logic        jump,
               output logic        en_ifid, flush_ifid,
               output logic        en_idex, flush_idex,
               output logic        en_exmem, flush_exmem,
               output logic        en_memwb, flush_memwb,
               output logic        en_pc );

   logic regwrite_adr_controll;
   logic [2:0] jump_inst;
   logic [2:0] jump_state;
   logic [2:0] register_invalid[7:0];
   logic regwrite_cur;

   controller core_controller( .* );
   jumpstate jstate( .reset(reset|jump), .* );
   reginvalid reginvalid( .reset(reset|jump), .* );
   mux #(3) mux_regwrite_adr( inst_id[10:8], inst_id[13:11], regwrite_adr_controll, regwrite_adr_id );
   regfile register_file( clk, reset, regwrite, inst_id[13:11], inst_id[10:8], regwrite_adr, regwrite_dat, register_invalid, rd1_id, rd2_id );
   assign out_dat = rd1_id;
   extend extend( inst_id[7:0], extended_d_id );
   assign d_id = inst_id[3:0];
endmodule
