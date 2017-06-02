`include "fetch.sv"
`include "ifid.sv"
`include "decode.sv"
`include "idex.sv"
`include "exec.sv"
`include "exmem.sv"
`include "mainmem.sv"
`include "memwb.sv"
`include "writeback.sv"

module core( input logic         clk,
             input logic         reset,
             
             input logic [15:0]  in_dat,
             output logic        out_en,
             output logic [15:0] out_dat,
             output logic [3:0]  out_pos,
             output logic        is_halt,

             output logic [15:0] pc,
             input logic [15:0]  inst,

             output logic [15:0] main_mem_read_adr,
             output logic [15:0] main_mem_write_adr,
             output logic [15:0] main_mem_write_dat,
             output logic        main_mem_write,
             output logic        main_mem_read,
             output logic        main_mem_write_request,
             output logic        main_mem_read_request, 
             input logic [15:0]  main_mem_dat,
             input logic         main_mem_ac,
             output logic [3:0]  lock_adr,
             output logic        lock_en,
             output logic        unlock_en,
             input logic         lock_ac );

   logic [15:0] pcinc, pcinc_id, pcinc_ex, pcinc_mem;
   logic        jump_pred;
   logic [15:0] jump_pred_adr;
   logic        jump_pred_miss;
   logic        jump_pred_adr_miss;
   logic [15:0] pcinc_evac;
   logic [15:0] inst_id;
   logic [15:0] rd1_id, rd1_ex, rd1_ex2, rd1_mem, rd1_wb;
   logic [15:0] rd2_id, rd2_ex, rd2_ex2;
   logic [3:0]  d_id, d_ex;
   logic [15:0] extended_d_id, extended_d_ex, extended_d_mem, extended_d_wb;
   logic [2:0]  regwrite_adr_id, regwrite_adr_ex, regwrite_adr_mem, regwrite_adr;
   logic [15:0] regwrite_dat_mem, regwrite_dat_wb, regwrite_dat;
   logic        is_halt_id, is_halt_ex;
   logic        out_en_id, out_en_ex;
   logic [1:0]  ALUsrcA_controll_id, ALUsrcA_controll;
   logic [1:0]  ALUsrcB_controll_id, ALUsrcB_controll;
   logic [1:0]  forwardingA_controll_id, forwardingA_controll;
   logic [1:0]  forwardingB_controll_id, forwardingB_controll;
   logic [1:0]  forwarding_ra_controll_id, forwarding_ra_controll;
   logic [1:0]  forwarding_rb_controll_id, forwarding_rb_controll;
   logic [3:0]  ALUop_id, ALUop;
   logic        main_mem_write_id, main_mem_write_ex;
   logic        main_mem_read_id, main_mem_read_ex;
   logic [15:0] main_mem_dat_wb;
   logic        regwrite_id, regwrite_ex, regwrite_mem, regwrite;
   logic [1:0]  regwrite_dat_controll_id, regwrite_dat_controll_ex, regwrite_dat_controll;
   logic        from_main_mem_id, from_main_mem_ex, from_main_mem_mem, from_main_mem;
   logic [15:0] ALUres_ex, ALUres_mem, ALUres_wb;
   logic        S_ex, S_mem, S_wb;
   logic        C_ex, C_mem, C_wb;
   logic        Z_ex, Z_mem, Z_wb;
   logic        V_ex, V_mem, V_wb;
   logic        flushed;
   logic        en_ifid, flush_ifid;
   logic        en_idex, flush_idex;
   logic        en_exmem, flush_exmem;
   logic        en_memwb, flush_memwb;
   logic        en_pc;
   
   fetch fetch( .* );
   
   ifid ifid( .* );

   decode decode( .* );

   idex idex( .* );

   exec exec( .* );

   exmem exmem( .* );

   mainmem mainmem( .* );

   memwb memwb( .* );

   writeback writeback( .* );
   
endmodule
   
