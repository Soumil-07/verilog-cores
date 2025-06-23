// TODO: this is currently hardcoded to 4 bits, parameterize it
module adder_cla #(parameter N = 8) (
   input wire [3:0] x, y,
   input wire cin,
   output wire [4:0] out
);

wire [3:0] p, g;
wire [4:0] c;

assign p = x ^ y;
assign g = x & y;

assign c[0] = cin;
assign c[1] = g[0] | (p[0] & cin);
assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);

genvar k;
generate
    for (k = 0; k < 4; k = k + 1) begin
        assign out[k] = p[k] ^ c[k];
    end
endgenerate

assign out[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

endmodule
