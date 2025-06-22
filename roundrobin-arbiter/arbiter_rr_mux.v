// for 4 requests, we instantiate 4 
module arbiter_rr_mux (
    input wire  clk,
                rst,
    input wire [3:0]    req,
    output reg [3:0]   grant
);

wire [3:0] req0, req1, req2, req3;
wire [3:0] gnt0, gnt1, gnt2, gnt3;

reg [1:0] ptr, ptr_next;

assign req0 = req;
assign req1 = {req[0], req[3:1]};
assign req2 = {req[1:0], req[3:2]};
assign req3 = {req[2:0], req[3]};

arbiter_fixed arb0 (.req(req0), .grant(gnt0));
arbiter_fixed arb1 (.req(req1), .grant(gnt1));
arbiter_fixed arb2 (.req(req2), .grant(gnt2));
arbiter_fixed arb3 (.req(req3), .grant(gnt3));

always @ (posedge clk) begin
    if (rst)
        ptr <= 2'b00;
    else
        ptr <= ptr_next;
end

always @ (*) begin
    case (ptr)
        2'b00: grant = gnt0;
        // rotate left again
        2'b01: grant = {gnt1[2:0], gnt1[3]};
        2'b10: grant = {gnt2[1:0], gnt2[3], gnt2[2]};
        2'b11: grant = {gnt3[0], gnt3[3:1]};
        default: grant = 4'b0000;
    endcase
end

always @ (*) begin
    ptr_next = ptr;
    case (grant)
        4'b0001: ptr_next = 2'b01;
        4'b0010: ptr_next = 2'b10;
        4'b0100: ptr_next = 2'b11;
        4'b1000: ptr_next = 2'b00;
    endcase
end


endmodule
