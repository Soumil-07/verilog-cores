module arbiter_fixed_tb();

localparam N = 8;
integer NUM_TESTS = 25;
integer i;

reg [N-1:0] req;
wire [N-1:0] grant;

arbiter_fixed #(.N(N)) dut (
    .req(req),
    .grant(grant)
);

initial begin
    for (i = 0; i < NUM_TESTS; i += 1) begin
        req = $random;
        #10;
    end

    #10;
end

initial begin
    $dumpfile("arbiter_fixed_dump.vcd");
    $dumpvars;
end

endmodule
