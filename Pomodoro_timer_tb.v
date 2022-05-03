`timescale 1ns / 1ps
module Pomodoro_timer_tb ();
    reg clk;
    reg rst;
    reg [3:0] btn;
    wire sclk;
    wire rclk;
    wire dio;
    wire [15:0] displayed_number, mod_cnt;
    wire [26:0] one_second_counter;
    wire [3:0]  LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7;
    wire [7:0]  NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7;
    //Clock Generator
    initial begin
        clk = 1'b0;
        forever #0.005 clk = ~clk; //Clock cycle = 0.01(ns)
    end
    
    Pomodoro_display Timer( clk,
                            rst,
                            btn,
                            sclk,
                            rclk,
                            dio,
                            
                            //TESTING PURPOSE
                            displayed_number,
                            mod_cnt,
                            one_second_counter,
                            LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7,
                            NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7);
    defparam Timer.COUNT_LIM = 'd2; //Frequency = 1Hz
    
    initial begin
        //Initial reset
                    rst = 0;
                    btn = 4'b0000;
        #0.1        rst = 1;
        #0.2        rst = 0;
        
        //Button 3: 5 mins
        #0.3        btn = 4'b1000;//5mins setup
        #0.2        btn = 4'b0000;//DONE clock
        #7          btn = 4'b1000;//Twice
        #0.2        btn = 4'b0000;//DONE clock
        
        //Button 2: 10 mins
        #7        btn = 4'b0100;//10mins setup
        #0.05       btn = 4'b0000;
        #2          btn = 4'b1000; //Interrupt 10mins with 5mins
        #0.05       btn = 4'b0000;
        #2          rst = 1'b1;   //Interrup 5mins with reset
        #0.1       rst = 1'b0;
        
        #20 $stop;
    end
    initial #20 $finish;
endmodule
