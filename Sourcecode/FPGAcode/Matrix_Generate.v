`timescale 1ns/1ns
module Matrix_Generate_3X3_8Bit
#(
	parameter	[11:0]	IMG_HDISP = 10'd1280,	//1280*720
	parameter	[11:0]	IMG_VDISP = 10'd720
)
(
	//global clock
	input				clk,  				//mipi video pixel clock
	input				rst_n,				//global reset

	//Image data prepred to be processd
	input				per_frame_vsync,	//Prepared Image data vsync valid signal
	input				per_frame_href,		//Prepared Image data href vaild  signal
	input				per_frame_clken,	//Prepared Image data output/capture enable clock
	input		[7:0]	per_img_Y,			//Prepared Image brightness input
	input 		[10:0]	per_setx,
	input		[9:0]	per_sety,

	output		[10:0]	post_setx,
	output		[9:0]	post_sety,
	//Image data has been processd
	output				matrix_frame_vsync,	//Prepared Image data vsync valid signal
	output				matrix_frame_href,	//Prepared Image data href vaild  signal
	output				matrix_frame_clken,	//Prepared Image data output/capture enable clock	
	output	reg	[7:0]	matrix_p11, matrix_p12, matrix_p13,	//3X3 Matrix output
	output	reg	[7:0]	matrix_p21, matrix_p22, matrix_p23,
	output	reg	[7:0]	matrix_p31, matrix_p32, matrix_p33

);


//Generate 3*3 matrix 
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//sync row3_data with per_frame_clken & row1_data & raw2_data
wire	[7:0]	row1_data;	//frame data of the 1th row
wire	[7:0]	row2_data;	//frame data of the 2th row
reg		[7:0]	row3_data;	//frame data of the 3th row
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		row3_data <= 0;
	else 
		begin
		if(per_frame_clken)
			row3_data <= per_img_Y;
		else
			row3_data <= row3_data;
		end	
end

//---------------------------------------
//module of shift ram for raw data
wire	shift_clk_en = per_frame_clken;

wire row20_data;
wire row10_data;

c_shift_ram_0 u1(
    .D(row3_data),
    .CLK(clk),
    .CE(shift_clk_en),
    .Q(row20_data)
);
c_shift_ram_0 u2(
    .D(row20_data),
    .CLK(clk),
    .CE(shift_clk_en),
    .Q(row2_data)
);
c_shift_ram_0 u3(
    .D(row2_data),
    .CLK(clk),
    .CE(shift_clk_en),
    .Q(row10_data)
);
c_shift_ram_0 u4(
    .D(row3_data),
    .CLK(clk),
    .CE(shift_clk_en),
    .Q(row1_data)
);


/*
Line_Shift_RAM_8Bit u1 (
  .d(row3_data), // input [7 : 0] d
  .clk(clk), // input clk
  .ce(shift_clk_en), // input ce
  .q(row2_data) // output [7 : 0] q
);
Line_Shift_RAM_8Bit u2 (
  .d(row2_data), // input [7 : 0] d
  .clk(clk), // input clk
  .ce(shift_clk_en), // input ce
  .q(row1_data) // output [7 : 0] q
);*/
//------------------------------------------
//lag 2 clocks signal sync  
reg	[1:0]	per_frame_vsync_r;
reg	[1:0]	per_frame_href_r;	
reg	[1:0]	per_frame_clken_r;
reg [1:0]	per_setx0_r;
reg [1:0]	per_setx1_r;
reg [1:0]	per_setx2_r;
reg [1:0]	per_setx3_r;
reg [1:0]	per_setx4_r;
reg [1:0]	per_setx5_r;
reg [1:0]	per_setx6_r;
reg [1:0]	per_setx7_r;
reg [1:0]	per_setx8_r;
reg [1:0]	per_setx9_r;
reg [1:0]	per_setx10_r;
reg [1:0]	per_sety0_r;
reg [1:0]	per_sety1_r;
reg [1:0]	per_sety2_r;
reg [1:0]	per_sety3_r;
reg [1:0]	per_sety4_r;
reg [1:0]	per_sety5_r;
reg [1:0]	per_sety6_r;
reg [1:0]	per_sety7_r;
reg [1:0]	per_sety8_r;
reg [1:0]	per_sety9_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		per_frame_vsync_r <= 0;
		per_frame_href_r <= 0;
		per_frame_clken_r <= 0;
		per_setx0_r<=0;
		per_setx1_r<=0;
		per_setx2_r<=0;
		per_setx3_r<=0;
		per_setx4_r<=0;
		per_setx5_r<=0;
		per_setx6_r<=0;
		per_setx7_r<=0;
		per_setx8_r<=0;
		per_setx9_r<=0;
		per_setx10_r<=0;
		per_sety0_r<=0;
		per_sety1_r<=0;
		per_sety2_r<=0;
		per_sety3_r<=0;
		per_sety4_r<=0;
		per_sety5_r<=0;
		per_sety6_r<=0;
		per_sety7_r<=0;
		per_sety8_r<=0;
		per_sety9_r<=0;
		end
	else
		begin
		per_frame_vsync_r 	<= 	{per_frame_vsync_r[0], 	per_frame_vsync};
		per_frame_href_r 	<= 	{per_frame_href_r[0], 	per_frame_href};
		per_frame_clken_r 	<= 	{per_frame_clken_r[0], 	per_frame_clken};
		per_setx0_r			<=  {per_setx0_r[0],			per_setx[0]};
		per_setx1_r			<=  {per_setx1_r[0],			per_setx[1]};
		per_setx2_r			<=  {per_setx2_r[0],			per_setx[2]};
		per_setx3_r			<=  {per_setx3_r[0],			per_setx[3]};
		per_setx4_r			<=  {per_setx4_r[0],			per_setx[4]};
		per_setx5_r			<=  {per_setx5_r[0],			per_setx[5]};
		per_setx6_r			<=  {per_setx6_r[0],			per_setx[6]};
		per_setx7_r			<=  {per_setx7_r[0],			per_setx[7]};
		per_setx8_r			<=  {per_setx8_r[0],			per_setx[8]};
		per_setx9_r			<=  {per_setx9_r[0],			per_setx[9]};
		per_setx10_r		<=  {per_setx10_r[0],			per_setx[10]};
		per_sety0_r			<=  {per_sety0_r[0],			per_sety[0]};
		per_sety1_r			<=  {per_sety1_r[0],			per_sety[1]};
		per_sety2_r			<=  {per_sety2_r[0],			per_sety[2]};
		per_sety3_r			<=  {per_sety3_r[0],			per_sety[3]};
		per_sety4_r			<=  {per_sety4_r[0],			per_sety[4]};
		per_sety5_r			<=  {per_sety5_r[0],			per_sety[5]};
		per_sety6_r			<=  {per_sety6_r[0],			per_sety[6]};
		per_sety7_r			<=  {per_sety7_r[0],			per_sety[7]};
		per_sety8_r			<=  {per_sety8_r[0],			per_sety[8]};
		per_sety9_r			<=  {per_sety9_r[0],			per_sety[9]};
		end
end
//Give up the 1th and 2th row edge data caculate for simple process
//Give up the 1th and 2th point of 1 line for simple process
wire	read_frame_href		=	per_frame_href_r[0];	//RAM read href sync signal
wire	read_frame_clken	=	per_frame_clken_r[0];	//RAM read enable
assign	matrix_frame_vsync 	= 	per_frame_vsync_r[1];
assign	matrix_frame_href 	= 	per_frame_href_r[1];
assign	matrix_frame_clken 	= 	per_frame_clken_r[1];
assign 	post_setx[0]		=	per_setx0_r[1];
assign 	post_setx[1]		=	per_setx1_r[1];	
assign 	post_setx[2]		=	per_setx2_r[1];	
assign 	post_setx[3]		=	per_setx3_r[1];	
assign 	post_setx[4]		=	per_setx4_r[1];	
assign 	post_setx[5]		=	per_setx5_r[1];	
assign 	post_setx[6]		=	per_setx6_r[1];	
assign 	post_setx[7]		=	per_setx7_r[1];	
assign 	post_setx[8]		=	per_setx8_r[1];	
assign 	post_setx[9]		=	per_setx9_r[1];	
assign 	post_setx[10]		=	per_setx10_r[1];
assign  post_sety[0]		=	per_sety0_r[1];	
assign  post_sety[1]		=	per_sety1_r[1];		
assign  post_sety[2]		=	per_sety2_r[1];		
assign  post_sety[3]		=	per_sety3_r[1];		
assign  post_sety[4]		=	per_sety4_r[1];		
assign  post_sety[5]		=	per_sety5_r[1];		
assign  post_sety[6]		=	per_sety6_r[1];		
assign  post_sety[7]		=	per_sety7_r[1];		
assign  post_sety[8]		=	per_sety8_r[1];	
assign  post_sety[9]		=	per_sety9_r[1];		


//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
/******************************************************************************
					----------	Convert Matrix	----------
				[ P31 -> P32 -> P33 -> ]	--->	[ P11 P12 P13 ]	
				[ P21 -> P22 -> P23 -> ]	--->	[ P21 P22 P23 ]
				[ P11 -> P12 -> P11 -> ]	--->	[ P31 P32 P33 ]
******************************************************************************/
//---------------------------------------------------------------------------
//---------------------------------------------------
/***********************************************
	(1)	Read data from Shift_RAM
	(2) Caculate the Sobel
	(3) Steady data after Sobel generate
************************************************/
//wire	[23:0]	matrix_row1 = {matrix_p11, matrix_p12, matrix_p13};	//Just for test
//wire	[23:0]	matrix_row2 = {matrix_p21, matrix_p22, matrix_p23};
//wire	[23:0]	matrix_row3 = {matrix_p31, matrix_p32, matrix_p33};
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		{matrix_p11, matrix_p12, matrix_p13} <= 24'h0;
		{matrix_p21, matrix_p22, matrix_p23} <= 24'h0;
		{matrix_p31, matrix_p32, matrix_p33} <= 24'h0;
		end
	else if(read_frame_clken)	//Shift_RAM data read clock enable
		begin
		{matrix_p11, matrix_p12, matrix_p13} <= {matrix_p12, matrix_p13, row1_data};	//1th shift input
		{matrix_p21, matrix_p22, matrix_p23} <= {matrix_p22, matrix_p23, row2_data};	//2th shift input
		{matrix_p31, matrix_p32, matrix_p33} <= {matrix_p32, matrix_p33, row3_data};	//3th shift input
		end
	else
		begin
		{matrix_p11, matrix_p12, matrix_p13} <= {matrix_p11, matrix_p12, matrix_p13};
		{matrix_p21, matrix_p22, matrix_p23} <= {matrix_p21, matrix_p22, matrix_p23};
		{matrix_p31, matrix_p32, matrix_p33} <= {matrix_p31, matrix_p32, matrix_p33};
		end	
end

endmodule
