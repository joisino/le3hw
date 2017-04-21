module writeback( input logic [15:0]  regwrite_dat_wb,
                  input logic [15:0]  main_mem_dat_wb,
                  input logic         from_main_mem,
                  output logic [15:0] regwrite_dat );

   // mux4 mux_regwrite( ALUres_wb, rd1_wb, main_mem_dat_wb, extended_d_wb, regwrite_dat_controll, regwrite_dat );
   mux mux_regwrite( regwrite_dat_wb, main_mem_dat_wb, from_main_mem, regwrite_dat );
   
endmodule
