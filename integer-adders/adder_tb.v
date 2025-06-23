//`define ADDER_MODULE adder_behavioral

module adder_tb();

localparam N = 4;

reg [N-1:0] x, y;
reg cin;
wire [N:0] out;

integer i;
integer NUM_TESTS = 25;
integer failures = 0;

`ADDER_MODULE #(.N(N)) dut (.*);

function [N:0] golden (input [N-1:0] a, b, input c);
    golden = a + b + c;
endfunction

initial begin
    for (i = 0; i < NUM_TESTS; i++) begin
        cin = $random;
        x = $random;
        y = $random;
        #1

        if (out != golden(x, y, cin)) begin
            failures++;
            $display("FAIL: x=%d y=%d cin=%b out=%d golden=%d", x, y, cin, out, golden(x, y, cin));
        end
        #5;
    end

    if (failures == 0)
        $display("ALL TESTS PASSED!");
end

initial begin
    $dumpfile("adder_tb.vcd");
    $dumpvars;
end

endmodule
