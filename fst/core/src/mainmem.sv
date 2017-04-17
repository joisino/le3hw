module mainmem( input logic [15:0] ALUres_mem,
                input logic [15:0]  rd1_mem,
                output logic [15:0] main_mem_read_adr,
                output logic [15:0] main_mem_write_adr,
                output logic [15:0] main_mem_write_dat );

   assign main_mem_read_adr = ALUres_mem;
   assign main_mem_write_adr = ALUres_mem;
   assign main_mem_write_dat = rd1_mem;

endmodule
