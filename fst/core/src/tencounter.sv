module tenc( input logic clk,
	     input logic reset_n,
             input logic stp,
	     input logic        ad,
	     input logic [3:0]  cur,
	     output logic [3:0] nex,
	     output logic       carry );

   always_ff @(posedge clk) begin
      if( !reset_n ) begin
	 nex <= 0;
      end else if( ad & (!stp) ) begin
	 if( cur < 9 ) begin
	    nex <= cur + 1;
	 end else begin
	    nex <= 0;
	 end
      end else begin
	 nex <= cur;
      end
   end // always_ff @

   always_comb begin
      if( cur == 9 & ad )
        carry <= 1;
      else
        carry <= 0;
   end
   
endmodule
