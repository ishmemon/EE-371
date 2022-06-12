//This will be top level it contains both task 1 and 2 code and a swithc input that 
//allows switch 9 to control the two.
module DE1_SoC (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, SW,
				  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
				  VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
				  
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	//Edited was not in default
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;

	
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
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
	
	
	//Assign the logics for the clock display and the alarm time and then call those
	//modules
	logic [16:0] count_clock;
	logic ring;
	universal_clock uc (.clk, .reset, .count_clock);
	//The hexes need to be swapped other wise the numbers are backwards. 
	display_clock dc (.count_clock, .HEX0(HEX1), .HEX1(HEX0), .HEX2(HEX3), .HEX3(HEX2));
	alarm_time (.clk, .SW(SW[6:0]), .count_clock, .ring);
	
	//This will light led9 when the alarm goes off.
	assign LEDR[9] = ring;
	
	//4 logics 2 for each task and then we use a control switche (sw9) to toggle which one
	//is displayed.
	logic [23:0] writedata_left1;
	logic [23:0] writedata_right1;
	logic [23:0] writedata_left2;
	logic [23:0] writedata_right2;
	

	
	//TASK 2
	logic [12:0] address;
	logic [23:0] q_out;
	always_ff @(posedge CLOCK_50) begin
	    if(reset) address <= 0;
		else begin
			address <= address + 1;
		end
	end 
	logic clock;
	assign clock = CLOCK_50;
	
	//I created six roms so we have a different note that each of them stores and their
	//outputs are 6 different ones that we cycle through.
	
	//Something must be fixed here since when we have the q_out and writedata_left2 attached to the output 
	//of the rom it works but if the intermediate variables are there it does not. To fix that all we had to do
	//was not make the writedata's signed.
	logic [23:0] q_out1, q_out2, q_out3, q_out4, q_out5, q_out6;
	rom_1_port rom1 (.address, .clock, .q(q_out1));
	secondrom rom2 (.address, .clock, .q(q_out2));
	thirdrom rom3 (.address, .clock, .q(q_out3));
	fourthrom rom4 (.address, .clock, .q(q_out4));
	fifthrom rom5 (.address, .clock, .q(q_out5));
	sixthrom rom6 (.address, .clock, .q(q_out6));
	
	//This soundmix module goes through the notes and cycles through them it takes
	//the slow clock so the changes are audible. The difference between the two sounds
	//the user can chose (q_out and writedata_left2) is the that one is six notes and one is just 2 notes.
	soundmix sm (.clk, .reset, .q_out1, .q_out2, .q_out3, .q_out4, .q_out5, .q_out6, .q_out);
	soundmix sm2 (.clk, .reset, .q_out1(q_out3), .q_out2(q_out3), .q_out3(q_out3), .q_out4(q_out6), 
	.q_out5(q_out6), .q_out6(q_out6), .q_out(writedata_left2));
	
	//assign q_out = q_out5;
	//assign writedata_left2 = q_out1;
	assign writedata_left1 = q_out;
	
	//TASK 1
	
	//assign writedata_left2 = readdata_left;
	
	
	
	//Read and write always the same
	assign read = read_ready & write_ready & ring;
	assign write = write_ready & read_ready & ring;
	
	//Use sw9 (controlswithc) and sw8 to toggle between the two. if control swithc then
	//we chose between either task 1 or task 2 audio and the controlswithch3 tells us
	//whether its filtered or unfiltered.
	


    assign writedata_left = SW[9] ? writedata_left2 : q_out;
    assign writedata_right = writedata_left;
	 
	 
//Define all the logics we will be using for the vga.
	/*logic [10:0] x0, y0, x1, y1, x, y;
	logic check_reset;
	logic colour, clearScreen;
	logic colr_of_screen;
	
  
  	//Clearscreen to be sw 8. I also assign 
	//a color of screen variable and a color variable. The coloir will be used in the VGA port and the colr_of_screen
	//is basically a second variable that automatically goes to 0 if reset is asserted. The colour switches when
	//clearScreen is asserted so we can erase by basically drawing in the opposite color
	assign clearScreen = SW[8];
	assign colr_of_screen = reset? 1'b0 : colour;
	assign colour = clearScreen? 1'b0 : 1'b1;
	
	//We instantiate the line drawer place in fixed (x0, y0) and the x1, y1 changes.
	line_drawer lines (.clk(clk), .reset(reset), 
	.x0(20), .y0(20), .x1, .y1, .x, .y);
	
	 
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
		
		//CURRENT STATUS NO PATTERNS DRAWN JUST ONE DOT SO FIX THAT ALSO FIND SOMEWAY
		//FOR THE THING TO AUTO CHANGE COLOR (FROM WHITE TO BLACK)
	   //	SO WE CAN ERASE TOO IN THE 30 EDGES WE
		//HAVE MAYBE EVEN FSM FOR IT. ALSO THE AUDIO NEEDS TO BE DONE. HONESTLY
		//WE CAN JUST MAKE THE USER RESET IT THEMSELVES AND CLEAR THE SCREEN WE ALREADY
		//HAVE SW9 FOR IT. THAT IS WHAT IS DOING RN.
		
	//This allows us to draw patterns
	always_ff @(posedge clk) begin
		//We change x1 and y1 by different values which allows us to have the dashed line animation
		//These different if statments lead to different drawings we can chose 1 to finalize 
		//if (~reset) begin y1 <= (y1 < 10)? (y1 + 91) : (y1 + 14); x1 <= (x1 < 10)? (x1 + 91) : (x1 + 14);
		//if (~reset) begin y1 <= y1 + 10; x1 <= (x1 < 10)? (x1 + 91) : (x1 + 14);
		if ((~reset) & ring) begin 
		    //if (y1 > 20 & y1 < 30) begin
		      //  x1 = 0;
		       // y1 = y1+1;
		    //end else 
		    if (x1 > 40 & x1 < 80) begin
		        y1 = y1 + 10;
		        x1 = x1 + 1;
		    //end else if (x1 > 80 & x1 < 120) begin
		    end else if (x1 > 80 & x1 < 120) begin
		        y1 = y1 - 10;
		        x1 = x1 + 1;
		    end else begin
		        y1 = y1 + 1;
		        x1 = x1 + 10;
		    end
		    //end else begin
		        y1 = y1 + 1; x1 = x1 + 1;
		    //end
		//This allows us to go back to the start and start drawing again if reset is asserted
		end else begin y1 <= 20; x1 <= 20;   
		end 
	end*/
	
	
	
	//New updated vga code.
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
		enum { draw, clear} ps, ns;
	
	always_comb begin
	    case(ps)
	        //if (ring) begin 
	            draw: ns = ring? clear : clear;
	            clear: ns = ring? draw: clear;
	        //end
	   endcase
	end
	
    always_comb begin
	    case(ps)
    	    draw: begin
    	        
        		r = 0;
        		g = 0;
        		b = 0;
        		if ((x > 50) && (x < 200) && (y > 50) && (y < 110)) begin
        			r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 300) && (x <450) && (y > 50) && (y < 110)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 150) && (x < 200) && (y > 150) && (y < 200)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 300) && (x < 350) && (y > 150) && (y < 200)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 50) && (x < 450) && (y > 260) && (y < 430)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 510) && (x < 580) && (y > 50) && (y < 300)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end else if ((x > 510) && (x < 580) && (y > 350) && (y < 430)) begin
        		    r = 255;
        			g = 0;
        			b = 0;
        		end 
            end
             clear: begin
                
                r = 0;
                g = 0;
                b = 0;
        	    if ((x >= 0) && (y >= 0)) begin
        	        r = 0;
        	        g = 0;
        	        b = 0;
        	    end
        	 end
		endcase
	end
	
	//We will use a faster clock so the animation flashes more.
	assign clk2 = divided[20];
	always_ff @(posedge clk2) begin
	    if (reset)
	        ps <= draw;
	   else 
	        ps <= ns;
	 end       
	
	
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


 