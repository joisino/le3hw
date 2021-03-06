`ifndef DEFINE_EXMEM
`define DEFINE_EXMEM


module exmem( input logic clk, reset, en_exmem, flush_exmem,
              input logic [15:0]  ALUres_ex,
              input logic         S_ex, C_ex, Z_ex, V_ex,
              input logic [15:0]  pcinc_ex, 
              input logic [15:0]  rd1_ex2,
              input logic [15:0]  rd2_ex2, 
              input logic [15:0]  extended_d_ex,
              input logic [2:0]   regwrite_adr_ex,
              input logic         main_mem_write_ex,
              input logic         main_mem_read_ex,
              input logic [1:0]   regwrite_dat_controll_ex,
              input logic         from_main_mem_ex,
              input logic         regwrite_ex,
              input logic         is_halt_ex,
              input logic         out_en_ex,
              output logic [15:0] ALUres_mem,
              output logic        S_mem, C_mem, Z_mem, V_mem,
              output logic [15:0] pcinc_mem,
              output logic [15:0] rd1_mem,
              output logic [15:0] extended_d_mem,
              output logic [2:0]  regwrite_adr_mem,
              output logic        main_mem_write,
              output logic        main_mem_read,
              output logic [1:0]  regwrite_dat_controll,
              output logic        from_main_mem_mem,
              output logic        regwrite_mem,
              output logic        is_halt,
              output logic        out_en,
              output logic [3:0]  out_pos );
   
   flopr ALUres_flop( clk, reset | flush_exmem, en_exmem, ALUres_ex, ALUres_mem );
   flopr #(1) S_flop( clk, reset | flush_exmem, en_exmem, S_ex, S_mem );
   flopr #(1) C_flop( clk, reset | flush_exmem, en_exmem, C_ex, C_mem );
   flopr #(1) Z_flop( clk, reset | flush_exmem, en_exmem, Z_ex, Z_mem );
   flopr #(1) V_flop( clk, reset | flush_exmem, en_exmem, V_ex, V_mem );
   flopr pcinc_flop( clk, reset | flush_exmem, en_exmem, pcinc_ex, pcinc_mem );
   flopr rd1_flop( clk, reset | flush_exmem, en_exmem, rd1_ex2, rd1_mem );
   flopr extended_d_flop( clk, reset | flush_exmem, en_exmem, extended_d_ex, extended_d_mem );
   flopr #(3) regwrite_adr_flop( clk, reset | flush_exmem, en_exmem, regwrite_adr_ex, regwrite_adr_mem );
   flopr #(1) main_mem_write_flop( clk, reset | flush_exmem, en_exmem, main_mem_write_ex, main_mem_write );
   flopr #(1) main_mem_read_flop( clk, reset | flush_exmem, en_exmem, main_mem_read_ex, main_mem_read );
   flopr #(2) regwrite_dat_controll_flop( clk, reset | flush_exmem, en_exmem, regwrite_dat_controll_ex, regwrite_dat_controll );
   flopr #(1) from_main_mem_flop( clk, reset | flush_exmem, en_exmem, from_main_mem_ex, from_main_mem_mem );
   flopr #(1) regwrite_flop( clk, reset | flush_exmem, en_exmem, regwrite_ex, regwrite_mem );
   flopr #(1) is_halt_flop( clk, reset | flush_exmem, en_exmem, is_halt_ex, is_halt );
   flopr #(1) out_en_flop( clk, reset | flush_exmem, en_exmem, out_en_ex, out_en );
   flopr #(4) out_pos_flop( clk, reset | flush_exmem, en_exmem, rd2_ex2[3:0], out_pos );

endmodule

`endif
