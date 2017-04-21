module fetch( input logic clk,
              input logic         reset,
              input logic [15:0]  ALUres_mem,
              input logic         jump_pred,
              input logic [15:0]  jump_pred_adr,
              input logic         jump_pred_miss,
              input logic         jump_pred_adr_miss,
              input logic [15:0]  pcinc_evac,
              input logic         en_pc,
              output logic [15:0] pcinc,
              output logic [15:0] pc );

   logic [15:0] nextpc;

   // mux mux_pc( pcinc, ALUres_mem, jump, nextpc );
   flopr pc_flop( clk, reset, en_pc, nextpc, pc );
   assign pcinc = pc + 16'b1;

   always_comb begin
      nextpc <= pcinc;
      if( jump_pred ) nextpc <= jump_pred_adr;
      else if( jump_pred_miss ) nextpc <= pcinc_evac;
      else if( jump_pred_adr_miss ) nextpc <= ALUres_mem;
   end
   
endmodule
