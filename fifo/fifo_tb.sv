`timescale 1ns/1ps

module fifo_top_tb;

    parameter WSIZE = 8;
    parameter ASIZE = 4;
    parameter DEPTH = 1 << (ASIZE - 1); // Only 8 entries for 4-bit Gray ptrs

    // Clock and Reset
    logic rclk, rrst_n, rinc;
    logic wclk, wrst_n, winc;
    logic [WSIZE-1:0] wdata;
    wire [WSIZE-1:0] rdata;
    wire rempty, wfull;

    // Instantiate the FIFO
    fifo_top #(WSIZE, ASIZE) dut (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rdata(rdata),
        .rempty(rempty),

        .wclk(wclk),
        .wrst_n(wrst_n),
        .wdata(wdata),
        .winc(winc),
        .wfull(wfull)
    );

    // Clock generation
    initial begin
        rclk = 0;
        forever #7 rclk = ~rclk; // ~71 MHz
    end

    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk; // 100 MHz
    end

    // Reset task
    task reset_fifo;
        begin
            rrst_n = 0;
            wrst_n = 0;
            rinc = 0;
            winc = 0;
            wdata = 0;
            repeat (4) @(posedge rclk);
            repeat (4) @(posedge wclk);
            rrst_n = 1;
            wrst_n = 1;
        end
    endtask

    // Write Task
    task write_data(input [WSIZE-1:0] data);
        begin
            @(posedge wclk);
            if (!wfull) begin
                wdata = data;
                winc = 1;
            end else begin
                $display("Write blocked: FIFO FULL");
                winc = 0;
            end
            @(posedge wclk);
            winc = 0;
        end
    endtask

    // Read Task
    task read_data(output [WSIZE-1:0] data);
        begin
            @(posedge rclk);
            if (!rempty) begin
                rinc = 1;
            end else begin
                $display("Read blocked: FIFO EMPTY");
                rinc = 0;
            end
            @(posedge rclk);
            rinc = 0;
            data = rdata;
        end
    endtask

    // Main test
    initial begin
        $dumpfile("fifo_top_tb.vcd");
        $dumpvars(0, fifo_top_tb);

        reset_fifo();

        $display("Writing to FIFO...");
        for (int i = 0; i < DEPTH; i++) begin
            write_data(i);
        end

        $display("Trying to write to full FIFO...");
        write_data(99); // This should be blocked if FIFO is full

        #50;

        $display("Reading from FIFO...");
        for (int i = 0; i < DEPTH; i++) begin
            logic [WSIZE-1:0] r;
            read_data(r);
            $display("Read: %0d", r);
        end

        $display("Trying to read from empty FIFO...");
        $display("rempty = %b", rempty);

        #100;
        $finish;
    end

endmodule
