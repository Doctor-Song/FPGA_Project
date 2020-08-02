module decode4_7 (codeout,indec,area_vaild);
input area_vaild;
input [3:0] indec;
output reg [6:0] codeout;

always@(indec)
    begin
	   case(indec)
	   4'd0: codeout=7'b1111110;
	   4'd1: codeout=7'b0110000;
	   4'd2: codeout=7'b1101101;
	   4'd3: codeout=7'b1111001;
	   4'd4: codeout=7'b0110011;
	   4'd5: codeout=7'b1011011;
	   4'd6: codeout=7'b1011111;
	   4'd7: codeout=7'b1110000;
	   4'd8: codeout=7'b1111111;
	   4'd9: codeout=7'b1111011;
	   default:  codeout=7'bx;
	   endcase
    end
	
endmodule
