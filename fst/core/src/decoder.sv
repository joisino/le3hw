module decoder( input logic [3:0] in,
		output logic [7:0] out );

   always_comb begin
      case(in)
	0: out = 8'b11111100;
	1: out = 8'b01100000;
	2: out = 8'b11011010;
	3: out = 8'b11110010;
	4: out = 8'b01100110;
	5: out = 8'b10110110;
	6: out = 8'b10111110;
	7: out = 8'b11100000;
	8: out = 8'b11111110;
	9: out = 8'b11110110;
	10: out = 8'b11101110;
	11: out = 8'b00111110;
	12: out = 8'b00011010;
	13: out = 8'b01111010;
	14: out = 8'b10011110;
	15: out = 8'b10001110;
      endcase // case (in)
   end
endmodule
