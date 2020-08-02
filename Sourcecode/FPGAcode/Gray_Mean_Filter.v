module Gray_Mean_Filter
#(
	parameter	[11:0]	IMG_HDISP = 10'd1280,	//1280*720
	parameter	[11:0]	IMG_VDISP = 10'd720
)
(
	//global clock
	input				clk,  				//100MHz
	input				rst_n,				//global reset

	//Image data prepred to be processd
	input				per_frame_vsync,	//Prepared Image data vsync valid signal
	input				per_frame_href,		//Prepared Image data href vaild  signal
	input				per_frame_clken,	//Prepared Image data output/capture enable clock
	input		[7:0]	per_img_Y,			//Prepared Image brightness input
    input 		[10:0]	per_setx,
	input		[9:0]	per_sety,
	
	//Image data has been processd
    output		[10:0]	post_setx,
	output		[9:0]	post_sety,
	output				post_frame_vsync,	//Processed Image data vsync valid signal
	output				post_frame_href,	//Processed Image data href vaild  signal
	output				post_frame_clken,	//Processed Image data output/capture enable clock
	output		[7:0]	post_img_Y			//Processed Image brightness input
);



//----------------------------------------------------
//Generate 8Bit 3X3 Matrix for Video Image Processor.
	//Image data has been processd
wire				matrix_frame_vsync;	//Prepared Image data vsync valid signal
wire				matrix_frame_href;	//Prepared Image data href vaild  signal
wire				matrix_frame_clken;	//Prepared Image data output/capture enable clock	
wire        [10:0]  matrix_frame_setx;
wire        [9:0]   matrix_frame_sety;  
wire		[7:0]	matrix_p11, matrix_p12, matrix_p13;	//3X3 Matrix output
wire		[7:0]	matrix_p21, matrix_p22, matrix_p23;
wire		[7:0]	matrix_p31, matrix_p32, matrix_p33;
Matrix_Generate_3X3_8Bit	
#(
	.IMG_HDISP	(IMG_HDISP),	//640*480
	.IMG_VDISP	(IMG_VDISP)
)
u_Matrix_Generate_3X3_8Bit
(
	//global clock
	.clk					(clk),  				//cmos video pixel clock
	.rst_n					(rst_n),				//global reset

	//Image data prepred to be processd
	.per_frame_vsync		(per_frame_vsync),		//Prepared Image data vsync valid signal
	.per_frame_href			(per_frame_href),		//Prepared Image data href vaild  signal
	.per_frame_clken		(per_frame_clken),		//Prepared Image data output/capture enable clock
	.per_img_Y				(per_img_Y),			//Prepared Image brightness input
    .per_setx               (per_setx),
    .per_sety               (per_sety),
	//Image data has been processd
	.matrix_frame_vsync		(matrix_frame_vsync),	//Processed Image data vsync valid signal
	.matrix_frame_href		(matrix_frame_href),	//Processed Image data href vaild  signal
	.matrix_frame_clken		(matrix_frame_clken),	//Processed Image data output/capture enable clock	
    .post_setx(matrix_frame_setx),
    .post_sety(matrix_frame_sety),
	.matrix_p11(matrix_p11),	.matrix_p12(matrix_p12), 	.matrix_p13(matrix_p13),	//3X3 Matrix output
	.matrix_p21(matrix_p21), 	.matrix_p22(matrix_p22), 	.matrix_p23(matrix_p23),
	.matrix_p31(matrix_p31), 	.matrix_p32(matrix_p32), 	.matrix_p33(matrix_p33)
);


//Add you arithmetic here
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Mean Filter of 3X3 datas, need 2 clock
//Step 1
reg	[10:0]	mean_value1, mean_value2, mean_value3;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		mean_value1 <= 0;
		mean_value2 <= 0;
		mean_value3 <= 0;
		end
	else
		begin
		mean_value1 <= matrix_p11 + matrix_p12 + matrix_p13;
		mean_value2 <= matrix_p21 + 11'd0	   + matrix_p23;
		mean_value3 <= matrix_p31 + matrix_p32 + matrix_p33;
		end
end


//Step2
reg	[10:0]	mean_value4;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		mean_value4 <= 0;
	else
		mean_value4 <= mean_value1 + mean_value2 + mean_value3;
end

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
		per_frame_vsync_r 	<= 	{per_frame_vsync_r[0], 	matrix_frame_vsync};
		per_frame_href_r 	<= 	{per_frame_href_r[0], 	matrix_frame_href};
		per_frame_clken_r 	<= 	{per_frame_clken_r[0], 	matrix_frame_clken};
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
assign	post_frame_vsync 	= 	per_frame_vsync_r[1];
assign	post_frame_href 	= 	per_frame_href_r[1];
assign	post_frame_clken 	= 	per_frame_clken_r[1];
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
assign	post_img_Y			=	 mean_value4[10:3];


endmodule
