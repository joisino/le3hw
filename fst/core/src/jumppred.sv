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

   logic [15:0] jump_table [15:0];
   logic [15:0] jump_table_valid;
   logic [1:0] pred_shift_register;
   logic [7:0] pcinc_history;

   assign jump_cannot_predict = jump & (!pred_shift_register[1]);
   assign jump_pred_adr_miss = ( jump & pred_shift_register[1] & ( jump_table[pcinc_history[7:4]] != ALUres_mem ) ) | jump_cannot_predict;
   assign jump_pred_miss = (!jump) & pred_shift_register[1];
   assign jump_pred = (!jump_pred_busy) & (jump_inst != 0) & jump_table_valid[ pcinc_id[3:0] ];
   assign jump_pred_adr = jump_table[ pcinc_id[3:0] ];
   assign jump_pred_busy = pred_shift_register[0] | pred_shift_register[1];

   always_ff @(posedge clk) begin
      if( reset ) begin
         pcinc_evac <= 0;
         pcinc_history <= 0;
         jump_table_valid <= 0;
         pred_shift_register <= 0;
      end else begin
         if( jump_pred ) begin
            pcinc_evac <= pcinc_id;
         end             
         if( jump_cannot_predict ) begin // predict not jump, but really jump
            jump_table[ pcinc_history[7:4] ] <= ALUres_mem;
            jump_table_valid[ pcinc_history[7:4] ] <= 1;
            pred_shift_register <= 0;
         end else begin
            if( jump_pred_adr_miss ) begin // predict jump, and jump, but the address is not correct
               jump_table[ pcinc_evac[3:0] ] <= ALUres_mem;
            end
            if( jump_pred_miss ) begin // predict jump, but really not jump
               jump_table_valid[ pcinc_evac[3:0] ] <= 0;
            end
            pred_shift_register <= { pred_shift_register[0], jump_pred };
         end
         pcinc_history <= { pcinc_history[3:0], pcinc_id[3:0] };
      end
   end
   
endmodule
