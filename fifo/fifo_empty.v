module rptr_empty #(parameter ASIZE = 4) (
    input wire [ASIZE:0]    rs_wptr, // read-synced write ptr,
    input wire              rclk,
                            rinc,
                            rrst_n,
    output wire [ASIZE-1:0] raddr,
    output reg [ASIZE:0]    rptr,
    output reg              rempty
);

reg [ASIZE:0]   rbin;
wire [ASIZE:0]  rbin_next, rgray_next;

always @(posedge rclk, negedge rrst_n)
    if (!rrst_n)    {rbin, rptr} <= 0;
    else            {rbin, rptr} <= {rbin_next, rgray_next};

// this is the address used to index the dual port SRAM
assign raddr = rbin[ASIZE:0];

assign rbin_next = rbin + (rinc & ~rempty);
assign rgray_next = rbin_next ^ (rbin_next >> 1);

assign rempty_q = (rs_wptr == rgray_next);

always @(posedge rclk, negedge rrst_n)
    if (!rrst_n)    rempty <= 1;
    else            rempty <= rempty_q;

endmodule
