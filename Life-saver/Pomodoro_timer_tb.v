`timescale 1ns / 1ps
module Pomodoro_timer_tb ();
    reg clk;
    reg rst;
    reg [3:0] btn;
    wire sclk;
    wire rclk;
    wire dio;
    wire [3:0]  LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7;
    wire [7:0]  NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7;
    //Clock Generator
    initial begin
        clk = 1'b0;
        forever #0.001 clk = ~clk; //Clock cycle = 0.01(ns)
    end
    
    Pomodoro_display Timer( clk,
                            rst,
                            btn,
                            sclk,
                            rclk,
                            dio,
                            
                            //TESTING PURPOSE
                            LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7,
                            NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7);
    defparam Timer.COUNT_LIM = 'd5000; //Frequency of 5MHz
    defparam Timer.mins5 = 'd5; //count down to  5seconds only
    defparam Timer.mins10 = 'd100; //count down to 100seconds only
    
    initial begin
        //Initial reset
                    rst = 0;
                    btn = 4'b0000;
        #1          rst = 1;
        #0.5        rst = 0;
        
        //Button 3: 5 seconds
        #4        btn = 4'b1000;//5seconds setup
        #5        btn = 4'b0000;//Stop pushing button
        #60       btn = 4'b1000;//5seconds setup TWICE
        #6        btn = 4'b0000;//Stop pushing button
        
        //Button 2: 100 seconds
        #60       btn = 4'b0100;//100seconds setup
        #4        btn = 4'b0000;//Stop pushing button
        #50       btn = 4'b1000;//Interrupt 100seconds with 5seconds
        #5        btn = 4'b0000;//Stop pushing button
        #50       rst = 1'b1;   //Interrup 5mins with reset
        #5      rst = 1'b0;
        
        #300 $stop;
    end
    initial #300 $finish;
endmodule
