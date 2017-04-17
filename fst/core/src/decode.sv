module decode( input logic clk, reset,
               input logic [15:0]  inst_id,
               input logic [15:0]  pcinc_id,
               input logic regwrite,
               output logic [15:0] rd1_id , rd2_id,
               output logic [3:0]  d_id,
               output logic [15:0] extended_d_id,
               output logic [2:0]  regwrite_adr_id,
               output logic [1:0]  ALUsrcA_controll_id, ALUsrcB_controll_id,
               output logic [3:0]  ALUop_id,
               output logic [15:0] out_dat,
               output logic out_en,
               output logic is_halt,
               output logic main_mem_write_id,
               output logic regwrite_dat_controll_id ,
               output logic regwrite_id );

   logic regwrite_adr_controll;
   
   controller core_controller( .* );
   mux #(3) mux_regwrite_adr( inst_id[10:8], inst_id[13:11], regwrite_adr_controll, regwrite_adr_id );
   regfile register_file( clk, reset, regwrite, inst_id[13:11], inst_id[10:8], regwrite_adr, regwrite_data, rd1, rd2 );
   assign out_dat = rd1;
   signext sign_extend( inst_id[7:0], extended_d );
   assign d = inst_id[3:0];
endmodule
