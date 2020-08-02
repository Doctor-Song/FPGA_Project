`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/25 09:56:56
// Design Name: 
// Module Name: Camera_Demo
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


module DigitalRecognition(
    input i_clk,
    input i_rst,
    input i_clk_rx_data_n,
    input i_clk_rx_data_p,
    input [1:0]i_rx_data_n,
    input [1:0]i_rx_data_p,
    input i_data_n,
    input i_data_p,
    inout i_camera_iic_sda,
    output o_camera_iic_scl,
    output o_camera_gpio,
    output TMDS_Tx_Clk_N,
    output TMDS_Tx_Clk_P,
    output [2:0]TMDS_Tx_Data_N,
    output [2:0]TMDS_Tx_Data_P,
    output [9:0]codeout
    );
    //codeout
    assign codeout[7]=0;
    assign codeout[8]=0;
    assign codeout[9]=0;
    
    //时钟信号
    wire clk_100MHz_system;
    wire clk_200MHz;
    
    //HDMI信号
    wire [23:0]rgb_data_src;
    wire rgb_hsync_src;
    wire rgb_vsync_src;
    wire rgb_vde_src;
    wire clk_pixel;
    wire clk_serial;
    
    //RGB转灰度
    wire post_rgb2g_vsync;
    wire post_rgb2g_hsync;
    wire post_rgb2g_vde;
    wire [7:0]post_img_Y_gray;
    wire [7:0]post_img_Cb_gray;
    wire [7:0]post_img_Cr_gray;
    //坐标
    wire [10:0]setx;
    wire [9:0]sety;
    wire [10:0]per_setx;
    wire [9:0]per_sety;
    wire [10:0] post_filter_setx;
    wire [9:0]  post_filter_sety;
/*    //YCbCr2RGB
    wire post_g2rgb_vsync;
    wire post_g2rgb_hsync;
    wire post_g2rgb_vde;
    wire[7:0] post_g2rgb_R;
    wire[7:0] post_g2rgb_G;
    wire[7:0] post_g2rgb_B;*/
    //Filter
    wire post_filter_vsync;
    wire post_filter_hsync;
    wire post_filter_vde;
    wire[7:0]post_filter_Y_gray;
    wire number_bit;
//  assign  number_bit = (post_filter_Y_gray > 50)? 1'b1 : 1'b0 ;	
  assign  number_bit = (post_img_Y_gray > 30)? 1'b1 : 1'b0 ;	
    reg[23:0] bitRGB;
 //assign bitRGB= (number_bit==1)?24'hffffff:24'h000000;
    wire [12:0] x_min1;
    wire [12:0] x_max1;
    wire [12:0] y_min1;
    wire [12:0] y_max1;
   always@(*)
    begin
        if(post_filter_sety==110&&post_filter_setx>390&&post_filter_setx<890)
            begin
                bitRGB=24'b11111111_00000000_00000000;
            end
        else if(post_filter_sety==610&&post_filter_setx>390&&post_filter_setx<890)
            begin
                bitRGB=24'b11111111_00000000_00000000;
          end
         else if(post_filter_setx==390&&post_filter_sety>110&&post_filter_sety<610)
            begin
                bitRGB=24'b11111111_00000000_00000000;
            end
        else if(post_filter_setx==890&&post_filter_sety>110&&post_filter_sety<610)
            begin
                 bitRGB=24'b11111111_00000000_00000000;
            end
        else if(post_filter_sety==310&&post_filter_setx>390&&post_filter_setx<890)
            begin
                bitRGB=24'b00000000_11111111_00000000;
            end
        else if(post_filter_sety==443&&post_filter_setx>390&&post_filter_setx<890)
            begin
                 bitRGB=24'b00000000_11111111_00000000;
            end
        else if(post_filter_setx==640&&post_filter_sety>110&&post_filter_sety<610)
            begin
                 bitRGB=24'b00000000_00000000_11111111;
            end
        else
            begin
                bitRGB= (number_bit==1)?24'hffffff:24'h000000;
            end
    end
    //系统时钟
    clk_wiz_0 clk_10(.clk_out1(clk_100MHz_system),.clk_out2(clk_200MHz),.clk_in1(i_clk));
/*    Delay_Signal delay1(
    .clk_Signal(clk_pixel),
    .Rst(1'b1),
    .Signal_In(post_filter_vsync),
    .Delay_Num(2'd2),
    .Delay_Signal(post_filter_vsync_delay2)   
    );
     Delay_Signal delay2(
    .clk_Signal(clk_pixel),
    .Rst(1'b1),
    .Signal_In(post_filter_hsync),
    .Delay_Num(2'd2),
    .Delay_Signal(post_filter_hsync_delay2)   
    );
    Delay_Signal delay3(
    .clk_Signal(clk_pixel),
    .Rst(1'b1),
    .Signal_In(post_filter_vde),
    .Delay_Num(2'd2),
    .Delay_Signal(post_filter_vde_delay2)   
    );*/
    //HDMI驱动
    rgb2dvi_0 Mini_HDMI_Driver(
      .TMDS_Clk_p(TMDS_Tx_Clk_P),     // output wire TMDS_Clk_p
      .TMDS_Clk_n(TMDS_Tx_Clk_N),     // output wire TMDS_Clk_n
      .TMDS_Data_p(TMDS_Tx_Data_P),      // output wire [2 : 0] TMDS_Data_p
      .TMDS_Data_n(TMDS_Tx_Data_N),      // output wire [2 : 0] TMDS_Data_n
      .aRst_n(i_rst),                   // input wire aRst_n
      .vid_pData(bitRGB),         // input wire [23 : 0] vid_pData
      .vid_pVDE(post_rgb2g_vde),           // input wire vid_pVDE
      .vid_pHSync(post_rgb2g_hsync),       // input wire vid_pHSync
      .vid_pVSync(post_rgb2g_vsync),       // input wire vid_pVSync
      .PixelClk(clk_pixel)
    );
/*      rgb2dvi_0 Mini_HDMI_Driver(
      .TMDS_Clk_p(TMDS_Tx_Clk_P),     // output wire TMDS_Clk_p
      .TMDS_Clk_n(TMDS_Tx_Clk_N),     // output wire TMDS_Clk_n
      .TMDS_Data_p(TMDS_Tx_Data_P),      // output wire [2 : 0] TMDS_Data_p
      .TMDS_Data_n(TMDS_Tx_Data_N),      // output wire [2 : 0] TMDS_Data_n
      .aRst_n(i_rst),                   // input wire aRst_n
      .vid_pData(bitRGB),         // input wire [23 : 0] vid_pData
      .vid_pVDE(post_filter_vde),           // input wire vid_pVDE
      .vid_pHSync(post_filter_hsync),       // input wire vid_pHSync
      .vid_pVSync(post_filter_vsync),       // input wire vid_pVSync
      .PixelClk(clk_pixel)
    );*/
/*          rgb2dvi_0 Mini_HDMI_Driver(
          .TMDS_Clk_p(TMDS_Tx_Clk_P),     // output wire TMDS_Clk_p
          .TMDS_Clk_n(TMDS_Tx_Clk_N),     // output wire TMDS_Clk_n
          .TMDS_Data_p(TMDS_Tx_Data_P),      // output wire [2 : 0] TMDS_Data_p
          .TMDS_Data_n(TMDS_Tx_Data_N),      // output wire [2 : 0] TMDS_Data_n
          .aRst_n(i_rst),                   // input wire aRst_n
          .vid_pData(bitRGB),         // input wire [23 : 0] vid_pData
          .vid_pVDE(post_filter_vde_delay2),           // input wire vid_pVDE
          .vid_pHSync(post_filter_hsync_delay2),       // input wire vid_pHSync
          .vid_pVSync(post_filter_vsync_delay2),       // input wire vid_pVSync
          .PixelClk(clk_pixel)
        );*/
    
   
 
    
    //图像MIPI信号转RGB
    Driver_MIPI MIPI_Trans_Driver(
        .i_clk_200MHz(clk_200MHz),
        .i_clk_rx_data_n(i_clk_rx_data_n),
        .i_clk_rx_data_p(i_clk_rx_data_p),
        .i_rx_data_n(i_rx_data_n),
        .i_rx_data_p(i_rx_data_p),
        .i_data_n(i_data_n),
        .i_data_p(i_data_p),
        .o_camera_gpio(o_camera_gpio),
        .o_rgb_data(rgb_data_src),
        .o_rgb_hsync(rgb_hsync_src),
        .o_rgb_vsync(rgb_vsync_src),
        .o_rgb_vde(rgb_vde_src),
        .o_set_x(setx),
        .o_set_y(sety),
        .o_clk_pixel(clk_pixel)
    );
    
    //摄像头IIC的SDA线的三态节点
    wire camera_iic_sda_i;
    wire camera_iic_sda_o;
    wire camera_iic_sda_t;
    
    //Tri-state gate
    IOBUF Camera_IIC_SDA_IOBUF
       (.I(camera_iic_sda_o),
        .IO(i_camera_iic_sda),
        .O(camera_iic_sda_i),
        .T(~camera_iic_sda_t));
    
    //摄像头IIC驱动信号
    wire iic_busy;
    wire iic_mode;
    wire [7:0]slave_addr;
    wire [7:0]reg_addr_h;
    wire [7:0]reg_addr_l;
    wire [7:0]data_w;
    wire [7:0]data_r;
    wire iic_write;
    wire iic_read;
    wire ov5647_ack;
    
    
    //摄像头驱动
    OV5647_Init MIPI_Camera_Driver(
        .i_clk(clk_100MHz_system),
        .i_rst(i_rst),
        .i_iic_busy(iic_busy),
        .o_iic_mode(iic_mode),          
        .o_slave_addr(slave_addr),    
        .o_reg_addr_h(reg_addr_h),   
        .o_reg_addr_l(reg_addr_l),   
        .o_data_w(data_w),      
        .o_iic_write(iic_write),
        .o_ack(ov5647_ack)                 
    );
    
    //摄像头IIC驱动
    Driver_IIC MIPI_Camera_IIC(
        .i_clk(clk_100MHz_system),
        .i_rst(i_rst),
        .i_iic_sda(camera_iic_sda_i),
        .i_iic_write(iic_write),                //IIC写信号,上升沿有效
        .i_iic_read(iic_read),                  //IIC读信号,上升沿有效
        .i_iic_mode(iic_mode),                  //IIC模式,1代表双地址位,0代表单地址位,低位地址有效
        .i_slave_addr(slave_addr),              //IIC从机地址
        .i_reg_addr_h(reg_addr_h),              //寄存器地址,高8位
        .i_reg_addr_l(reg_addr_l),              //寄存器地址,低8位
        .i_data_w(data_w),                      //需要传输的数据
        .o_data_r(data_r),                      //IIC读到的数据
        .o_iic_busy(iic_busy),                  //IIC忙信号,在工作时忙,低电平忙
        .o_iic_scl(o_camera_iic_scl),           //IIC时钟线
        .o_sda_dir(camera_iic_sda_t),           //IIC数据线方向,1代表输出
        .o_iic_sda(camera_iic_sda_o)            //IIC数据线
    );
        
    //RGB转灰度
    

     RGB888_YCbCr444 my_RGB2G(
    .clk(clk_pixel),
    .rst_n(1'b1),
    .per_frame_vsync(rgb_vsync_src),
    .per_frame_href(rgb_hsync_src),    
    .per_frame_clken(rgb_vde_src),
    .per_img_red(rgb_data_src[23:16]),
    .per_img_green(rgb_data_src[15:8]),
    .per_img_blue(rgb_data_src[7:0]),
    .post_frame_vsync(post_rgb2g_vsync),
    .post_frame_href(post_rgb2g_hsync),
    .post_frame_clken(post_rgb2g_vde),
    .post_img_Y(post_img_Y_gray),
    .post_img_Cb(post_img_Cb_gray),
    .post_img_Cr(post_img_Cr_gray),
    .per_setx(setx),
    .per_sety(sety),
    .post_setx(per_setx),
    .post_sety(per_sety)
    );
    
//均值滤波
    
   Gray_Mean_Filter Gary_Filter(
    .clk(clk_pixel),  
    .rst_n(1'b1),
    .per_frame_vsync(post_rgb2g_vsync),
    .per_frame_href(post_rgb2g_hsync),    
    .per_frame_clken(post_rgb2g_vde),
    .per_img_Y(post_img_Y_gray), 
    .post_frame_vsync(post_filter_vsync),	
    .post_frame_href(post_filter_hsync),    
    .post_frame_clken(post_filter_vde),    
    .post_img_Y(post_filter_Y_gray),
    .per_setx(per_setx),
    .per_sety(per_sety),
    .post_setx(post_filter_setx),
    .post_sety(post_filter_sety)                  
    );
    
/*    //YCbCr2RGB
    YCbCr444_RGB888 Y2R(
        .clk(clk_pixel),
        .rst_n(1'b1),
        .per_frame_vsync(post_rgb2g_vsync),
        .per_frame_href(post_rgb2g_hsync),	
        .per_frame_clken(post_rgb2g_vde),
        .per_img_Y(post_img_Y_gray),
        .per_img_Cb(post_img_Cb_gray),
        .per_img_Cr(post_img_Cr_gray),
        .post_frame_vsync(post_g2rgb_vsync),
        .post_frame_href(post_g2rgb_hsync),
        .post_frame_clken(post_g2rgb_vde),
        .post_img_red(post_g2rgb_R),	
        .post_img_green(post_g2rgb_G),
        .post_img_blue(post_g2rgb_B)	
    );*/
    
 

    //图像分割
 /*   Charactor_Divide cha_div(
    .clk(clk_pixel),
    .Y(~number_bit),  
    .HSync(1'b1),
    .VSync(post_filter_vsync),
    .VDE(post_filter_vde),  
    .x_min1(x_min1),
    .x_max1(x_max1),
    .y_min1(y_min1),
    .y_max1(y_max1),
    .x_num(per_setx),
    .y_num(per_sety)
    ); */
    //图像处理
   /* wire [4:0] number;
    Charator_Distinguish cha_dis(
    .clk(clk_pixel),  
    .Y(~number_bit),  
    .HSync(1'b1),
    .VSync(post_filter_vsync),
    .VDE(post_filter_vde),
    .x_min1(x_min1),
    .x_max1(x_max1),
    .y_min1(y_min1),
    .y_max1(y_max1),
    .x_intersect_num(), 
    .y1_intersect_num(),
    .y2_intersect_num(),
    .y1_situation(), 
    .y2_situation(),
    .number(number) 
    );*/

/*wire pic_en1 ; 
wire pic_en2 ; 
wire pic_en3 ; 
wire pic_en4 ; 
//wire pic_en5 ;
	
	
reg         vsync_r0;
reg         vsync_r1;
wire   		vsync_fall;
wire        vsync;
wire			area_vaild1;
wire			area_vaild2;
wire			area_vaild3;
wire			area_vaild4;
wire [9:0] 		scany1 ;
wire [9:0] 		scany2 ;	 
wire [10:0] 	scanx1 ;
wire [10:0] 	scanx2 ;
wire [10:0] 	scanx3 ;
wire [10:0] 	scanx4 ;
wire [10:0] 	x_min1 ;
wire [10:0] 	x_max1 ;
wire [10:0] 	x_min2 ;
wire [10:0] 	x_max2 ;
wire [10:0] 	x_min3 ;
wire [10:0] 	x_max3 ;
wire [10:0] 	x_min4 ;
wire [10:0] 	x_max4 ;
wire [9:0] 		y_min ;
wire [9:0] 		y_max ;	
assign vsync = rgb_vsync_src;
always @(posedge clk_pixel	 ) begin
  vsync_r0 <= vsync;
  vsync_r1 <= vsync_r0;
end
   position u_position (
    .clk				(clk_pixel				), 
    .rst_n				(1'b1	), 
    .ie					(rgb_vde_src	), 
    .hcnt				(setx						), 
    .vcnt				(sety						), 
    .idat				(~number_bit				),  
	 .area_vaild1		(area_vaild1				), 
	 .area_vaild2		(area_vaild2				),
	 .area_vaild3		(area_vaild3				),
	 .area_vaild4		(area_vaild4				),
//	 .area_vaild5		(area_vaild5				),	 
    .vga_vsync1		(post_filter_vsync	), 
    .vga_hsync1		(post_filter_hsync	), 
	 .vsync_fall		(vsync_fall					),
	 .post_img_Y_mean	(post_img_Y_gray			),   
	 .vga_r1				(), 	 
	 .vga_g1				(), 
	 .vga_b1				(), 
//		.vga_r1				({number_bit,number_bit,number_bit,number_bit,number_bit}	), 
//		.vga_g1				({number_bit,number_bit,number_bit,number_bit,number_bit,number_bit}	),  
//		.vga_b1				({number_bit,number_bit,number_bit,number_bit,number_bit}	), 
	.vga_vsync			(			), 
    .vga_hsync			(     		), 
    .scany1				(scany1					), 
    .scany2				(scany2					), 
    .scanx1				(scanx1					), 
	 .scanx2				(scanx2					), 
	 .scanx3				(scanx3					), 
	 .scanx4				(scanx4			   	), 
//	 .scanx5				(scanx5				   ),	 
    .y_min				(y_min					), 
    .y_max				(y_max					), 
    .x_min1				(x_min1					), 
    .x_max1		      (x_max1					), 
	 .x_min2				(x_min2					), 
    .x_max2				(x_max2					), 
	 .x_min3				(x_min3					), 
    .x_max3				(x_max3					), 
	 .x_min4				(x_min4					), 
    .x_max4				(x_max4					), 
//	 .x_min5				(x_min5			   	), 
//   .x_max5				(x_max5					), 
    .vga_r				(			), 
    .vga_g				(			), 
    .vga_b				(			),
	.rom_data1			(			),
	.rom_data2			(			),
	.rom_data3			(			),
	.rom_data4			(			),
//	.rom_data5			(rom_data5				),	
	.pic_en1			   (pic_en1					),
	.pic_en2				(pic_en2					),
	.pic_en3				(pic_en3					),
	.pic_en4				(pic_en4					)
//	.pic_en5				(pic_en5				   )

    );
    wire [3:0]number;
   identf_number u_identf_number1 (
    .clk				(clk_pixel				), 
    .rst_n				(1'b1	), 
    .scany1				(scany1					), 
    .scany2				(scany2					), 
    .scanx				(scanx1					), 
    .y_min				(y_min					), 
    .y_max				(y_max					), 
    .x_min				(x_min1					), 
    .x_max				(x_max1					), 
    .vcnt				(sety					), 
    .hcnt				(setx					), 
    .Bit			   	(~number_bit			),
	 .area_vaild		(area_vaild1			),
    .number			   (number					)
    );*/
    wire[3:0] number;
    identf_number idnum(
    .clk(clk_pixel),
    .rst_n(1'b1),
    .hcnt(per_setx),
    .vcnt(per_sety),
    .Bit(~number_bit),
    .area_vaild(),
    .number(number)
    );
    
   decode4_7 decode(
   .indec(number),
   .codeout(codeout)
   );
    
endmodule
