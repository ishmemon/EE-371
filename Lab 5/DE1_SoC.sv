/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];
	
	//Define all the logics we will be using.
	logic [10:0] x0, y0, x1, y1, x, y;
	logic reset, check_reset;
	logic colour, clearScreen;
	logic colr_of_screen;
	
	//Assign the key1 to be reset and clearscreen to be switch 1. That way they are the same number. I also assign 
	//a color of screen variable and a color variable. The coloir will be used in the VGA port and the colr_of_screen
	//is basically a second variable that automatically goes to 0 if reset is asserted. The colour switches when
	//clearScreen is asserted so we can erase by basically drawing in the opposite color
	assign reset = KEY[1];
	assign clearScreen = SW[1];
	assign colr_of_screen = reset? 1'b0 : colour;
	assign colour = clearScreen? 1'b0 : 1'b1;
	
	//We instantiate the line drawer place in fixed (x0, y0) and the x1, y1 changes.
	line_drawer lines (.clk(clk), .reset(reset), 
	.x0(20), .y0(20), .x1, .y1, .x, .y);
	
	
	//Clock divider algorithm copied form 271
	logic [31:0] divided;
	always_ff @(posedge CLOCK_50) begin  
        divided <= divided + 1;   
    end  
	parameter whichClock = 17;  
	//  Clock  selection;  allows  for  easy  switching  between  simulation  and  board clocks 
	logic clk; 
	// Uncommet ONE of the following two lines depending on intention 
	//assign clk = CLOCK_50;          // for simulation 
	assign clk = divided[whichClock]; // for board
	
	//The instantiation of the VGA
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color   (colour), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
			 
	//assign x1 = reset? 11'd20 : (x1 + 100);
	//assign y1 = reset? 11'd20 : (y1 + 10);
	
	always_ff @(posedge clk) begin
		//We change x1 and y1 by different values which allows us to have the dashed line animation
		//These different if statments lead to different drawings we can chose 1 to finalize 
		//if (~reset) begin y1 <= (y1 < 10)? (y1 + 91) : (y1 + 14); x1 <= (x1 < 10)? (x1 + 91) : (x1 + 14);
		//if (~reset) begin y1 <= y1 + 10; x1 <= (x1 < 10)? (x1 + 91) : (x1 + 14);
		if (~reset) begin y1 <= y1 + 1; x1 <= x1 + 1;
		//This allows us to go back to the start and start drawing again if reset is asserted
		end else begin y1 <= 20; x1 <= 20;   
		end 
	end
			

endmodule  // DE1_SoC
