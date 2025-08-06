module sync_w2r #(parameter ASIZE = 4) (
    input wire              rclk,
                            rrstn_n,
    input wire [ASIZE:0]    wptr,
    output wire [ASIZE:0]   rs_wptr
);

reg [ASIZE:0] wptr_q1, wptr_q2;

always @(posedge rclk, negedge rrstn_n)
    if (!rrstn_n)   {wptr_q1, wptr_q2} <= 0;
    else            {wptr_q1, wptr_q2} <= {wptr, wptr_q1};

assign rs_wptr = wptr_q2;

endmodule
