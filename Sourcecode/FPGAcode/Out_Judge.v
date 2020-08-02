`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/31 16:52:37
// Design Name: 
// Module Name: Out_Judge
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

module  Out_Judge(
    input [4:0]num,
    input clk,
    output  [23:0]RGB_Data,
    output RGB_HSync,
    output RGB_VSync,
    output RGB_VDE
);

wire [11:0]Set_X;
wire [11:0]Set_Y;
wire [23:0]RGB_In1;
wire [23:0]RGB_In2;
wire [23:0]RGB_In3;
wire [23:0]RGB_In4;
wire [23:0]RGB_In5;
wire [23:0]RGB_In6;
wire [23:0]RGB_In7;
wire [23:0]RGB_In8;
wire [23:0]RGB_In9;
wire [23:0]RGB_In0;

reg [23:0]RGB_IN;


Video_Generator1 Num1(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In1)
 );
 Video_Generator2 Num2(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In2)
 );
 Video_Generator3 Num3(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In3)
 );
 Video_Generator4 Num4(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In4)
 );
 Video_Generator5 Num5(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In5)
 );
 Video_Generator6 Num6(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In6)
 );
 Video_Generator7 Num7(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In7)
 );
 Video_Generator8 Num8(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In8)
 );
 Video_Generator9 Num9(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In9)
 );
 Video_Generator0 Num0(
.clk(clk), 
.RGB_VDE(RGB_VDE), 
.Set_X(Set_X), 
.Set_Y(Set_Y), 
.RGB_Data(RGB_In0)
 );

always@(posedge clk)
begin
  if(num==1'd0) RGB_IN <=RGB_In0;
  else if(num==4'd1) RGB_IN <=RGB_In1;
  else if(num==4'd2) RGB_IN <=RGB_In2;
  else if(num==4'd3) RGB_IN <=RGB_In3;
  else if(num==4'd4) RGB_IN <=RGB_In4;
  else if(num==4'd5) RGB_IN <=RGB_In5;
  else if(num==4'd6) RGB_IN <=RGB_In6;
  else if(num==4'd7) RGB_IN <=RGB_In7;
  else if(num==4'd8) RGB_IN <=RGB_In8;
  else if(num==4'd9) RGB_IN <=RGB_In9;
  else RGB_IN<=RGB_IN;
end

Driver_HDMI_0 Driver(
    .clk(clk),
    .Rst(1),
    .Video_Mode(0),
    .RGB_In(RGB_IN),
    .RGB_Data(RGB_Data),
    .RGB_HSync(RGB_HSync),
    .RGB_VSync(RGB_VSync),
    .RGB_VDE(RGB_VDE),
    .Set_X(Set_X),
    .Set_Y(Set_Y)
);

endmodule