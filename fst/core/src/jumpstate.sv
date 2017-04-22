module jumpstate( input logic clk, reset,
                  input logic [2:0]  jump_inst,
                  input logic jump_pred_busy,
                  output logic [2:0] jump_state );

   logic [5:0] state;
               
   always_ff @(posedge clk) begin
      if( reset )
        state <= 0;
      else begin
         if( jump_pred_busy )
           state <= { state[2:0], 3'b0 };
         else 
           state <= { state[2:0], jump_inst };
      end
   end

   assign jump_state = state[5:3];
endmodule
