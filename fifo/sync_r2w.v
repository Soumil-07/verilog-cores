module sync_r2w #(parameter ASIZE = 4) (
    input wire              wclk,
                            wrst_n,
    input wire [ASIZE:0]    rptr,
    output wire [ASIZE:0]   ws_rptr
);

reg [ASIZE:0] rptr_q1, rptr_q2;

always @(posedge wclk, negedge wrst_n)
    if (!wrst_n)    {rptr_q1, rptr_q2} <= 0;
    else            {rptr_q1, rptr_q2} <= {rptr, rptr_q1};

assign ws_rptr = rptr_q2;

endmodule
