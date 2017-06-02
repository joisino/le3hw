`ifndef DEFINE_HAZARD
`define DEFINE_HAZARD


module hazard( input logic       use_ra, use_rb,
               input logic [2:0] ra, rb,
               input logic [2:0] register_invalid [7:0],
               input logic       jump_pred,
               input logic       jump_pred_miss,
               input logic       jump_pred_adr_miss,
               input logic       jump_pred_busy,
               input logic [2:0] jump_inst,

               input logic       main_mem_read_request,
               input logic       main_mem_write_request,
               input logic       main_mem_ac,
               
               input logic       lock_en_id, unlock_en_id,
               input logic       lock_ac,
               output logic      lock_hazard,
               
               output logic      flush_decode,
                   
               output logic      en_ifid, flush_ifid,
               output logic      en_idex, flush_idex,
               output logic      en_exmem, flush_exmem,
               output logic      en_memwb, flush_memwb,
               output logic      en_pc );

   logic data_hazard;
   
   logic jump_waiting, lock_waiting, memory_waiting;

   assign jump_waiting = jump_pred_busy & jump_inst != 0;
   assign lock_waiting = ( lock_en_id | unlock_en_id ) & (!lock_ac);
   assign lock_hazard = ( lock_en_id | unlock_en_id ) & ( register_invalid[rb] == 1 | register_invalid[rb] == 2 );
   assign memory_waiting = ( main_mem_read_request | main_mem_write_request ) & ( !main_mem_ac );

   always_comb begin
      data_hazard <= 0;
      if( ( use_ra & register_invalid[ra] == 1 ) |
          ( use_rb & register_invalid[rb] == 1 ) )
        data_hazard <= 1;
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
         flush_decode <= 1;
      end else if( data_hazard | jump_waiting | memory_waiting | lock_waiting | lock_hazard ) begin
         en_pc <= 0;
         en_ifid <= 0;
         flush_idex <= 1;
      end else if( jump_pred ) begin
         flush_ifid <= 1;
      end
   end
   
endmodule

`endif
