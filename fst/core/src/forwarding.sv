`ifndef DEFINE_FORWARDING
`define DEFINE_FORWARDING


module forwarding( input logic [1:0]  ALUsrcA_controll_id, ALUsrcB_controll_id,
                   input logic [2:0]  register_invalid [7:0],
                   input logic [2:0]  ra, rb,
                   output logic [1:0] forwardingA_controll_id, forwardingB_controll_id,
                   output logic [1:0] forwarding_ra_controll_id,
                   output logic [1:0] forwarding_rb_controll_id,
                   output logic       forwarding_lock_controll );

   always_comb begin
      forwardingA_controll_id <= 0;
      forwardingB_controll_id <= 0;
      forwarding_ra_controll_id <= 0;
      forwarding_rb_controll_id <= 0;
      
      if( ALUsrcA_controll_id == 0 )
        case( register_invalid[rb] )
          2: forwardingA_controll_id <= 1;
          3: forwardingA_controll_id <= 2;
          default: forwardingA_controll_id <= 0;
        endcase
      
      if( ALUsrcB_controll_id == 0 )
        case( register_invalid[ra] )
          2: forwardingB_controll_id <= 1;
          3: forwardingB_controll_id <= 2;
          default: forwardingB_controll_id <= 0;
        endcase

      case( register_invalid[ra] )
        2: forwarding_ra_controll_id <= 1;
        3: forwarding_ra_controll_id <= 2;
        default: forwarding_ra_controll_id <= 0;
      endcase

      case( register_invalid[rb] )
        2: forwarding_rb_controll_id <= 1;
        3: forwarding_rb_controll_id <= 2;
        default: forwarding_rb_controll_id <= 0;
      endcase
      
      forwarding_lock_controll <= register_invalid[rb] == 3;
   end
   
endmodule

`endif
