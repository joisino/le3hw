module core( input logic         clk,
            input logic         reset,

            input logic [15:0]  in_dat,
            output logic        out_en,
            output logic [15:0] out_dat,
            output logic        is_halt,

            output logic [15:0] pc,
            input logic [15:0]  inst,

            output logic [15:0] main_mem_read_adr,
            input logic [15:0]  main_mem_dat,
            output logic        main_mem_write,
            output logic [15:0] main_mem_write_adr,
            output logic [15:0] main_mem_write_dat );

   logic 	jump;
   logic [15:0] nextpc, pcinc;
   logic        regwrite, regwrite_adr_controll;
   logic [2:0]  register_write_adr;
   logic [15:0] regwrite_data;
   logic [15:0] rd1, rd2;
   logic [15:0] d, extended_d;
   logic [15:0] ALUsrcA, ALUsrcB, ALUres;
   logic [3:0]  ALUop;
   logic [1:0]  ALUsrcA_controll, ALUsrcB_controll;
   logic [1:0]  regwrite_controll;
   logic        SZCV_controll;
   logic        S, Z, C, V;
   logic        next_S, next_Z, next_C, next_V;
   
   flopr pc_flopr( clk, reset, 1'b1, nextpc, pc );
   assign pcinc = pc + 1;
   mux mux_pc( pcinc, ALUres, jump, nextpc );
   controller core_controller( .* );
   mux #(3) mux_regwrite_adr( inst[10:8], inst[13:11], regwrite_adr_controll, register_write_adr );
   regfile register_file( clk, reset, regwrite, inst[13:11], inst[10:8], register_write_adr, regwrite_data, rd1, rd2 );
   assign out_dat = rd1;
   signext sign_extend( inst[7:0], extended_d );
   assign d = inst[3:0];
   mux4 mux_ALUsrcA( rd2, pcinc, 16'b0, 16'b0, ALUsrcA_controll, ALUsrcA );
   mux4 mux_ALUsrcB( rd1, d, extended_d, in_dat, ALUsrcB_controll, ALUsrcB );
   ALU alu( ALUop, ALUsrcA, ALUsrcB, ALUres, next_S, next_Z, next_C, next_V );
   flopr #(1) S_flopr( clk, reset, SZCV_controll, next_S, S );
   flopr #(1) Z_flopr( clk, reset, SZCV_controll, next_Z, Z );
   flopr #(1) C_flopr( clk, reset, SZCV_controll, next_C, C );
   flopr #(1) V_flopr( clk, reset, SZCV_controll, next_V, V );
   assign main_mem_read_adr = ALUres;
   assign main_mem_write_adr = ALUres;
   assign main_mem_write_dat = rd1;
   mux4 mux_regwrite( ALUres, rd1, main_mem_dat, extended_d, regwrite_controll, regwrite_data );
   
endmodule
   
