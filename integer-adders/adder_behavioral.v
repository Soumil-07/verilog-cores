module adder_behavioral #(parameter N = 8) (
   input wire [N-1:0] x, y,
   input wire cin,
   output wire [N:0] out
);

assign out = x + y + cin;

endmodule
