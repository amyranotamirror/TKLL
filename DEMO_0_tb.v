`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2022 04:23:06 PM
// Design Name: 
// Module Name: DEMO_0_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DEMO_0_tb();
    reg  clk;
    reg  rst;
    wire sclk;
    wire rclk;
    wire dio;
    
    mfe_led7seg_74hc595_demo_0 UUT(.clk(clk), .rst(rst), .sclk(sclk), .rclk(rclk), .dio(dio));
    
    initial begin
        clk <= 1'b0;
        forever #0.5    clk = ~clk;
    end
    
    initial #20 $finish;
    initial begin
        #2  rst <= 1'b1;
        #3  rst <= 1'b0;
        #10 rst <= 1'b1;
        #2  rst <= 1'b0;
        #20 $stop;
    end
endmodule
