module main_mem
  #( parameter C = 2 )
   ( input logic clk, reset,
     input logic [15:0]   main_mem_read_adr [C-1:0],
     input logic [15:0]   main_mem_write_adr [C-1:0],
     input logic [15:0]   main_mem_write_dat [C-1:0],
     input logic [C-1:0]  main_mem_write,
     input logic [C-1:0]  main_mem_read,
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
      adr <= 0;
      iswrite <= 0;
      main_mem_ac <= 0;      
      if( main_mem_write[0] ) begin
         adr <= main_mem_write_adr[0];
         write_dat <= main_mem_write_dat[0];
         iswrite <= 1;
         main_mem_ac <= 2'b01;
      end else if( main_mem_write[1] ) begin
         adr <= main_mem_write_adr[1];
         write_dat <= main_mem_write_dat[1];
         iswrite <= 1;
         main_mem_ac <= 2'b10;
      end else if( main_mem_read[0] ) begin
         adr <= main_mem_write_adr[0];
         main_mem_ac <= 2'b01;
      end else if( main_mem_read[1] ) begin
         adr <= main_mem_write_adr[1];
         main_mem_ac <= 2'b10;
      end
   end


   always_comb begin
      lock_ac <= 0;      
      if( unlock_en[0] ) begin
         lock_ac <= 2'b01;
      end else if( unlock_en[1] ) begin
         lock_ac <= 2'b10;
      end else if( lock_en[0] & (!mutex[lock_adr[0]]) ) begin
         lock_ac <= 2'b01;
      end else if( lock_en[1] & (!mutex[lock_adr[1]]) ) begin
         lock_ac <= 2'b10;
      end
   end

   always_ff @( posedge clk ) begin
      if( reset ) begin
         mutex <= 0;
      end else if( unlock_en[0] ) begin
         mutex[ lock_adr[0] ] <= 0;
      end else if( unlock_en[1] ) begin
         mutex[ lock_adr[1] ] <= 0;
      end else if( lock_en[0] & (!mutex[lock_adr[0]]) ) begin
         mutex[ lock_adr[0] ] <= 1;
      end else if( lock_en[1] & (!mutex[lock_adr[1]]) ) begin
         mutex[ lock_adr[1] ] <= 1;
      end
   end
   
   dmem dmem( adr, clk, write_dat, iswrite, main_mem_dat );
   
endmodule
