module mainmem( input logic [15:0]  ALUres_mem,
                input logic [15:0]  rd1_mem,
                input logic [15:0]  extended_d_mem,
                input logic [1:0]   regwrite_dat_controll_mem,
                output logic [15:0] main_mem_read_adr,
                output logic [15:0] main_mem_write_adr,
                output logic [15:0] main_mem_write_dat,
                output logic [15:0] regwrite_dat_mem );

   assign main_mem_read_adr = ALUres_mem;
   assign main_mem_write_adr = ALUres_mem;
   assign main_mem_write_dat = rd1_mem;

   mux4 mux_regwrite_dat( ALUres_mem, rd1_mem, 16'b0, extended_d_mem, regwrite_dat_controll_mem, regwrite_dat_mem );

endmodule
