module memwb( input logic clk, reset, en_memwb, flush_memwb,
              input logic [15:0]  ALUres_mem,
              input logic [15:0]  rd1_mem,
              input logic [15:0]  extended_d_mem,
              input logic         S_mem, C_mem, Z_mem, V_mem,
              input logic         regwrite_mem,
              input logic [1:0]   regwrite_dat_controll_mem,
              input logic [2:0]   regwrite_adr_mem,
              input logic [15:0]  main_mem_dat,
              output logic [15:0] ALUres_wb,
              output logic [15:0] rd1_wb,
              output logic [15:0] extended_d_wb,
              output logic        S_wb, C_wb, Z_wb, V_wb,
              output logic        regwrite,
              output logic [1:0]  regwrite_dat_controll,
              output logic [2:0]  regwrite_adr,
              output logic [15:0] main_mem_dat_wb );
   
   flopr ALUres_flop( clk, reset | flush_memwb, en_memwb, ALUres_mem, ALUres_wb );
   flopr rd1_flop( clk, reset | flush_memwb, en_memwb, rd1_mem, rd1_wb );
   flopr extended_d_flop( clk, reset | flush_memwb, en_memwb, extended_d_mem, extended_d_wb );
   flopr #(1) S_flop( clk, reset | flush_memwb, en_memwb, S_mem, S_wb );
   flopr #(1) C_flop( clk, reset | flush_memwb, en_memwb, C_mem, C_wb );
   flopr #(1) Z_flop( clk, reset | flush_memwb, en_memwb, Z_mem, Z_wb );
   flopr #(1) V_flop( clk, reset | flush_memwb, en_memwb, V_mem, V_wb );
   flopr #(1) regwrite_flop( clk, reset | flush_memwb, en_memwb, regwrite_mem, regwrite );
   flopr #(2) regwrite_dat_controll_flop( clk, reset | flush_memwb, en_memwb, regwrite_dat_controll_mem, regwrite_dat_controll );
   flopr #(3) regwrite_adr_flop( clk, reset | flush_memwb, en_memwb, regwrite_adr_mem, regwrite_adr );
   flopr main_mem_dat_flop( clk, reset | flush_memwb, en_memwb, main_mem_dat, main_mem_dat_wb );
   
endmodule
