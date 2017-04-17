module exec( input logic [15:0] rd1_ex, rd2_ex,
             input logic [15:0] pcinc_ex,
             input logic [1:0] ALUsrcA_controll_ex, ALUsrcB_controll_ex,
             input logic [15:0] d_ex, extended_d_ex,
             input logic [15:0] in_dat,
             input logic [3:0] ALUop,
             output logic [15:0] ALUres_ex,
             output logic S_ex, Z_ex, C_ex, V_ex,
             output logic main_mem_read_adr_ex,
             output logic main_mem_write_adr_ex,
             output logic main_mem_write_dar_ex );

   logic [15:0] ALUsrcA, ALUsrcB;
   
   mux4 mux_ALUsrcA( rd2_ex, pcinc_ex, 16'b0, 16'b0, ALUsrcA_controll_ex, ALUsrcA );
   mux4 mux_ALUsrcB( rd1_ex, d_ex, extended_d_ex, in_dat, ALUsrcB_controll_ex, ALUsrcB );
   ALU alu( ALUop, ALUsrcA, ALUsrcB, ALUres_ex, S_ex, Z_ex, C_ex, V_ex );
   assign main_mem_read_adr_ex = ALUres_ex;
   assign main_mem_write_adr_ex = ALUres_ex;
   assign main_mem_write_dat_ex = rd1_ex;
   
endmodule
