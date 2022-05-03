`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2022 11:51:29 AM
// Design Name: 
// Module Name: BCD_7_Segment
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


module BCD_7_Segment(
    input [3:0] BCD,
    output reg [7:0] segment
    );
    parameter       DIG_0 = 8'hC0, DIG_1 = 8'hF9, DIG_2 = 8'hA4, DIG_3 = 8'hB0, DIG_4 = 8'h99,
                    DIG_5 = 8'h92, DIG_6 = 8'h82, DIG_7 = 8'hF8, DIG_8 = 8'h80, DIG_9 = 8'h90;
    
    always @(*) begin
        case(BCD)
            'd0: segment <= DIG_0;
            'd1: segment <= DIG_1;
            'd2: segment <= DIG_2;
            'd3: segment <= DIG_3;
            'd4: segment <= DIG_4;
            'd5: segment <= DIG_5;
            'd6: segment <= DIG_6;
            'd7: segment <= DIG_7;
            'd8: segment <= DIG_8;
            'd9: segment <= DIG_9;
            default: segment <= DIG_0;
        endcase
    end              
                        
endmodule
