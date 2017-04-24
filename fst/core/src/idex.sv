module idex( input logic clk, reset, en_idex, flush_idex,
             input logic [15:0]  pcinc_id,
             input logic [15:0]  rd1_id, rd2_id,
             input logic [3:0]   d_id,
             input logic [15:0]  extended_d_id,
             input logic [2:0]   regwrite_adr_id,
             input logic [1:0]   ALUsrcA_controll_id, ALUsrcB_controll_id,
             input logic [1:0]   forwardingA_controll_id, forwardingB_controll_id,
             input logic [1:0]   forwarding_ra_controll_id,
             input logic [3:0]   ALUop_id,
             input logic         main_mem_write_id,
             input logic         main_mem_read_id,
             input logic [1:0]   regwrite_dat_controll_id,
             input logic         from_main_mem_id,
             input logic         regwrite_id,
             input logic         is_halt_id,
             input logic         out_en_id,
             input logic [15:0]  out_dat_id, 
             output logic [15:0] pcinc_ex,
             output logic [15:0] rd1_ex, rd2_ex,
             output logic [3:0]  d_ex,
             output logic [15:0] extended_d_ex,
             output logic [2:0]  regwrite_adr_ex,
             output logic [1:0]  ALUsrcA_controll, ALUsrcB_controll,
             output logic [1:0]  forwardingA_controll, forwardingB_controll,
             output logic [1:0]  forwarding_ra_controll,
             output logic [3:0]  ALUop,
             output logic        main_mem_write_ex,
             output logic        main_mem_read_ex,
             output logic [1:0]  regwrite_dat_controll_ex,
             output logic        from_main_mem_ex,
             output logic        regwrite_ex,
             output logic        is_halt_ex,
             output logic        out_en_ex,
             output logic [15:0] out_dat_ex  );

   
   flopr pcinc_flop( clk, reset | flush_idex, en_idex, pcinc_id, pcinc_ex );
   flopr rd1_flop( clk, reset | flush_idex, en_idex, rd1_id, rd1_ex );
   flopr rd2_flop( clk, reset | flush_idex, en_idex, rd2_id, rd2_ex );
   flopr #(4) d_flop( clk, reset | flush_idex, en_idex, d_id, d_ex );
   flopr extended_d_flop( clk, reset | flush_idex, en_idex, extended_d_id, extended_d_ex );
   flopr #(3) regwrite_adr_flop( clk, reset | flush_idex, en_idex, regwrite_adr_id, regwrite_adr_ex );
   flopr #(2) ALUsrcA_controll_flop( clk, reset | flush_idex, en_idex, ALUsrcA_controll_id, ALUsrcA_controll );
   flopr #(2) ALUsrcB_controll_flop( clk, reset | flush_idex, en_idex, ALUsrcB_controll_id, ALUsrcB_controll );
   flopr #(2) forwardingA_controll_flop( clk, reset | flush_idex, en_idex, forwardingA_controll_id, forwardingA_controll );
   flopr #(2) forwardingB_controll_flop( clk, reset | flush_idex, en_idex, forwardingB_controll_id, forwardingB_controll );
   flopr #(2) forwarding_ra_controll_flop( clk, reset | flush_idex, en_idex, forwarding_ra_controll_id, forwarding_ra_controll );
   flopr #(4) ALUop_flop( clk, reset | flush_idex, en_idex, ALUop_id, ALUop );
   flopr #(1) main_mem_write_flop( clk, reset | flush_idex, en_idex, main_mem_write_id, main_mem_write_ex );
   flopr #(1) main_mem_read_flop( clk, reset | flush_idex, en_idex, main_mem_read_id, main_mem_read_ex );
   flopr #(2) regwrite_dat_controll_flop( clk, reset | flush_idex, en_idex, regwrite_dat_controll_id, regwrite_dat_controll_ex );
   flopr #(1) from_main_mem_flop( clk, reset | flush_idex, en_idex, from_main_mem_id, from_main_mem_ex );
   flopr #(1) regwrite_flop( clk, reset | flush_idex, en_idex, regwrite_id, regwrite_ex );
   flopr #(1) is_halt_flop( clk, reset | flush_idex, en_idex, is_halt_id, is_halt_ex );
   flopr #(1) out_en_flop( clk, reset | flush_idex, en_idex, out_en_id, out_en_ex );
   flopr out_dat_flop( clk, reset | flush_idex, en_idex, out_dat_id, out_dat_ex );
   

endmodule
