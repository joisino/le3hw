module fetch( input logic clk,
              input logic reset,
              input logic [15:0] ALUres_mem,
              input logic jump,
              output logic [15:0] pcinc,
              output logic [15:0] pc );

   logic [15:0] nextpc;
   
   mux mux_pc( pcinc, ALUres_mem, jump, nextpc );
   flopr pc_flop( clk, reset, 1'b1, nextpc, pc );
   assign pcinc = pc + 1;

endmodule
