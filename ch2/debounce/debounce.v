`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 王俊雄
// 
// Create Date: 2023/07/12 18:53:07
// Design Name: 按鍵消抖
// Module Name: debounce
// Tool Versions: V1.0
// Description: 
// 此文件用於測試按鍵消抖，使按鈕按一下計數加1(用LED顯示)。
// Revision:
// V1.0 創建檔案
//////////////////////////////////////////////////////////////////////////////////

module debounce
(
    input  wire clk,
    input  wire rst,
    input  wire btn,
    output reg  [7:0] LED
);
wire rst_n = ~rst;
//狀態
localparam LOW         = 2'b00;
localparam HIGH_BOUNCE = 2'b01;
localparam HIGH        = 2'b10;
localparam LOW_BOUNCE  = 2'b11;
//狀態存取
reg debounce_out;
reg [1:0] STA;
//狀態機
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        debounce_out <= 1'b0;
        STA <= LOW;
    end
    else
    begin
        case (STA)
            LOW :
            begin
                debounce_out <= 1'b0;
                STA <= btn ? HIGH_BOUNCE : LOW;
            end
            HIGH_BOUNCE :
            begin
                STA <= (HIGH_count == 'd2000000) ? HIGH : btn ? HIGH_BOUNCE : LOW;
            end
            HIGH :
            begin
                debounce_out <= 1'b1;
                STA <= btn ? HIGH : LOW_BOUNCE;
            end
            LOW_BOUNCE :
            begin
                STA <= (LOW_count == 'd2000000) ? LOW : btn ? HIGH : LOW_BOUNCE;
            end
            default:
            begin
                STA <= LOW;
            end 
        endcase
    end
end
//bounce穩定計時器
reg [20:0] HIGH_count;
reg [20:0] LOW_count;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        HIGH_count <= 'd0;
        LOW_count  <= 'd0;
    end
    else
    begin
        HIGH_count <= HIGH_BOUNCE ? btn ? HIGH_count + 1'b1 : 'd0 : 'd0;
        LOW_count  <= LOW_BOUNCE  ? btn ? 'd0 : LOW_count + 1'b1  : 'd0;
    end
end
//LED輸出
always @(posedge debounce_out or negedge rst_n)
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
