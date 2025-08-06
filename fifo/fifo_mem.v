module fifo_mem #(parameter ASIZE = 4, WSIZE = 8) (
    input wire [ASIZE-1:0]  raddr,
                            waddr,
    input wire [WSIZE-1:0]  wdata,
    input wire              wen,
                            wclk,
    output wire [WSIZE-1:0] rdata
);

localparam DEPTH = (1 << ASIZE);

reg [WSIZE-1:0] mem [0:DEPTH-1];

assign rdata = mem[raddr];

always @(posedge wclk)
    if (wclk && wen) mem[waddr] <= wdata;

endmodule
