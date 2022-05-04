`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2022 11:57:29 PM
// Design Name: 
// Module Name: Pomodoro_timer
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


module Pomodoro_display(
    clk,
    rst,
    btn,
    sclk,
    rclk,
    dio,
    
    //TESTING PURPOSE
    LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7,
    NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7
    );
    
    input clk; //Default Arty-Z7 Clock: 125 MHz
    input rst; //Reset Switch
    input [3:0] btn; //Button to change modes
    output sclk; //Shift data signal
    output rclk; //Storage register signal
    output dio; //Sequential input data for Module 8 LED 7 
                     
    
    parameter           COUNT_LIM = 27'd125000000; //Count up to 125M ticks (1s)
    parameter           LED_WIDTH = 'd32; //4-bit binary with 8 digits (4x8 = 32 bits)
    parameter           mins5 = 'd300, mins10 = 'd600, mins25 = 'd1500, mins50 = 'd3000;
                    
    parameter           BTN3 = 4'b1000, BTN2 = 4'b0100,
                        BTN1 = 4'b0010, BTN0 = 4'b0001;
    parameter           DEFAULT_STATE = 4'b0000;
    parameter           DIG_NUM       = 8;
    parameter           SEG_NUM       = 8;
    localparam          CHA_WIDTH     = DIG_NUM + SEG_NUM;
    localparam          DAT_WIDTH     = SEG_NUM * DIG_NUM;
    parameter           DIV_WIDTH     = 8; 
                  
    reg [DAT_WIDTH : 0]         data;
    reg [15:0]                  set_time;
    reg                         stop;
    reg [26:0]                  one_second_counter;
    reg [15:0]                  displayed_number;
    wire [3:0]                  btn_detector;
    wire                        one_second_enable;
    
    
    
    //TESTING PURPOSE
    output reg [3:0]        LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7;
    output [7:0]            NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            one_second_counter <= 0;
        end
        else begin
            if(one_second_counter == COUNT_LIM - 1) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end
        
    assign one_second_enable = (one_second_counter == COUNT_LIM - 1) ? 1 : 0;
        
    //always @(btn_detector or rst) begin
    always @(posedge clk) begin
        if (rst) begin
            stop <= 1'b1;
            set_time <= 4'b0000;
        end
        else if (displayed_number == set_time + 1)begin
             stop <= 1'b1;
             end
        else if(btn) begin
            stop <= 1'b0;
            case(btn)
                BTN3: begin 
                    set_time = mins5;//5 minutes
                end
                BTN2: begin 
                    set_time = mins10;//10 minutes
                end
                BTN1: begin set_time = mins25;//25 minutes
                         end
                BTN0: begin set_time = mins50;//50 minutes
                         end
                default: set_time = 0;
            endcase
        end
    end
    
    
    always @(posedge clk) begin
        if (rst || btn != 4'b0000) begin
            displayed_number <= 0;
            if(rst) {LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7} = {LED_WIDTH{1'b0}};
        end
        else if(one_second_enable && ~stop) begin
            displayed_number <= displayed_number + 1;
            LED_7 <= (set_time - displayed_number) /600;
            LED_6 <= ((set_time - displayed_number) % 600)/60;
            LED_5 <= (((set_time - displayed_number) % 600)%60)/10;
            LED_4 <= (((set_time - displayed_number) % 600)%60)%10;
            LED_3 <= (set_time) /600;
            LED_2 <= ((set_time) % 600)/60;
            LED_1 <= (((set_time) % 600)%60)/10;
            LED_0 <= (((set_time) % 600)%60)%10;
         end
    end  
    
    BCD_7_Segment display_0(.BCD(LED_0), .segment(NUM_0));
    BCD_7_Segment display_1(.BCD(LED_1), .segment(NUM_1));
    BCD_7_Segment display_2(.BCD(LED_2), .segment(NUM_2));
    BCD_7_Segment display_3(.BCD(LED_3), .segment(NUM_3));
    BCD_7_Segment display_4(.BCD(LED_4), .segment(NUM_4));
    BCD_7_Segment display_5(.BCD(LED_5), .segment(NUM_5));
    BCD_7_Segment display_6(.BCD(LED_6), .segment(NUM_6));
    BCD_7_Segment display_7(.BCD(LED_7), .segment(NUM_7));
 
    
    always @(posedge clk) begin
        if (rst) data <= {DAT_WIDTH {1'b0}};
        else
        begin
           data <= {NUM_7, NUM_6, NUM_5, NUM_4, NUM_3, NUM_2, NUM_1, NUM_0}; 
        end
    end
 
    
    
    mfe_led7seg_74hc595_controller_wrapper
        #(
        .DIG_NUM    (DIG_NUM),
        .SEG_NUM    (SEG_NUM),
        .DIV_WIDTH  (DIV_WIDTH)
        )
    led7seg_ctrl_wrapper(
        .clk        (clk),
        .rst        (rst),
        .dat        (data),
        .vld        (1'b1),
    
        .sclk       (sclk),
        .rclk       (rclk),
        .dio        (dio)
        );
endmodule
