module jumpstate( input logic        clk, reset,
                  input logic        flush_decode,
                  input logic        memory_waiting,       
                  input logic [2:0]  jump_inst,
                  input logic        S_wb, Z_wb, C_wb, V_wb,
                  input logic        jump_pred_busy,
                  output logic [2:0] jump_state,
                  output logic       jump );

   logic [5:0] state;

   always_comb begin
      case( jump_state )
        1: // B
          jump <= 1;
        2: // BE
          jump <= Z_wb;
        3: // BLT
          jump <= S_wb ^ V_wb;
        4: // BLE
          jump <= Z_wb | ( S_wb ^ V_wb );
        5: // BNE
          jump <= !Z_wb;
	default:
	  jump <= 0;
      endcase
   end
               
   always_ff @(posedge clk) begin
      if( reset | flush_decode )
        state <= 0;
      else begin
         if( memory_waiting )
           state <= state;
         else if( jump_pred_busy )
           state <= { state[2:0], 3'b0 };
         else 
           state <= { state[2:0], jump_inst };
      end
   end

   assign jump_state = state[5:3];
endmodule
