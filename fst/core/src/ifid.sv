module ifid( input logic clk, reset, en_ifid, flush_ifid,
             input logic [15:0]  pcinc,
             input logic [15:0]  inst,
             output logic [15:0] pcinc_id,
             output logic [15:0] inst_id );

   flopr pcinc_flop( clk, reset | flush_ifid, en_ifid, pcinc, pcinc_id );
   flopr inst_flop( clk, reset | flush_ifid, en_ifid, inst, inst_id );
   
endmodule
