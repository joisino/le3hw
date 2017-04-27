module main_mem
  #( parameter C = 8 )
   ( input logic clk, reset,
     input logic [15:0]   main_mem_read_adr [C-1:0],
     input logic [15:0]   main_mem_write_adr [C-1:0],
     input logic [15:0]   main_mem_write_dat [C-1:0],
     input logic [C-1:0]  main_mem_write,
     input logic [C-1:0]  main_mem_read,
     input logic [C-1:0]  main_mem_write_request,
     input logic [C-1:0]  main_mem_read_request,
     input logic [9:0]    lock_adr [C-1:0],
     input logic [C-1:0]  lock_en,
     input logic [C-1:0]  unlock_en,
     output logic [15:0]  main_mem_dat,
     output logic [C-1:0] main_mem_ac,
     output logic [C-1:0] lock_ac );

   logic [15:0] adr;
   logic [15:0] write_dat;
   logic iswrite;
   logic [1023:0] mutex;

   always_comb begin
      main_mem_ac <= 0;
      if( main_mem_write_request[0] ) begin
         main_mem_ac <= 8'b00000001;
      end else if( main_mem_write_request[1] ) begin
         main_mem_ac <= 8'b00000010;
      end else if( main_mem_write_request[2] ) begin
         main_mem_ac <= 8'b00000100;
      end else if( main_mem_write_request[3] ) begin
         main_mem_ac <= 8'b00001000;
      end else if( main_mem_write_request[4] ) begin
         main_mem_ac <= 8'b00010000;
      end else if( main_mem_write_request[5] ) begin
         main_mem_ac <= 8'b00100000;
      end else if( main_mem_write_request[6] ) begin
         main_mem_ac <= 8'b01000000;
      end else if( main_mem_write_request[7] ) begin
         main_mem_ac <= 8'b10000000;
      end else if( main_mem_read_request[0] ) begin
         main_mem_ac <= 8'b00000001;
      end else if( main_mem_read_request[1] ) begin
         main_mem_ac <= 8'b00000010;
      end else if( main_mem_read_request[2] ) begin
         main_mem_ac <= 8'b00000100;
      end else if( main_mem_read_request[3] ) begin
         main_mem_ac <= 8'b00001000;
      end else if( main_mem_read_request[4] ) begin
         main_mem_ac <= 8'b00010000;
      end else if( main_mem_read_request[5] ) begin
         main_mem_ac <= 8'b00100000;
      end else if( main_mem_read_request[6] ) begin
         main_mem_ac <= 8'b01000000;
      end else if( main_mem_read_request[7] ) begin
         main_mem_ac <= 8'b10000000;
      end
   end

   always_comb begin
      adr <= 0;
      write_dat <= 0;
      iswrite <= 0;
      if( main_mem_write[0] ) begin
         adr <= main_mem_write_adr[0];
         write_dat <= main_mem_write_dat[0];
         iswrite <= 1;
      end else if( main_mem_write[1] ) begin
         adr <= main_mem_write_adr[1];
         write_dat <= main_mem_write_dat[1];
         iswrite <= 1;
      end else if( main_mem_write[2] ) begin
         adr <= main_mem_write_adr[2];
         write_dat <= main_mem_write_dat[2];
         iswrite <= 1;
      end else if( main_mem_write[3] ) begin
         adr <= main_mem_write_adr[3];
         write_dat <= main_mem_write_dat[3];
         iswrite <= 1;
      end else if( main_mem_write[4] ) begin
         adr <= main_mem_write_adr[4];
         write_dat <= main_mem_write_dat[4];
         iswrite <= 1;
      end else if( main_mem_write[5] ) begin
         adr <= main_mem_write_adr[5];
         write_dat <= main_mem_write_dat[5];
         iswrite <= 1;
      end else if( main_mem_write[6] ) begin
         adr <= main_mem_write_adr[6];
         write_dat <= main_mem_write_dat[6];
         iswrite <= 1;
      end else if( main_mem_write[7] ) begin
         adr <= main_mem_write_adr[7];
         write_dat <= main_mem_write_dat[7];
         iswrite <= 1;
      end else if( main_mem_read[0] ) begin
         adr <= main_mem_write_adr[0];
      end else if( main_mem_read[1] ) begin
         adr <= main_mem_write_adr[1];
      end else if( main_mem_read[2] ) begin
         adr <= main_mem_write_adr[2];
      end else if( main_mem_read[3] ) begin
         adr <= main_mem_write_adr[3];
      end else if( main_mem_read[4] ) begin
         adr <= main_mem_write_adr[4];
      end else if( main_mem_read[5] ) begin
         adr <= main_mem_write_adr[5];
      end else if( main_mem_read[6] ) begin
         adr <= main_mem_write_adr[6];
      end else if( main_mem_read[7] ) begin
         adr <= main_mem_write_adr[7];
      end
   end

   always_comb begin
      lock_ac <= 0;      
      if( unlock_en[0] ) begin
         lock_ac <= 8'b00000001;
      end else if( unlock_en[1] ) begin
         lock_ac <= 8'b00000010;
      end else if( unlock_en[2] ) begin
         lock_ac <= 8'b00000100;
      end else if( unlock_en[3] ) begin
         lock_ac <= 8'b00001000;
      end else if( unlock_en[4] ) begin
         lock_ac <= 8'b00010000;
      end else if( unlock_en[5] ) begin
         lock_ac <= 8'b00100000;
      end else if( unlock_en[6] ) begin
         lock_ac <= 8'b01000000;
      end else if( unlock_en[7] ) begin
         lock_ac <= 8'b10000000;
      end else if( lock_en[0] & (!mutex[lock_adr[0]]) ) begin
         lock_ac <= 8'b00000001;
      end else if( lock_en[1] & (!mutex[lock_adr[1]]) ) begin
         lock_ac <= 8'b00000010;
      end else if( lock_en[2] & (!mutex[lock_adr[2]]) ) begin
         lock_ac <= 8'b00000100;
      end else if( lock_en[3] & (!mutex[lock_adr[3]]) ) begin
         lock_ac <= 8'b00001000;
      end else if( lock_en[4] & (!mutex[lock_adr[4]]) ) begin
         lock_ac <= 8'b00010000;
      end else if( lock_en[5] & (!mutex[lock_adr[5]]) ) begin
         lock_ac <= 8'b00100000;
      end else if( lock_en[6] & (!mutex[lock_adr[6]]) ) begin
         lock_ac <= 8'b01000000;
      end else if( lock_en[7] & (!mutex[lock_adr[7]]) ) begin
         lock_ac <= 8'b10000000;
      end
   end

   always_ff @( posedge clk ) begin
      if( reset ) begin
         mutex <= 0;
      end else if( unlock_en[0] ) begin
         mutex[ lock_adr[0] ] <= 0;
      end else if( unlock_en[1] ) begin
         mutex[ lock_adr[1] ] <= 0;
      end else if( unlock_en[2] ) begin
         mutex[ lock_adr[2] ] <= 0;
      end else if( unlock_en[3] ) begin
         mutex[ lock_adr[3] ] <= 0;
      end else if( unlock_en[4] ) begin
         mutex[ lock_adr[4] ] <= 0;
      end else if( unlock_en[5] ) begin
         mutex[ lock_adr[5] ] <= 0;
      end else if( unlock_en[6] ) begin
         mutex[ lock_adr[6] ] <= 0;
      end else if( unlock_en[7] ) begin
         mutex[ lock_adr[7] ] <= 0;
      end else if( lock_en[0] & (!mutex[lock_adr[0]]) ) begin
         mutex[ lock_adr[0] ] <= 1;
      end else if( lock_en[1] & (!mutex[lock_adr[1]]) ) begin
         mutex[ lock_adr[1] ] <= 1;
      end else if( lock_en[2] & (!mutex[lock_adr[2]]) ) begin
         mutex[ lock_adr[2] ] <= 1;
      end else if( lock_en[3] & (!mutex[lock_adr[3]]) ) begin
         mutex[ lock_adr[3] ] <= 1;
      end else if( lock_en[4] & (!mutex[lock_adr[4]]) ) begin
         mutex[ lock_adr[4] ] <= 1;
      end else if( lock_en[5] & (!mutex[lock_adr[5]]) ) begin
         mutex[ lock_adr[5] ] <= 1;
      end else if( lock_en[6] & (!mutex[lock_adr[6]]) ) begin
         mutex[ lock_adr[6] ] <= 1;
      end else if( lock_en[7] & (!mutex[lock_adr[7]]) ) begin
         mutex[ lock_adr[7] ] <= 1;
      end
   end
   
   dmem dmem( adr, clk, write_dat, iswrite, main_mem_dat );
   
endmodule
