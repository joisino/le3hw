module reginvalid( input logic        clk, reset,
                   input logic        flush_decode,
                   input logic        regwrite_cur,
                   input logic        from_main_mem_id, 
                   input logic [2:0]  regwrite_adr_id, 
                   output logic [2:0] register_invalid [7:0] );
   
   logic [1:0] nex[7:0];

   for( genvar i = 0; i < 8; i++ ) begin : generate_reginvalid_cnt
      reginvalidcnt reginvalidcnt( .nex(nex[i]),
                                   .d(register_invalid[i]),
                                   .q(register_invalid[i]),
                                   .* );
   end
   
   always_comb begin
      for( integer i = 0; i < 8; i++ ) begin : nex_init
         nex[i] <= 0;
      end
      if( regwrite_cur ) begin
         if( from_main_mem_id ) nex[regwrite_adr_id] <= 1;
         else nex[regwrite_adr_id] <= 2;
      end
   end

endmodule
