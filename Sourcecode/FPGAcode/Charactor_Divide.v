`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 16:15:50
// Design Name: 
// Module Name: Charactor_Divide
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


module Charactor_Divide(
    input clk,   //时钟信号
    input Y,   //二值化处理后的像素值
    input HSync,   //Line signal(高电平有效)
    input VSync,   //Field signal(高电平有效)
    input VDE,   //Data valid signal(高电平有效，高电平时读取数据)
    input [10:0]x_num,
    input [9:0]y_num,
    output  [12:0]x_min1,
    output  [12:0]x_max1,
    output  [12:0]y_min1,
    output  [12:0]y_max1
    //output reg [4:0]x_num_x,
    //output reg [4:0]y_num_y
    //output count   //计字符数量
    );
    
    integer x_sum=1280;   //表示一行一共有多少数据
    integer y_sum=720;   //表示一列一共有多少数据
    //integer x_sum=10;   //表示一行一共有多少数据
    //integer y_sum=10;   //表示一列一共有多少数据
    //integer x_num=0;   //表示此时一行输入的数据数
    //integer y_num=0;   //表示此时输入了几列
  //  wire [12:0]x_num;
  //  wire [12:0]y_num;    
    //assign x_num=in_x_num;
   // assign y_num=in_y_num;
    //reg [4:0]x_num=0;   //表示此时一行输入的数据数
    //reg [4:0]y_num=0;   //表示此时输入了几列

    //reg [12:0]x_min1_1=15;
    reg [12:0]x_min1_1=490;
    reg [12:0]x_max1_1=790;
    reg [12:0]y_min1_1=210;
    //reg [12:0]y_min1_1=15;
    reg [12:0]y_max1_1=510;
    
    always@(posedge clk)begin
    //x_num_x=x_num;y_num_y=y_num;
        if(VSync==1);
        else begin
            if(HSync==1)begin
                if(VDE==1)begin
                    if(x_num>=x_sum-1);//这一行已经存满
                    else begin
                        if(Y==1'b1)begin
                            if(x_num<x_min1_1)begin
                                x_min1_1<=x_num;
                            end
                            else x_min1_1<=x_min1_1;
                            if(x_num>x_max1_1)begin
                                x_max1_1<=x_num;
                            end
                            else x_max1_1<=x_max1_1;
                            if(y_num<y_min1_1)begin
                                y_min1_1<=y_num;
                            end
                            else y_min1_1<=y_min1_1;
                            if(y_num>y_max1_1)begin
                                y_max1_1<=y_num;
                            end
                            else y_max1_1<=y_max1_1;
                            //x_num<=x_num+1;
                        end
                        else begin
                        //x_num<=x_num+1;
                        end
                    end
                end
                else;
            end
            else;
        end
    end
    
    assign x_min1=x_min1_1;
    assign x_max1=x_max1_1;
    assign y_min1=y_min1_1;
    assign y_max1=y_max1_1;
    
endmodule