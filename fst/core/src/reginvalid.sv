module reginvalid( input logic clk, reset,
                   input logic        regwrite_cur,
                   input logic        from_main_mem, 
                   input logic [2:0]  regwrite_adr_id, 
                   output logic [2:0] register_invalid [7:0] );
   
   logic [1:0] nex[7:0];
   
   reginvalidcnt ca( clk, reset, nex[0], register_invalid[0], register_invalid[0] );
   reginvalidcnt cb( clk, reset, nex[1], register_invalid[1], register_invalid[1] );
   reginvalidcnt cc( clk, reset, nex[2], register_invalid[2], register_invalid[2] );
   reginvalidcnt cd( clk, reset, nex[3], register_invalid[3], register_invalid[3] );
   reginvalidcnt ce( clk, reset, nex[4], register_invalid[4], register_invalid[4] );
   reginvalidcnt cf( clk, reset, nex[5], register_invalid[5], register_invalid[5] );
   reginvalidcnt cg( clk, reset, nex[6], register_invalid[6], register_invalid[6] );
   reginvalidcnt ch( clk, reset, nex[7], register_invalid[7], register_invalid[7] );
   
   always_comb begin
      nex[0] <= 0;
      nex[1] <= 0;
      nex[2] <= 0;
      nex[3] <= 0;
      nex[4] <= 0;
      nex[5] <= 0;
      nex[6] <= 0;
      nex[7] <= 0;
      if( regwrite_cur ) begin
         if( from_main_mem ) nex[regwrite_adr_id] <= 1;
         else nex[regwrite_adr_id] <= 2;
      end
   end

endmodule
