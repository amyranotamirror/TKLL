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


module Pomodoro_timer(
    clk,
    rst,
    btn,
    sclk,
    rclk,
    dio
    );
    
    input clk; //Default Arty-Z7 Clock: 125 MHz
    input rst; //Reset Switch
    input [3:0] btn; //Button to change modes
    output sclk; //Shift data signal
    output rclk; //Storage register signal
    output dio; //Sequential input data for Module 8 LED 7 Segment
    
    parameter       COUNT_LIM = 27'd125000000; //Count up to 125M ticks (1s)
    parameter       LED_WIDTH = 'd32; //4-bit binary with 8 digits (4x8 = 32 bits)
    //parameter       DIG_WIDTH = 'd64;
    
    
                    
    parameter       BTN3 = 4'b1000, BTN2 = 4'b0100,
                    BTN1 = 4'b0010, BTN0 = 4'b0001;
                    
    reg [15:0]                  data;
    reg [2:0]                   cnt;
    reg [15:0]                  displayed_number = 'd0;
    reg [15:0]                  set_time;
    reg [15:0]                  mod_cnt;
    reg [26:0]                  one_second_counter; 
    wire                        one_second_enable;
    wire                        vld;
    
//    reg [DIG_WIDTH - 1:0]       BCD;
//    reg [LED_WIDTH - 1:0]       LED;
    
    wire            seconds;
    reg [3:0]       LED_0;
    reg [3:0]       LED_1;
    reg [3:0]       LED_2;
    reg [3:0]       LED_3;
    reg [3:0]       LED_4;
    reg [3:0]       LED_5;
    reg [3:0]       LED_6;
    reg [3:0]       LED_7;

    wire [7:0]       NUM_0;
    wire [7:0]       NUM_1;
    wire [7:0]       NUM_2;
    wire [7:0]       NUM_3;
    wire [7:0]       NUM_4;
    wire [7:0]       NUM_5;
    wire [7:0]       NUM_6;
    wire [7:0]       NUM_7;
    
    always @(posedge clk or posedge rst)
        begin
            if(rst)
                one_second_counter <= 0;
            else begin
                if(one_second_counter == COUNT_LIM - 1) 
                     one_second_counter <= 0;
                else
                    one_second_counter <= one_second_counter + 1;
            end
        end 
    
    always @(btn)
    begin
        case(btn)
        BTN3: begin set_time = 'd300;//5 minutes
                       mod_cnt = 'd0;
                 end
        BTN2: begin set_time = 'd600;//10 minutes
                       mod_cnt = 'd0;
                 end
        BTN1: begin set_time = 'd1500;//25 minutes
                       mod_cnt = 'd0;
                 end
        BTN0: begin set_time = 'd3000;//50 minutes
                       mod_cnt = 'd0;
                 end
        default: mod_cnt <= mod_cnt;
        endcase
    end
    
    assign one_second_enable = (one_second_counter == COUNT_LIM - 1) ? 1 : 0;
    assign seconds = set_time-displayed_number;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            displayed_number <= 0;
            {LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7} = {LED_WIDTH{1'b0}};
        end
        else if(one_second_enable) begin
            displayed_number <= displayed_number + 1;
            LED_4 <= seconds /600;
            LED_5 <= (seconds % 600)/60;
            LED_6 <= ((seconds % 600)%60)/10;
            LED_7 <= ((seconds % 600)%60)%10;
            if (displayed_number == set_time)
              begin
                mod_cnt <= mod_cnt + 1;
                LED_0 <= (mod_cnt)/1000;
                LED_1 <= (mod_cnt % 1000)/100;
                LED_2 <= ((mod_cnt % 1000)%100)/10;
                LED_3 <= ((mod_cnt % 1000)%100)%10;                        
              end
            else displayed_number <= 0;
           end
    end  
    always @(posedge clk) begin
        if (rst) cnt <= 0;
        else if (vld) begin
            cnt <= cnt + 1'b1; 
        end
    end
wire ready;
    assign vld = ready;
    
    always @(posedge clk) begin
        if (rst) data <= {NUM_0, 8'h01};
        else if(one_second_enable==1)
        begin
            case (cnt)
                'd0: data <= {NUM_0, 8'h01};
                'd1: data <= {NUM_1, 8'h02};
                'd2: data <= {NUM_2, 8'h04};
                'd3: data <= {NUM_3, 8'h08};
                'd4: data <= {NUM_4, 8'h10};
                'd5: data <= {NUM_5, 8'h20};
                'd6: data <= {NUM_6, 8'h40};
                'd7: data <= {NUM_7, 8'h80};
                default: data <= 16'h0000;
            endcase
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
    
    mfe_led7seg_74hc595_controller led7seg_ctrl(
        .clk    (clk),
        .rst    (rst),
        .dat    (data),
        .vld    (vld),
        .rdy    (ready),
    
        .sclk   (sclk),
        .rclk   (rclk),
        .dio    (dio)
        );
//    mfe_led7seg_74hc595_wrapper
//    #(
//    .DIG_NUM    (DIG_NUM),
//    .SEG_NUM    (SEG_NUM),
//    .DIV_WIDTH  (DIV_WIDTH)
//    )
//led7seg_ctrl_wrapper(
//    .clk        (clk),
//    .rst        (rst),
//    .dat        (data),
//    .vld        (vld),

//    .sclk       (sclk),
//    .rclk       (rclk),
//    .dio        (dio)
//    );
endmodule
