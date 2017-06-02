`ifndef DEFINE_MEMWB
`define DEFINE_MEMWB

module memwb( input logic clk, reset, en_memwb, flush_memwb,
              input logic [15:0]  regwrite_dat_mem, 
              input logic         S_mem, C_mem, Z_mem, V_mem,
              input logic         regwrite_mem,
              input logic         from_main_mem_mem,
              input logic [2:0]   regwrite_adr_mem,
              input logic [15:0]  main_mem_dat,
              output logic [15:0] regwrite_dat_wb, 
              output logic        S_wb, C_wb, Z_wb, V_wb,
              output logic        regwrite,
              output logic         from_main_mem,
              output logic [2:0]  regwrite_adr,
              output logic [15:0] main_mem_dat_wb );

   flopr regwrite_dat_flop( clk, reset | flush_memwb, en_memwb, regwrite_dat_mem, regwrite_dat_wb );
   flopr #(1) S_flop( clk, reset | flush_memwb, en_memwb, S_mem, S_wb );
   flopr #(1) C_flop( clk, reset | flush_memwb, en_memwb, C_mem, C_wb );
   flopr #(1) Z_flop( clk, reset | flush_memwb, en_memwb, Z_mem, Z_wb );
   flopr #(1) V_flop( clk, reset | flush_memwb, en_memwb, V_mem, V_wb );
   flopr #(1) regwrite_flop( clk, reset | flush_memwb, en_memwb, regwrite_mem, regwrite );
   flopr #(1) from_main_mem_flop( clk, reset | flush_memwb, en_memwb, from_main_mem_mem, from_main_mem );
   flopr #(3) regwrite_adr_flop( clk, reset | flush_memwb, en_memwb, regwrite_adr_mem, regwrite_adr );
   flopr main_mem_dat_flop( clk, reset | flush_memwb, en_memwb, main_mem_dat, main_mem_dat_wb );
   
endmodule

`endif
