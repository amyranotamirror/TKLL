`timescale 1ns / 1ps
module Pomodoro_timer_tb ();
    reg clk;
    reg rst;
    reg [3:0]btn;
    wire sclk;
    wire rclk;
    wire dio;
    
    //Clock Generator
    initial begin
        clk = 1'b0;
        forever #0.5 clk = ~clk;
    end
    Pomodoro_timer Timer(clk, rst, btn, sclk, rclk, dio);
    defparam Timer.COUNT_LIM = 'd1;
    
    initial begin
        //Initial reset
            rst = 0;
        #2  rst = 1;
        //Posedge-trigger
        #2 btn = 4'b1000;
        #1  btn = 4'b0000;
        #400 rst = 1;
        
        #2 btn = 4'b0001;
        #2 btn = 4'b0000;
        #100 rst = 1;
        #510 $stop;
    end
    initial #510 $finish;
endmodule
