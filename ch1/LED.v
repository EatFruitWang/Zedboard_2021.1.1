`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 王俊雄
// 
// Create Date   : 2023/07/11 16:17:14
// Design Name   : LED 流水燈
// Module Name   : LED
// Project Name  : LED
// Target Devices: LED
// Tool Versions : v1.0
// Description: 
// 使用寄存器移位控制LED燈由左至右輸出，此文件沒有使用任何IP，可以按照不同晶片修改參數以應用。
// Dependencies: 
// 
// Revision:
// V1.0 建立檔案
// 
//////////////////////////////////////////////////////////////////////////////////


module LED
#(
    parameter LED_quantity   = 8,         //八顆LED
    parameter TIME_count     = 100000000, //計數100000000次
    parameter TIME_count_bit = 27         //計數器所需位元數(取以二為底的count次數)
)
(
    input  wire clk,
    input  wire rst,
    output reg [LED_quantity-1 : 0] LED
);
    wire rst_n = ~rst;
    reg [TIME_count_bit + 1 : 0] count;
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            LED   <= 'd0;
            count <= 'd0;
        end
        else
        begin
            count <= (count == TIME_count - 1'b1) ? 'd0 : (count + 1'b1);
            LED   <= (count == TIME_count - 1'b1) ? ((LED == 'd0 || LED == 'd128)) ? 'd1 : {LED[6:0],LED[7]} : LED;
        end
    end
endmodule
