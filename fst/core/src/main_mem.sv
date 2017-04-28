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

   logic [15:0] read_adr, write_adr;
   logic [15:0] write_dat;
   logic iswrite;
   logic [1023:0] mutex;

   logic [2:0] main_mem_write_request_q;
   logic main_mem_write_request_en;
   logic [C-1:0] main_mem_write_ac;
   logic [2:0] main_mem_read_request_q;
   logic main_mem_read_request_en;
   logic [C-1:0] main_mem_read_ac;

   logic [2:0] main_mem_write_q;
   logic [2:0] main_mem_read_q;
   logic main_mem_read_en;
   
   logic [2:0] cnt;

   logic [7:0] enlock_ac;
   logic [7:0] unlock_ac;

   logic [7:0] lock_en_can;
   
   logic [2:0] enlock_q;
   logic [2:0] unlock_q;
   
   logic enlock_do;
   logic unlock_do;

   logic [15:0] adr;

   pri pri_write_request( main_mem_write_request, cnt, main_mem_write_request_q, main_mem_write_request_en );
   pri pri_read_request( main_mem_read_request, cnt, main_mem_read_request_q, main_mem_read_request_en );

   pri pri_write( main_mem_write, cnt, main_mem_write_q, iswrite );
   pri pri_read( main_mem_read, cnt, main_mem_read_q, main_mem_read_en );

   pri pri_lock( lock_en_can, cnt, enlock_q, enlock_do );
   pri pri_unlock( unlock_en, cnt, unlock_q, unlock_do );

   always_comb begin
      main_mem_ac <= 0;
      if( main_mem_write_request_en ) begin
         main_mem_ac <= 8'b0000_0001 << main_mem_write_request_q;
      end else if( main_mem_read_request_en ) begin
	 main_mem_ac <= 8'b0000_0001 << main_mem_read_request_q;
      end
   end

   always_comb begin
      write_adr <= main_mem_write_adr[ main_mem_write_q ];
      write_dat <= main_mem_write_dat[ main_mem_write_q ];
   end

   always_comb begin
      read_adr <= main_mem_read_adr[ main_mem_read_q ];
   end

   always_comb begin
      if( iswrite ) begin
	 adr <= write_adr;
      end else begin
	 adr <= read_adr;
      end
   end

   always_comb begin
      integer i;
      for( i = 0; i < 8; i++ ) begin
	 lock_en_can[i] <= lock_en[i] & (!mutex[lock_adr[i]]);
      end
   end
   
   always_comb begin
      enlock_ac <= 0;
      if( enlock_do ) begin
         enlock_ac <= 8'b0000_0001 << enlock_q;
      end
   end

   always_comb begin
      unlock_ac <= 0;
      if( unlock_do ) begin
         unlock_ac <= 8'b0000_0001 << unlock_q;
      end
   end

   assign lock_ac = enlock_ac | unlock_ac;
   // assign lock_ac = 8'b1111_1111;
   // assign lock_ac = lock_en_can;
   
   always_ff @( negedge clk ) begin
      if( reset ) begin
         mutex <= 0;
      end else begin
         if( enlock_do ) begin
            mutex[ lock_adr[enlock_q] ] <= 1;
         end
         if( unlock_do ) begin
            mutex[ lock_adr[unlock_q] ] <= 0;
         end
      end
   end
   
   always_ff @( negedge clk ) begin
      if( reset ) begin
         cnt <= 0;
      end else if( cnt == 7 ) begin
         cnt <= 0;
      end else begin
         cnt <= cnt + 1;
      end
   end

   
   dmem dmem( adr, clk, write_dat, iswrite, main_mem_dat );
   
endmodule
