module timer_count( input logic clk, reset,
                    output logic [15:0] timer_out );

   logic [15:0] count;

   always_ff @( posedge clk ) begin
      if( reset ) begin
         count <= 0;
         timer_out <= 0;
      end else begin
         if( count == 49999 ) begin
            count <= 0;
            timer_out <= timer_out + 16'b1;
         end else begin
            count <= count + 16'b1;
         end
      end
   end

endmodule
