module jumppred( input logic         clk, reset,
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

   logic [15:0] jump_table [31:0];
   logic [1:0] jump_table_valid [31:0];
   logic [1:0] pred_shift_register;
   logic [9:0] pcinc_history;
   logic [4:0] predicted_pcinc;
   logic       jump_cannot_predict;

   assign jump_cannot_predict = jump & (!pred_shift_register[1]);
   assign jump_pred_adr_miss = ( jump & pred_shift_register[1] & ( jump_table[predicted_pcinc] != ALUres_mem ) ) | jump_cannot_predict;
   assign jump_pred_miss = (!jump) & pred_shift_register[1];
   assign jump_pred = (!jump_pred_busy) & (jump_inst != 0) & ( jump_table_valid[ pcinc_id[4:0] ] >= 2 );
   assign jump_pred_adr = jump_table[ pcinc_id[4:0] ];
   assign jump_pred_busy = pred_shift_register[0];
   assign predicted_pcinc = pcinc_history[9:5];
   
   integer i;
   always_ff @(posedge clk) begin
      if( reset ) begin
         pcinc_evac <= 0;
         pcinc_history <= 0;
         for( i = 0; i < 32; i++ ) begin
            jump_table_valid[i] <= 0;
         end
         pred_shift_register <= 0;
      end else begin
         if( jump_pred ) begin
            pcinc_evac <= pcinc_id;
         end
         pred_shift_register <= 0;
         if( jump_cannot_predict ) begin // predict not jump, but really jump
            jump_table[ predicted_pcinc ] <= ALUres_mem;
            case( jump_table_valid[ predicted_pcinc ] ) 
              0: jump_table_valid[ predicted_pcinc ] <= 1;
              1: jump_table_valid[ predicted_pcinc ] <= 2;
              2: jump_table_valid[ predicted_pcinc ] <= 3;
              3: jump_table_valid[ predicted_pcinc ] <= 3;
            endcase
         end else if( jump_pred_adr_miss ) begin // predict jump, and jump, but the address is not correct
            jump_table[ pcinc_evac[4:0] ] <= ALUres_mem;
         end else if( jump_pred_miss ) begin // predict jump, but really not jump
            case( jump_table_valid[ predicted_pcinc ] ) 
              0: jump_table_valid[ predicted_pcinc ] <= 0;
              1: jump_table_valid[ predicted_pcinc ] <= 0;
              2: jump_table_valid[ predicted_pcinc ] <= 1;
              3: jump_table_valid[ predicted_pcinc ] <= 2;
            endcase
         end else begin
            pred_shift_register <= { pred_shift_register[0], jump_pred };
         end
         pcinc_history <= { pcinc_history[4:0], pcinc_id[4:0] };
      end
   end
   
endmodule
