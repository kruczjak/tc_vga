module vga(
	input clk,
	input button_red,
	input button_green,
	input button_blue,
	output reg red,
	output reg green,
	output reg blue,
	output hsync,
	output vsync
);

parameter F_CLK = 25175000;
parameter HSYNC = F_CLK/60;
parameter VSYNC = F_CLK/31500;
parameter X = 800;
parameter Y = 525;


//X ~ 32kHz
reg [9:0] CountX;
reg [9:0] CountY;
reg [23:0] CountA;
//wire Xmax = (CountX==VSYNC);


always @(posedge clk)
begin
if(CountX == X)
	CountX <= 0;
else
  CountX <= CountX + 1;
end
//Xend

always @(posedge clk)
begin
	if(CountA == F_CLK*500)
		CountA <= 0;
	else
		CountA <= CountA+1;
end

//Y ~ 60Hz
//wire Ymax = (CountY == HSYNC);
always @(posedge clk)
begin
	if (CountX == X)
		CountY <= CountY+1;
	else if (CountY == Y)
		CountY <= 0;
		
end
//-Y

//genrate hsync vsync
reg hsync_i, vsync_i;

always @(posedge clk)
begin
	hsync_i <= (CountX >= 656 & CountX < 752);
	vsync_i <= (CountY >= 490 & CountY <= 492);
end

reg animCounter =1;

always @(posedge clk)
begin
	if(CountA == 0)
	begin
		if (animCounter==0) animCounter=1;
		else animCounter=0;
	end
end

assign hsync = ~hsync_i;
assign vsync = ~vsync_i;


//assign red = CountX | (CountX == 256);
//assign green = (CountX[5]^CountX[6])|(CountX == 256);
//assign blue = CountX[4]|(CountX == 256);

always @(posedge clk)
begin
	if(button_red)
		red <= 100<CountY && 200> CountY && ((CountX>100 && CountX<200) || (CountX>400 && CountX<500));
	if(button_green && animCounter)
		green <= 300<CountY && 400> CountY && CountX>200 && CountX<400;
	if(button_blue)
		blue <= CountX[4];
end


endmodule
