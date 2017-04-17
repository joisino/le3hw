module writeback( input logic [15:0] ALUres_wb,
                  input logic [15:0] rd1_wb,
                  input logic [15:0] main_mem_dat_wb,
                  input logic [15:0] extended_d_wb,
                  input logic regwrite_dat_controll,
                  output logic [15:0] regwrite_data );

   mux4 mux_regwrite( ALUres_wb, rd1_wb, main_mem_dat_wb, extended_d_wb, regwrite_dat_controll, regwrite_data );
   
endmodule
