module fifo_top #(parameter WSIZE = 8, ASIZE = 4) (
    // read clock signals
    input wire              rclk,
                            rrst_n,
                            rinc,   // signal that the data can be consumed and rdptr can increment
                                    // data is always available, so not called ren
    output wire [WSIZE-1:0] rdata,
    output wire             rempty,

    // write clock signals
    input wire              wclk,
                            wrst_n,
    input wire [WSIZE-1:0]  wdata,
    input wire              winc,
    output wire             wfull
);

wire [ASIZE:0]      rptr, wptr, ws_rptr, rs_wptr;
wire [ASIZE-1:0]    raddr, waddr;

sync_r2w sync_r2w (
    .wclk,
    .rptr,
    .ws_rptr
);

sync_w2r sync_w2r (
    .rclk,
    .wptr,
    .rs_wptr
);

fifo_mem #(ASIZE, WSIZE) fifo_mem (
    .raddr,
    .waddr,
    .wdata,
    .wen (winc && !wfull),
    .wclk,
    .rdata
);

rptr_empty #(ASIZE) rptr_empty (
    .rs_wptr,
    .rclk,
    .rinc,
    .rrst_n,
    .raddr,
    .rptr,
    .rempty
);

wptr_full #(ASIZE) wptr_full (
    .ws_rptr,
    .wclk,
    .winc,
    .wrst_n,
    .waddr,
    .wptr,
    .wfull
);

endmodule
