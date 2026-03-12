`default_nettype none
`timescale 1ns / 1ps

module tt_um_signal_detector (

    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    output wire [7:0] uo_out,

    input  wire clk,
    input  wire rst_n,
    input  wire ena
);

assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

wire [7:0] fir_out;
wire [7:0] env_out;
wire detect;
wire [7:0] depth;

// FIR FILTER
fir_filter FIR (
    .clk(clk),
    .din(ui_in),
    .dout(fir_out)
);

// ENVELOPE DETECTOR
envelope_detector ENV (
    .clk(clk),
    .signal(fir_out),
    .env(env_out)
);

// PEAK DETECTOR
peak_detector PEAK (
    .clk(clk),
    .signal(env_out),
    .detect(detect)
);

// DEPTH ESTIMATOR
depth_estimator DEPTH (
    .clk(clk),
    .rst_n(rst_n),
    .detect(detect),
    .depth(depth)
);

// Output mapping
assign uo_out[0] = detect;
assign uo_out[7:1] = depth[7:1];

endmodule

`default_nettype wire
