`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2022 04:27:23 PM
// Design Name: 
// Module Name: DEMO_1_tb
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


module DEMO_1_tb();
    reg  clk;
    reg  rst;
    reg     btn;
    wire sclk;
    wire rclk;
    wire dio;
    
    mfe_led7seg_74hc595_demo_1 UUT(.clk(clk), .rst(rst), .btn(btn), .sclk(sclk), .rclk(rclk), .dio(dio));
    
    initial begin
        clk <= 1'b0;
        forever #0.5    clk = ~clk;
    end
    
    initial begin
                btn <= 1'b0;
        #1      rst <= 1'b0;
        #2      rst <= 1'b1;
        #1.5    rst <= 1'b0;
                btn <= 1'b1;
        #3      btn <= 1'b0;
        #5      btn <= 1'b1;
        #2      btn <= 1'b0;
        #20     $stop;
    end
    
    initial #20 $finish;
endmodule
