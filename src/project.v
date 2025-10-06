/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_counter (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  assign uio_oe = 8'b0;         // keep IO's on input always

  reg [7:0] temp;             
  
  wire load_en = ui_in[0];       // turn on of the inputs into a load-enable signal

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      temp <= 8'b0;             // asynchronous reset
    else if (load_en)
      temp <= uio_in;           // synchronous load (checks load signal on each clock cycle)
    else
      temp <= temp + 1;         // if no load and no reset, then count upwards by 1
  end

  assign uo_out = ena ? temp : 8'bz; // uses the value of ena to decide whether to output counter value or go high-z

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{clk, 1'b0};

endmodule
