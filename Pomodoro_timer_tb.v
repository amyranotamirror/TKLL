`timescale 1ns / 1ps
module Pomodoro_timer_tb (
        clk,
    rst,
    btn,
    sclk,
    rclk,
    dio
);
    reg clk;
    reg rst;
    reg [3:0]btn;
    wire sclk;
    wire rclk;
    wire dio;

Pomodoro_timer Timer(clk, rst, btn, sclk, rclk, dio);
initial begin 
    $monitor("%0d", $time, clk, rst, btn, sclk, rclk, dio);
    end
    initial begin

#10 btn = 4'b1000;

#50 rst = 1;

#60 btn = 4'b0001;

#100 rst = 1;
end
endmodule
