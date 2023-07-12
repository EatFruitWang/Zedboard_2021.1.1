`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 王俊雄
// 
// Create Date: 2023/07/12 14:15:35
// Design Name: 按鍵抖動未消除
// Module Name: bounce
// Project Name: 
// Target Devices: bounce
// Tool Versions: V1.0
// Description: 
// 此檔案為實驗按鍵抖動未消除時的二進制加法測試文件。
// Revision:
// V1.0 建立檔案
//////////////////////////////////////////////////////////////////////////////////


module bounce
#(
    parameter LED_bit = 8 // LED數量
)
(
    input  wire btn,
    input  wire rst,
    output reg [LED_bit - 1 : 0] LED
);
wire rst_n = ~rst;
always @(posedge btn or negedge rst_n)
begin
    if(!rst_n)
    begin
        LED <= 'd0;
    end
    else
    begin
        LED <= (LED == 8'b11111111) ? 'd0 : LED + 1'b1;
    end
end
endmodule
