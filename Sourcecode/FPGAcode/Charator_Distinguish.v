`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 21:13:49
// Design Name: 
// Module Name: Charator_Distinguish
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


module Charator_Distinguish(
    input clk,   //时钟信号
    input Y,   //二值化处理后的像素值
    input HSync,   //Line signal(高电平有效)
    input VSync,   //Field signal(高电平有效)
    input VDE,   //Data valid signal(高电平有效，高电平时读取数据)
    input  [12:0]x_min1,
    input  [12:0]x_max1,
    input  [12:0]y_min1,
    input  [12:0]y_max1,
    output [1:0]x_intersect_num,   //与x的相交点数
    output [1:0]y1_intersect_num,   //与y1的相交点数
    output [1:0]y2_intersect_num,   //与y2的相交点数
    output y1_situation,   //输出y1相对于x的位置(0：左边，1：右边)
    output y2_situation,   //输出y2相对于x的位置(0：左边，1：右边)
    output reg [4:0]number   //输出该字符是0-9里面的几
    //output [5:0]xx,
    //output [5:0]yy1,
    //output [5:0]yy2,
    //output [4:0]x_num_x,
    //output [4:0]y_num_y,
    //output [3:0]y_first_y1,
    //output [3:0]y_first_y2
    );
    
    integer x_sum=1280;   //表示一行一共有多少数据
    integer y_sum=720;   //表示一列一共有多少数据
    integer x_num=0;   //表示此时一行输入的数据数
    integer y_num=0;   //表示此时输入了几列    
    wire [12:0]x;
    wire [20:0]y1;
    wire [20:0]y2;
    
    assign x=(x_min1+x_max1)>>1;   //线x的位置(1/2)
    assign y1=y_min1+(((y_max1-y_min1)*400)>>10);   //线y1的位置(2/5)
    assign y2=y_min1+(((y_max1-y_min1)*683)>>10);   //线y2的位置(2/3)
    //assign xx=x;
    //assign yy1=y1;
    //assign yy2=y2;
    
    reg [1:0]x_x=2'b00;   //寄存器
    reg [1:0]y_y1=2'b00;   //寄存器
    reg [1:0]y_y2=2'b00;   //寄存器
    
    integer x_x_num=0;   //记录与x交点数
    integer y_y1_num=0;   //记录与y1交点数
    integer y_y2_num=0;   //记录与y2交点数
    
    //integer x_first=0;   //记录x列第一个1的位置
    integer y1_first=0;   //记录y1行第一个1的位置
    integer y2_first=0;   //记y2x行第一个1的位置
    
    always@(posedge clk)begin   //字符识别
        if(VSync==1)begin
            x_num<=1'b0;y_num<=1'b0;x_x<=2'b00;y_y1<=2'b00;y_y2<=2'b00;
        end
        else begin
           if(HSync==1)begin
               if(VDE==1)begin
                    if(x_num>=x_sum-1)begin   //这一行已经存满
                        x_num<=1'b0;y_num<=y_num+1;
                    end
                    else begin
                        if(x_num==x)begin
                            x_x={x_x[0],Y};
                            if(Y==1)begin
                                if(x_x[1]==0)begin
                                    x_x_num<=x_x_num+1;
                                end
                                else;
                            end
                            else;
                        end
                        if(y_num==y1)begin
                            y_y1={y_y1[0],Y};
                            if(Y==1)begin
                                if(y_y1_num==0)begin
                                    y1_first<=x_num;
                                end
                                else;
                                if(y_y1[1]==0)begin
                                    y_y1_num<=y_y1_num+1;
                                end
                                else;
                            end
                            else;
                        end
                        if(y_num==y2)begin
                            y_y2={y_y2[0],Y};
                            if(Y==1)begin
                                if(y_y2_num==0)begin
                                    y2_first<=x_num;
                                end
                                else;
                                if(y_y2[1]==0)begin
                                    y_y2_num<=y_y2_num+1;
                                end
                                else;
                            end
                            else;
                        end
                        x_num<=x_num+1;
                    end
               end
               else;
           end
           else;
        end
    end
    
    assign x_intersect_num=x_x_num;
    assign y1_intersect_num=y_y1_num;
    assign y2_intersect_num=y_y2_num;
    assign y1_situation=(y1_first<x)?1'b0:1'b1;
    assign y2_situation=(y2_first<x)?1'b0:1'b1;
    //assign x_num_x=x_num;
    //assign y_num_y=y_num;
    //assign y_first_y1=y1_first;
    //assign y_first_y2=y2_first;
    always@(posedge clk)begin
        if(y_num==700)begin
            if(x_intersect_num==2&&y1_intersect_num==2&&y2_intersect_num==2)begin
                number<='d0;
            end
            else if(x_intersect_num==1&&y1_intersect_num==1&&y2_intersect_num==1)begin
                number<='d1;
            end
            else if(x_intersect_num==2&&y1_intersect_num==1&&y2_intersect_num==2)begin
                number<='d4;
            end
            else if(x_intersect_num==1&&y1_intersect_num==2&&y2_intersect_num==3)begin
                number<='d6;
            end
            else if(x_intersect_num==1&&y1_intersect_num==1&&y2_intersect_num==2)begin
                number<='d7;
            end
            else if(x_intersect_num==2&&y1_intersect_num==2&&y2_intersect_num==3)begin
                number<='d8;
            end
            else if(x_intersect_num==2&&y1_intersect_num==1&&y2_intersect_num==3)begin
                number<='d9;
            end
            else if(x_intersect_num==1&&y1_intersect_num==1&&y2_intersect_num==3)begin
                if(y1_situation==1&&y2_situation==0)begin
                    number<='d2;
                end
                if(y1_situation==1&&y2_situation==1)begin
                    number<='d3;
                end
                if(y1_situation==0&&y2_situation==1)begin
                    number<='d5;
                end
            end
        end
        else begin
            number<=number;
        end
    end
        
endmodule
