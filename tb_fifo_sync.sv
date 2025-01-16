`timescale 1ns / 1ps
`include "fifo_design.sv"
module tb_fifo_sync;

  // Parameters
  parameter DATA_WIDTH = 8;
  parameter FIFO_DEPTH = 32;

  // Inputs
  reg clk;
  reg rst;
  reg wr;
  reg rd;
  reg [DATA_WIDTH-1:0] data_in;

  // Outputs
  wire empty;
  wire almost_empty;
  wire almost_full;
  wire full;
  wire [DATA_WIDTH-1:0] data_out;

  // Instantiate the FIFO
  fifo_sync fifo (
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .data_in(data_in),
    .empty(empty),
    .almost_empty(almost_empty),
    .almost_full(almost_full),
    .full(full),
    .data_out(data_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period of 10 time units
  end

  // Test procedure
  initial begin
    // Initialize inputs
    rst = 1;
    wr = 0;
    rd = 0;
    data_in = 8'b0;

    // Reset the FIFO
    #10; 
    rst = 0; // Release reset

    // Test writing to the FIFO
    $display("Testing write operation...");
    
    for (integer i = 0; i < FIFO_DEPTH; i = i + 1) begin
      @(posedge clk);
      wr = 1; 
      data_in = $urandom; // Write data
      #1; 
      wr = 0; 
      @(posedge clk); // Wait for one clock cycle
      if (full) begin
        $display("FIFO is full at write index %d", i);
      end
      $display("Wrote %d to FIFO", data_in);
    end

    // Test reading from the FIFO
    $display("Testing read operation...");
    
    for (integer i = 0; i < FIFO_DEPTH; i = i + 1) begin
      @(posedge clk);
      rd = 1; 
      #1; 
      rd = 0; 
      @(posedge clk); // Wait for one clock cycle
      if (empty) begin
        $display("FIFO is empty at read index %d", i);
        break; // Exit if empty
      end
      $display("Read %d from FIFO", data_out);
    end

    // Check status flags after operations
    @(posedge clk);
    if (empty) $display("FIFO is empty after reads.");
    
    // Finish simulation after a delay to observe final state
    #50;
    $finish;
  end

endmodule
