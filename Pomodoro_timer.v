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
    
    input clk;
    input rst;
    input [3:0]btn;
    output sclk;
    output rclk;
    output dio;
    
    reg [15:0] data;
    reg [ 2:0] cnt;
    reg [15:0] displayed_number = 'd0;
    reg [15:0] set_time;
    reg [15:0] mod_cnt;
    reg [26:0] one_second_counter; 
    wire one_second_enable;
    wire       vld;
    
    reg [3:0] LED_0;
    reg [3:0] LED_1;
    reg [3:0] LED_2;
    reg [3:0] LED_3;
    reg [3:0] LED_4;
    reg [3:0] LED_5;
    reg [3:0] LED_6;
    reg [3:0] LED_7;    
    
    reg [3:0] NUM_0;
    reg [3:0] NUM_1;
    reg [3:0] NUM_2;
    reg [3:0] NUM_3;
    reg [3:0] NUM_4;
    reg [3:0] NUM_5;
    reg [3:0] NUM_6;
    reg [3:0] NUM_7;
    always @(posedge clk or posedge rst)
        begin
            if(rst==1)
                one_second_counter <= 0;
            else begin
                if(one_second_counter>=124999999) 
                     one_second_counter <= 0;
                else
                    one_second_counter <= one_second_counter + 1;
            end
        end 
        
        always @(*)
        begin
            case(btn)
            4'b1000: begin set_time = 'd300;//5 minutes
                           mod_cnt = 'd0;
                     end
            4'b0100: begin set_time = 'd600;//10 minutes
                           mod_cnt = 'd0;
                     end
            4'b0010: begin set_time = 'd1500;//25 minutes
                           mod_cnt = 'd0;
                     end
            4'b0001: begin set_time = 'd3000;//50 minutes
                           mod_cnt = 'd0;
                     end
            endcase
        end
     assign one_second_enable = (one_second_counter==124999999)?1:0;
            always @(posedge clk or posedge rst)
            begin
                if(rst==1)
                  begin
                    displayed_number <= 0;
                    LED_0 <= 'd0;
                    LED_1 <= 'd0;
                    LED_2 <= 'd0;
                    LED_3 <= 'd0;
                    LED_4 <= 'd0;
                    LED_5 <= 'd0;
                    LED_6 <= 'd0;
                    LED_7 <= 'd0;
                  end
                else if(one_second_enable==1)
                   begin
                    displayed_number <= displayed_number + 1;
                    LED_4 <= (set_time-displayed_number)/600;
                    LED_5 <= ((set_time-displayed_number) % 600)/60;
                    LED_6 <= (((set_time-displayed_number) % 600)%60)/10;
                    LED_7 <= (((set_time-displayed_number) % 600)%60)%10;
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
    
 always @(*)
    begin
        case(LED_0)
        4'b0000: NUM_0 = 7'b0000001; // "0"     
        4'b0001: NUM_0 = 7'b1001111; // "1" 
        4'b0010: NUM_0 = 7'b0010010; // "2" 
        4'b0011: NUM_0 = 7'b0000110; // "3" 
        4'b0100: NUM_0 = 7'b1001100; // "4" 
        4'b0101: NUM_0 = 7'b0100100; // "5" 
        4'b0110: NUM_0 = 7'b0100000; // "6" 
        4'b0111: NUM_0 = 7'b0001111; // "7" 
        4'b1000: NUM_0 = 7'b0000000; // "8"     
        4'b1001: NUM_0 = 7'b0000100; // "9" 
        default: NUM_0 = 7'b0000001; // "0"
        endcase
            case(LED_1)
            4'b0000: NUM_1 = 7'b0000001; // "0"     
            4'b0001: NUM_1 = 7'b1001111; // "1" 
            4'b0010: NUM_1 = 7'b0010010; // "2" 
            4'b0011: NUM_1 = 7'b0000110; // "3" 
            4'b0100: NUM_1 = 7'b1001100; // "4" 
            4'b0101: NUM_1 = 7'b0100100; // "5" 
            4'b0110: NUM_1 = 7'b0100000; // "6" 
            4'b0111: NUM_1 = 7'b0001111; // "7" 
            4'b1000: NUM_1 = 7'b0000000; // "8"     
            4'b1001: NUM_1 = 7'b0000100; // "9" 
            default: NUM_1 = 7'b0000001; // "0"
            endcase
                case(LED_2)
                4'b0000: NUM_2 = 7'b0000001; // "0"     
                4'b0001: NUM_2 = 7'b1001111; // "1" 
                4'b0010: NUM_2 = 7'b0010010; // "2" 
                4'b0011: NUM_2 = 7'b0000110; // "3" 
                4'b0100: NUM_2 = 7'b1001100; // "4" 
                4'b0101: NUM_2 = 7'b0100100; // "5" 
                4'b0110: NUM_2 = 7'b0100000; // "6" 
                4'b0111: NUM_2 = 7'b0001111; // "7" 
                4'b1000: NUM_2 = 7'b0000000; // "8"     
                4'b1001: NUM_2 = 7'b0000100; // "9" 
                default: NUM_2 = 7'b0000001; // "0"
                endcase
                    case(LED_3)
                    4'b0000: NUM_3 = 7'b0000001; // "0"     
                    4'b0001: NUM_3 = 7'b1001111; // "1" 
                    4'b0010: NUM_3 = 7'b0010010; // "2" 
                    4'b0011: NUM_3 = 7'b0000110; // "3" 
                    4'b0100: NUM_3 = 7'b1001100; // "4" 
                    4'b0101: NUM_3 = 7'b0100100; // "5" 
                    4'b0110: NUM_3 = 7'b0100000; // "6" 
                    4'b0111: NUM_3 = 7'b0001111; // "7" 
                    4'b1000: NUM_3 = 7'b0000000; // "8"     
                    4'b1001: NUM_3 = 7'b0000100; // "9" 
                    default: NUM_3 = 7'b0000001; // "0"
                    endcase
                        case(LED_4)
                        4'b0000: NUM_4 = 7'b0000001; // "0"     
                        4'b0001: NUM_4 = 7'b1001111; // "1" 
                        4'b0010: NUM_4 = 7'b0010010; // "2" 
                        4'b0011: NUM_4 = 7'b0000110; // "3" 
                        4'b0100: NUM_4 = 7'b1001100; // "4" 
                        4'b0101: NUM_4 = 7'b0100100; // "5" 
                        4'b0110: NUM_4 = 7'b0100000; // "6" 
                        4'b0111: NUM_4 = 7'b0001111; // "7" 
                        4'b1000: NUM_4 = 7'b0000000; // "8"     
                        4'b1001: NUM_4 = 7'b0000100; // "9" 
                        default: NUM_4 = 7'b0000001; // "0"
                        endcase
                            case(LED_5)
                            4'b0000: NUM_5 = 7'b0000001; // "0"     
                            4'b0001: NUM_5 = 7'b1001111; // "1" 
                            4'b0010: NUM_5 = 7'b0010010; // "2" 
                            4'b0011: NUM_5 = 7'b0000110; // "3" 
                            4'b0100: NUM_5 = 7'b1001100; // "4" 
                            4'b0101: NUM_5 = 7'b0100100; // "5" 
                            4'b0110: NUM_5 = 7'b0100000; // "6" 
                            4'b0111: NUM_5 = 7'b0001111; // "7" 
                            4'b1000: NUM_5 = 7'b0000000; // "8"     
                            4'b1001: NUM_5 = 7'b0000100; // "9" 
                            default: NUM_5 = 7'b0000001; // "0"
                            endcase
                                case(LED_6)
                                4'b0000: NUM_6 = 7'b0000001; // "0"     
                                4'b0001: NUM_6 = 7'b1001111; // "1" 
                                4'b0010: NUM_6 = 7'b0010010; // "2" 
                                4'b0011: NUM_6 = 7'b0000110; // "3" 
                                4'b0100: NUM_6 = 7'b1001100; // "4" 
                                4'b0101: NUM_6 = 7'b0100100; // "5" 
                                4'b0110: NUM_6 = 7'b0100000; // "6" 
                                4'b0111: NUM_6 = 7'b0001111; // "7" 
                                4'b1000: NUM_6 = 7'b0000000; // "8"     
                                4'b1001: NUM_6 = 7'b0000100; // "9" 
                                default: NUM_6 = 7'b0000001; // "0"
                                endcase
                                    case(LED_7)
                                    4'b0000: NUM_7 = 7'b0000001; // "0"     
                                    4'b0001: NUM_7 = 7'b1001111; // "1" 
                                    4'b0010: NUM_7 = 7'b0010010; // "2" 
                                    4'b0011: NUM_7 = 7'b0000110; // "3" 
                                    4'b0100: NUM_7 = 7'b1001100; // "4" 
                                    4'b0101: NUM_7 = 7'b0100100; // "5" 
                                    4'b0110: NUM_7 = 7'b0100000; // "6" 
                                    4'b0111: NUM_7 = 7'b0001111; // "7" 
                                    4'b1000: NUM_7 = 7'b0000000; // "8"     
                                    4'b1001: NUM_7 = 7'b0000100; // "9" 
                                    default: NUM_7 = 7'b0000001; // "0"
                                    endcase
   end
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
    
endmodule
