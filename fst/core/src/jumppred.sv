module jumppred( input logic clk, reset, 
                 input logic         jump,
                 input logic [15:0]  pcinc_id,
                 input logic [15:0]  ALUres_mem,
                 input logic [2:0]   jump_state,
                 input logic [2:0]   jump_inst, 
                 output logic        jump_pred,
                 output logic [15:0] jump_pred_adr,
                 output logic        jump_pred_miss,
                 output logic        jump_pred_adr_miss,
                 output logic [15:0] pcinc_evac,
                 output logic        jump_pred_busy);

   assign jump_pred_adr_miss = jump & ( jump_pred_adr != ALUres_mem );
   assign jump_pred_miss = (!jump) & ( jump_state != 0 );
   assign jump_pred = (!jump_pred_busy) & (jump_inst != 0);

   always_ff @(posedge clk) begin
      if( reset ) begin
         jump_pred_busy <= 0;
         pcinc_evac <= 0;
         jump_pred_adr <= 0;
      end else begin
         if( jump_pred ) begin
            pcinc_evac <= pcinc_id;
            jump_pred_busy <= 1;
         end
         if( jump_pred_adr_miss ) begin
            jump_pred_adr <= ALUres_mem;
         end
         if( jump_state != 0 ) begin
            jump_pred_busy <= 0;
         end
      end
   end
   
endmodule
