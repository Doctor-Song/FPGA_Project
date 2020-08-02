module RGB888_YCbCr444
(
	//global clock
	input				clk,  				//cmos video pixel clock
	input				rst_n,				//global reset

	//Image data prepred to be processd
	input				per_frame_vsync,	//Prepared Image data vsync valid signal
	input				per_frame_href,		//Prepared Image data href vaild  signal
	input				per_frame_clken,	//Prepared Image data output/capture enable clock	
	input		[7:0]	per_img_red,		//Prepared Image red data to be processed
	input		[7:0]	per_img_green,		//Prepared Image green data to be processed
	input		[7:0]	per_img_blue,		//Prepared Image blue data to be processed
	input 		[10:0]	per_setx,
	input		[9:0]	per_sety,
	
	//Image data has been processd
	output				post_frame_vsync,	//Processed Image data vsync valid signal
	output				post_frame_href,	//Processed Image data href vaild  signal
	output				post_frame_clken,	//Processed Image data output/capture enable clock	
	output		[10:0]	post_setx,
	output		[9:0]	post_sety,
	output	reg	[7:0]	post_img_Y,			//Processed Image brightness output
	output	reg	[7:0]	post_img_Cb,		//Processed Image blue shading output
	output	reg	[7:0]	post_img_Cr			//Processed Image red shading output
);

//--------------------------------------------
/*********************************************
	Y 	=	(77 *R 	+ 	150*G 	+ 	29 *B)>>8
	Cb 	=	(-43*R	- 	85 *G	+ 	128*B + 32768)>>8
	Cr 	=	(128*R 	-	107*G  	-	21 *B + 32768)>>8
**********************************************/
//Step 1
reg	[15:0]	img_red_r0,		img_red_r1,		img_red_r2;	
reg	[15:0]	img_green_r0,	img_green_r1,	img_green_r2; 
reg	[15:0]	img_blue_r0,	img_blue_r1,	img_blue_r2; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		img_red_r0		<=	0; 		
		img_red_r1		<=	0; 		
		img_red_r2		<=	0; 	
		img_green_r0	<=	0; 		
		img_green_r1	<=	0; 		
		img_green_r2	<=	0; 	
		img_blue_r0		<=	0; 		
		img_blue_r1		<=	0; 		
		img_blue_r2		<=	0; 			
		end
	else
		begin
		img_red_r0		<=	per_img_red 	* 	8'd77; 		
		img_red_r1		<=	per_img_red 	* 	8'd43; 	
		img_red_r2		<=	per_img_red 	* 	8'd128; 		
		img_green_r0	<=	per_img_green 	* 	8'd150; 		
		img_green_r1	<=	per_img_green 	* 	8'd85; 			
		img_green_r2	<=	per_img_green 	* 	8'd107; 
		img_blue_r0		<=	per_img_blue 	* 	8'd29; 		
		img_blue_r1		<=	per_img_blue 	* 	8'd128; 			
		img_blue_r2		<=	per_img_blue 	* 	8'd21; 		
		end
end

//--------------------------------------------------
//Step 2
reg	[15:0]	img_Y_r0;	
reg	[15:0]	img_Cb_r0; 
reg	[15:0]	img_Cr_r0; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		img_Y_r0	<=	0; 		
		img_Cb_r0	<=	0; 		
		img_Cr_r0	<=	0; 	
		end
	else
		begin
		img_Y_r0	<=	img_red_r0 	+ 	img_green_r0 	+ 	img_blue_r0; 		
		img_Cb_r0	<=	img_blue_r1 - 	img_red_r1 		- 	img_green_r1	+	16'd32768; 		
		img_Cr_r0	<=	img_red_r2 	+ 	img_green_r2 	+ 	img_blue_r2		+	16'd32768; 		
		end
end

//--------------------------------------------------
//Step 3
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		post_img_Y	<=	0; 		
		post_img_Cb	<=	0; 		
		post_img_Cr	<=	0; 	
		end
	else
		begin
		post_img_Y	<=	img_Y_r0[15:8];
		post_img_Cb	<=	img_Cb_r0[15:8];
		post_img_Cr	<=	img_Cr_r0[15:8]; 
		end
end



//------------------------------------------
//lag 3 clocks signal sync  
reg	[2:0]	per_frame_vsync_r;
reg	[2:0]	per_frame_href_r;	
reg	[2:0]	per_frame_clken_r;
reg [2:0]	per_setx0_r;
reg [2:0]	per_setx1_r;
reg [2:0]	per_setx2_r;
reg [2:0]	per_setx3_r;
reg [2:0]	per_setx4_r;
reg [2:0]	per_setx5_r;
reg [2:0]	per_setx6_r;
reg [2:0]	per_setx7_r;
reg [2:0]	per_setx8_r;
reg [2:0]	per_setx9_r;
reg [2:0]	per_setx10_r;
reg [2:0]	per_sety0_r;
reg [2:0]	per_sety1_r;
reg [2:0]	per_sety2_r;
reg [2:0]	per_sety3_r;
reg [2:0]	per_sety4_r;
reg [2:0]	per_sety5_r;
reg [2:0]	per_sety6_r;
reg [2:0]	per_sety7_r;
reg [2:0]	per_sety8_r;
reg [2:0]	per_sety9_r;
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
		per_frame_vsync_r 	<= 	{per_frame_vsync_r[1:0], 	per_frame_vsync};
		per_frame_href_r 	<= 	{per_frame_href_r[1:0], 	per_frame_href};
		per_frame_clken_r 	<= 	{per_frame_clken_r[1:0], 	per_frame_clken};
		per_setx0_r			<=  {per_setx0_r[1:0],			per_setx[0]};
		per_setx1_r			<=  {per_setx1_r[1:0],			per_setx[1]};
		per_setx2_r			<=  {per_setx2_r[1:0],			per_setx[2]};
		per_setx3_r			<=  {per_setx3_r[1:0],			per_setx[3]};
		per_setx4_r			<=  {per_setx4_r[1:0],			per_setx[4]};
		per_setx5_r			<=  {per_setx5_r[1:0],			per_setx[5]};
		per_setx6_r			<=  {per_setx6_r[1:0],			per_setx[6]};
		per_setx7_r			<=  {per_setx7_r[1:0],			per_setx[7]};
		per_setx8_r			<=  {per_setx8_r[1:0],			per_setx[8]};
		per_setx9_r			<=  {per_setx9_r[1:0],			per_setx[9]};
		per_setx10_r		<=  {per_setx10_r[1:0],			per_setx[10]};
		per_sety0_r			<=  {per_sety0_r[1:0],			per_sety[0]};
		per_sety1_r			<=  {per_sety1_r[1:0],			per_sety[1]};
		per_sety2_r			<=  {per_sety2_r[1:0],			per_sety[2]};
		per_sety3_r			<=  {per_sety3_r[1:0],			per_sety[3]};
		per_sety4_r			<=  {per_sety4_r[1:0],			per_sety[4]};
		per_sety5_r			<=  {per_sety5_r[1:0],			per_sety[5]};
		per_sety6_r			<=  {per_sety6_r[1:0],			per_sety[6]};
		per_sety7_r			<=  {per_sety7_r[1:0],			per_sety[7]};
		per_sety8_r			<=  {per_sety8_r[1:0],			per_sety[8]};
		per_sety9_r			<=  {per_sety9_r[1:0],			per_sety[9]};
		end
end

assign	post_frame_vsync 	= 	per_frame_vsync_r[2];
assign	post_frame_href 	= 	per_frame_href_r[2];
assign	post_frame_clken 	= 	per_frame_clken_r[2];
assign 	post_setx[0]		=	per_setx0_r[2];
assign 	post_setx[1]		=	per_setx1_r[2];	
assign 	post_setx[2]		=	per_setx2_r[2];	
assign 	post_setx[3]		=	per_setx3_r[2];	
assign 	post_setx[4]		=	per_setx4_r[2];	
assign 	post_setx[5]		=	per_setx5_r[2];	
assign 	post_setx[6]		=	per_setx6_r[2];	
assign 	post_setx[7]		=	per_setx7_r[2];	
assign 	post_setx[8]		=	per_setx8_r[2];	
assign 	post_setx[9]		=	per_setx9_r[2];	
assign 	post_setx[10]		=	per_setx10_r[2];
assign  post_sety[0]		=	per_sety0_r[2];	
assign  post_sety[1]		=	per_sety1_r[2];		
assign  post_sety[2]		=	per_sety2_r[2];		
assign  post_sety[3]		=	per_sety3_r[2];		
assign  post_sety[4]		=	per_sety4_r[2];		
assign  post_sety[5]		=	per_sety5_r[2];		
assign  post_sety[6]		=	per_sety6_r[2];		
assign  post_sety[7]		=	per_sety7_r[2];		
assign  post_sety[8]		=	per_sety8_r[2];	
assign  post_sety[9]		=	per_sety9_r[2];			
endmodule
