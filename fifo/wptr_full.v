module wptr_full #(parameter ASIZE = 4) (
    input wire [ASIZE:0]    ws_rptr, // write-synced read ptr,
    input wire              wclk,
                            winc,
                            wrst_n,
    output wire [ASIZE-1:0] waddr,
    output reg [ASIZE:0]    wptr,
    output reg              wfull
);

reg [ASIZE:0]   wbin;
wire [ASIZE:0]  wbin_next, wgray_next;

always @(posedge wclk, negedge wrst_n)
    if (!wrst_n)    {wbin, wptr} <= 0;
    else            {wbin, wptr} <= {wbin_next, wgray_next};

// this is the address used to index the dual port SRAM
assign waddr = wbin[ASIZE:0];

assign wbin_next = wbin + (winc & ~wfull);
assign wgray_next = wbin_next ^ (wbin_next >> 1);

assign wfull_q = (
    wptr[ASIZE-1] != ws_rptr[ASIZE-1] && wptr[ASIZE-2] != ws_rptr[ASIZE-2] && wptr[ASIZE-3:0] == ws_rptr[ASIZE-3:0]
);

always @(posedge wclk, negedge wrst_n)
    if (!wrst_n)    wfull <= 0;
    else            wfull <= wfull_q;

endmodule
