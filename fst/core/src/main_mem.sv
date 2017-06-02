`include "timer_count.sv"

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
     input logic [3:0]    lock_adr [C-1:0],
     input logic [C-1:0]  lock_en,
     input logic [C-1:0]  unlock_en,
     output logic [15:0]  main_mem_dat,
     output logic [C-1:0] main_mem_ac,
     output logic [C-1:0] lock_ac );

   logic [15:0] read_adr, write_adr;
   logic [15:0] write_dat;
   logic iswrite;
   logic [15:0] mutex;

   logic [15:0] main_mem_out;

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

   logic use_timer;
   logic [15:0] timer_out;

   pri pri_write_request( main_mem_write_request, cnt, main_mem_write_request_q, main_mem_write_request_en );
   pri pri_read_request( main_mem_read_request, cnt, main_mem_read_request_q, main_mem_read_request_en );

   pri pri_write( main_mem_write, cnt, main_mem_write_q, iswrite );
   pri pri_read( main_mem_read, cnt, main_mem_read_q, main_mem_read_en );

   pri pri_lock( lock_en_can, cnt, enlock_q, enlock_do );
   pri pri_unlock( unlock_en, cnt, unlock_q, unlock_do );

   always_comb begin
      main_mem_write_ac <= 0;
      if( main_mem_write_request_en ) begin
         main_mem_write_ac <= 8'b0000_0001 << main_mem_write_request_q;
      end
   end

   always_comb begin
      main_mem_read_ac <= 0;
      if( main_mem_read_request_en ) begin
         main_mem_read_ac <= 8'b0000_0001 << main_mem_read_request_q;
      end
   end

   assign main_mem_ac = main_mem_write_ac | main_mem_read_ac;
   
   always_comb begin
      write_adr <= main_mem_write_adr[ main_mem_write_q ];
      write_dat <= main_mem_write_dat[ main_mem_write_q ];
   end

   always_comb begin
      read_adr <= main_mem_read_adr[ main_mem_read_q ];
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
         cnt <= cnt + 3'b1;
      end
   end

   timer_count tim( .* );

   always_ff @( posedge clk ) begin
      if( read_adr == 16'b1000_0000_0000_0000 ) begin
         use_timer <= 1;
      end else begin
         use_timer <= 0;
      end
   end

   always_comb begin
      if( use_timer ) begin
         main_mem_dat <= timer_out;
      end else begin
         main_mem_dat <= main_mem_out;
      end
   end

   dmemd dmemd( clk, write_dat, read_adr, write_adr, iswrite, main_mem_out );

   logic dmemr_write;
   logic [15:0] dmemr_dat;
   assign dmemr_write = iswrite & (write_adr < 2048);
   
   dmemr dmemr( write_adr, clk, write_dat, dmemr_write, dmemr_dat );
   
endmodule
