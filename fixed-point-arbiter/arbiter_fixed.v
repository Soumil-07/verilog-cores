// In a 4-bit fixed priority arbiter, 4 blocks try to access a shared bus (req)
// the arbiter decides which block receives access (grant)
module arbiter_fixed #(parameter N = 4) (
    input wire [N-1:0] req,
    output wire [N-1:0] grant
);

// mask[N-1] = mask[2] | req[2]
wire [N-1:0] mask;

assign mask[N-1:1] = mask[N-2:0] | req[N-2:0];
assign mask[0] = 1'b0;
assign grant = req & ~mask;

endmodule
