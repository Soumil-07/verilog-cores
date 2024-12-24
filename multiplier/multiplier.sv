module multiplier #(parameter WIDTH=8) (
  input logic clk, rst, start,
  input logic [WIDTH-1:0] a, b,
  output logic [WIDTH*2-1:0] y,
  output logic valid
);
  
  logic [WIDTH*2-1:0] partial_products [WIDTH];
  logic [WIDTH*2-1:0] sum;
  logic [$clog2(WIDTH):0] i;
  
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      sum <= '0;
      i <= '0;
      valid <= 1'b0;
    end else if (start) begin
      sum <= '0;
      i <= '0;
      valid <= 1'b0;
    end else if (i < WIDTH) begin
      partial_products[i] <= b[i] ? (a << i) : '0;
      if (i > 0) sum <= sum + partial_products[i-1];
      i <= i + 1;
    end else if (i == WIDTH) begin
      sum <= sum + partial_products[WIDTH-1];
      valid <= 1'b1;
      i <= i + 1;
    end
  end
  
  assign y = sum;
  
endmodule
