module arbiter_rr_muxlog (
    input wire  clk,
                rst,
    input wire [3:0] req,
    output wire [3:0] grant
);

reg [1:0] ptr, ptr_next;
reg [3:0] mask;

wire [3:0] gnt_masked, gnt_unmasked;

arbiter_fixed arb_masked (.req(mask & req), .grant(gnt_masked));
arbiter_fixed arb_unmasked (.req(req), .grant(gnt_unmasked));

always @ (posedge clk) begin
    if (rst)
        ptr <= 2'b00;
    else
        ptr <= ptr_next;
end

always @ (*) begin
    case (ptr)
        2'b00: mask = 4'b1111;
        2'b01: mask = 4'b1110;
        2'b10: mask = 4'b1100;
        2'b11: mask = 4'b1000;
        default: mask = 4'bxxxx;
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

assign grant = ((mask & req) == 4'b000) ? gnt_unmasked : gnt_masked;

endmodule
