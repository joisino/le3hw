module hazard( input logic       use_ra, use_rb,
               input logic [2:0] ra, rb,
               input logic [2:0] register_invalid [7:0],
               input logic       jump_pred,
               input logic       jump_pred_miss,
               input logic       jump_pred_adr_miss,
               input logic       jump_pred_busy,
               input logic [2:0] jump_inst,

               input logic       main_mem_read,
               input logic       main_mem_write,
               input logic       main_mem_ac,
               
               input logic       lock_en, unlock_en,
               input logic       lock_ac,
               
               output logic      flush_decode,
                   
               output logic      en_ifid, flush_ifid,
               output logic      en_idex, flush_idex,
               output logic      en_exmem, flush_exmem,
               output logic      en_memwb, flush_memwb,
               output logic      en_pc,
               
               output logic      memory_waiting );

   logic data_hazard;
   
   logic jump_waiting, lock_waiting;

   assign jump_waiting = jump_pred_busy & jump_inst != 0;
   assign lock_waiting = ( lock_en | unlock_en ) & (!lock_ac);
   assign memory_waiting = ( main_mem_read | main_mem_write ) & (!main_mem_ac);
   
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
      end else if( memory_waiting ) begin
         en_pc <= 0;
         en_ifid <= 0;
         en_idex <= 0;
         en_exmem <= 0;
         flush_memwb <= 1;
      end else if( data_hazard | jump_waiting | lock_waiting ) begin
         en_pc <= 0;
         en_ifid <= 0;
         flush_idex <= 1;
      end else if( jump_pred ) begin
         flush_ifid <= 1;
      end
   end
   
endmodule
