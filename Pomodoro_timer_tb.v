`timescale 1ns / 1ps
module Pomodoro_timer_tb ();
    reg clk;
    reg rst;
    reg [3:0]btn;
    wire sclk;
    wire rclk;
    wire dio;
    wire [15:0] displayed_number;
    
    //Clock Generator
    initial begin
        clk = 1'b0;
        forever #0.5 clk = ~clk;
    end
    Pomodoro_timer Timer(clk, rst, btn, sclk, rclk, dio, displayed_number);
    defparam Timer.COUNT_LIM = 'd1;
    
    initial begin
        //Initial reset
            rst = 0;
        #100  rst = 1;
        #20   rst = 0;
        //Posedge-trigger
        #30 btn = 4'b1000;
        #20  btn = 4'b0000;
        #2000 rst = 1;
        
        #1000 rst = 1;
        #3000 $stop;
    end
    initial #3000 $finish;
endmodule
