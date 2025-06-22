module arbiter_rr_tb;

reg clk, rst;
reg [3:0] req;
wire [3:0] grant;

// arbiter_rr_mux dut (.*);
arbiter_rr_muxlog dut (.*);

initial begin
    $dumpfile("rr_arbiter.vcd");
    $dumpvars;
end

initial clk = 0;

always #5 clk = ~clk;

initial begin
    // 1) start with reset asserted and req idle
    rst = 1;
    req = 4'b0000;
    // 2) wait two clock edges to be sure DUT sees rst=1 at a rising edge
    @(posedge clk);
    @(posedge clk);

    // 3) deassert reset synchronously
    rst = 0;
    @(posedge clk);

    // 4) apply first vector
    req = 4'b1001;
    @(posedge clk);

    // 5) apply second vector and check
    req = 4'b1111;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    #1 $finish;
end

initial begin
    $monitor("req = %4b grant = %4b", req, grant);
end

endmodule
