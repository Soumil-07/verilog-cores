module multiplier_tb;
  parameter WIDTH = 8;
  
  logic clk;
  logic rst;
  logic start;
  logic [WIDTH-1:0] a, b;
  logic [WIDTH*2-1:0] y;
  logic valid;
  
  // Instantiate the multiplier
  multiplier #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .a(a),
    .b(b),
    .y(y),
    .valid(valid)
  );
  
  // Clock generation
  always #5 clk = ~clk;
  
  // Test stimulus
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    start = 0;
    a = 0;
    b = 0;
    
    // Reset the module
    #10 rst = 0;
    
    // Test case 1: 5 * 3
    #10 start = 1;
    a = 5;
    b = 3;
    #10 start = 0;
    
    // Wait for valid signal
    @(posedge valid);
    $display("Test case 1: %d * %d = %d", a, b, y);
    
    // Test case 2: 255 * 255 (max value for 8-bit)
    #20 start = 1;
    a = 255;
    b = 255;
    #10 start = 0;
    
    @(posedge valid);
    $display("Test case 2: %d * %d = %d", a, b, y);
    
    // Test case 3: 0 * 10
    #20 start = 1;
    a = 0;
    b = 10;
    #10 start = 0;
    
    @(posedge valid);
    $display("Test case 3: %d * %d = %d", a, b, y);
    
    // Test case 4: 128 * 2
    #20 start = 1;
    a = 128;
    b = 2;
    #10 start = 0;
    
    @(posedge valid);
    $display("Test case 4: %d * %d = %d", a, b, y);
    
    // End simulation
    #20 $finish;
  end
  
  // Optional: Waveform dump
  initial begin
    $dumpfile("multiplier_tb.vcd");
    $dumpvars(0, multiplier_tb);
  end
  
endmodule
