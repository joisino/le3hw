module reginvalid( input logic clk, reset,
                 input logic        regwrite, 
                 input logic [2:0]  regwrite_adr,
                 input logic        regwrite_cur,
                 input logic [2:0]  regwrite_adr_id, 
                 output logic [7:0] register_invalid );
   
   always_ff @(posedge clk) begin
      if( reset )
        register_invalid <= 0;
      else begin
         if( regwrite )
           register_invalid[regwrite_adr] <= 0;
         else if( regwrite_cur )
           register_invalid[regwrite_adr_id] <= 1;
      end
   end

endmodule
