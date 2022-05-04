`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2022 11:21:11 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    clk,
    in,
    rst,
    out
    );
    
    //Port declaration
    input       clk;
    input       in;
    input       rst;
    output      out;
    
    //Logic
    reg q1, q2;
    
    always @(posedge clk, posedge rst)
    begin
        if (rst) begin
            q1 <= 0;
            q2 <= 0;
        end
        else begin
            q1 <= in;
            q2 <= q1;
        end
    end
    
    assign out = (~q2 & q1);
endmodule
