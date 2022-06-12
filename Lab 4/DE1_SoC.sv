/* Top-level module for DE1-SoC hardware connections to implement a fullAdder.
 *
 * The inputs are connected to switches (a - SW2, b - SW1, cin - SW0).
 * The outputs are connected to LEDs (sum - LEDR0, cout - LEDR1).
 */
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
   input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input  logic  [3:0]  KEY;                               // True when not pressed, False when pressed  
	input  logic  [9:0]  SW; 
	
    logic [7:0] switchAdd;
    logic s, done1, done2, found, reset;

	 //This deals wit hthe metastability for the s and reset.
    flop f1(.q(s), .d(~KEY[3]), .clk(CLOCK_50), .Reset(~KEY[0]));
	 //flop f2(.q(reset), .d(~KEY[3]), .clk(CLOCK_50), .Reset(~KEY[0]));

    //These are the outputs for task 1 and 2 respectively they will be displayed on hex	 
	 logic [3:0] result;
	 logic [4:0] loc;

    assign toggle = SW[9];
    assign switchAdd = SW[7:0];


	//Instantiate the 2 separate modules.
   task1 t1 (.switchAdd(switchAdd), .s, .done(done1), .result, .clk(CLOCK_50), .reset);
   
	
	task2 t2 (.clk(CLOCK_50), .reset, .a(switchAdd), .s, .done(done2), .loc);
	
	//seg7 hex0 ( .hex(result), .leds(HEX0));
	
   //Turn off the other hexes
	assign HEX2 = 7'b1111111;   
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	//There are 2 logics that need to be in the hex displays
	logic [3:0] display_hex1;
	logic [3:0] display_hex0;
	seg7 hex0 (.hex(display_hex0), .leds(HEX0));
	seg7 hex1 (.hex(display_hex1), .leds(HEX1));
	
	//For these two logics above we have two choices each from task 1 or task 2 and
	//so we define 4 variables and choose 2 of them each depending on Sw[9] (toggle).
	//The values should only be updated at done's change so we have always_ff block
	logic [3:0] hex1task1;
	assign hex1task1 = 4'b0000;
	logic [3:0] hex0task1;
	assign hex0task1 = result;
	logic [3:0] hex1task2;
	assign hex1task2 = {3'b000, loc[4]};
	logic [3:0] hex0task2;
	assign hex0task2 = loc[3:0];
	
	//If toggle on, we do task 2 if off we do task 1.
	always_comb begin
		if (toggle) begin
			display_hex1 = hex1task2;
			display_hex0 = hex0task2;
		end else begin
			display_hex1 = hex1task1;
			display_hex0 = hex0task1;
		end
	end
	
	
	//Now we need to display the 5 bit address in the 2 HEX displays.
	//I assign the binary to an integer and then pass in the appropiate numbers to
	//the display
	/*integer dis;
	integer ones;
	integer tens;
	logic [4:0] tens_b;
	logic [4:0] ones_b;
	assign dis = SW[8:4];
	assign ones = dis%10;
	assign tens = dis/10;
	assign tens_b = tens;
	assign ones_b = ones;
	seg7 display3 (.hex(HEX5), .leds(tens_b));
	seg7 display4 (.hex(HEX4), .leds(ones_b));*/

	
endmodule  // DE1_SoC
