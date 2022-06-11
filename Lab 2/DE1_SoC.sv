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
	
	//Three bit buses that hold potential output data.
	logic [2:0] outData;
	logic [2:0] outData2;
	logic [2:0] outData1;
	
	//A counter 5 bit and a control switch (SW_9).
	logic [4:0] count;
	logic controlSwitch;
	logic controlDummy;
	
	
	//This code is from 271 clock divider allows us to get the 1 second clock for
	//board and CLOCK_50 for modelsim.
	logic [31:0] div_clk;  
	parameter whichClock = 25; // 0.75 Hz clock 
	clock_divider cdiv (.clock(CLOCK_50),  
                       .reset(1'b0),  
                       .divided_clocks(div_clk));   
  
	//  Clock  selection;  allows  for  easy  switching  between  simulation  and  board clocks 
	logic clkSelect; 
	// Uncomment ONE of the following two lines depending on intention 
  
   assign clkSelect = CLOCK_50; 
	//assign clkSelect = div_clk[whichClock]; //1 second counter 
	 // Uncomment ONE of the following two lines depending on intention 
	
	
	
	
	//This 2 bit bus holds the values of KEY 3 and KEY 0 stabilized through 2 flip flops
	logic [1:0] newKeys;
	logic [1:0] newMidKeys;
	//Deal with metastability pass key and switches through flip flops
	flop f1(.q(newMidKeys[1]), .d(KEY[3]), .clk(clkSelect), .Reset(1'b0));
	flop f2(.q(newMidKeys[0]), .d(KEY[0]), .clk(clkSelect), .Reset(1'b0));
	flop g1(.q(newKeys[1]), .d(newMidKeys[1]), .clk(clkSelect), .Reset(1'b0));
	flop g2(.q(newKeys[0]), .d(newMidKeys[0]), .clk(clkSelect), .Reset(1'b0));
	//The control switch is flip flop stabilized SW[9].
	flop f3(.q(controlDummy), .d(SW[9]), .clk(clkSelect), .Reset(1'b0));
	flop g3(.q(controlSwitch), .d(controlDummy), .clk(clkSelect), .Reset(1'b0));
	
  
	
	//The counter has reset key3|sw9 so it waits until sw9 is pressed to start counting
	//counter counter1 (.clk(clkSelect), .reset((~newKeys[1]) | (~controlSwitch)), .out(oldcount));
	
	//assign count = 5'b00000;
	always_ff @(posedge clkSelect) begin
		if (~controlSwitch | (~newKeys[1])) begin
			count <= 5'b00000; 
		end else begin
			count <= count + 1;
		end
	end
	
	//The switches each go through 2 flip flops to account for metastability. The 
	//flop module is taken from ee271 since there is a reset and we dont need
	//it I assign it a 0. 
	logic [8:0] newSwitches;
	logic [8:0] newMidSwitches;
	
	flop m1(.q(newMidSwitches[8]), .d(SW[8]), .clk(clkSelect), .Reset(1'b0));
	flop m2(.q(newMidSwitches[7]), .d(SW[7]), .clk(clkSelect), .Reset(1'b0));
	flop m3(.q(newMidSwitches[6]), .d(SW[6]), .clk(clkSelect), .Reset(1'b0));
	flop m4(.q(newMidSwitches[5]), .d(SW[5]), .clk(clkSelect), .Reset(1'b0));
	flop m5(.q(newMidSwitches[4]), .d(SW[4]), .clk(clkSelect), .Reset(1'b0));
	flop m6(.q(newMidSwitches[3]), .d(SW[3]), .clk(clkSelect), .Reset(1'b0));
	flop m7(.q(newMidSwitches[2]), .d(SW[2]), .clk(clkSelect), .Reset(1'b0));
	flop m8(.q(newMidSwitches[1]), .d(SW[1]), .clk(clkSelect), .Reset(1'b0));
	flop m9(.q(newMidSwitches[0]), .d(SW[0]), .clk(clkSelect), .Reset(1'b0));
	
	flop m11(.q(newSwitches[8]), .d(newMidSwitches[8]), .clk(clkSelect), .Reset(1'b0));
	flop m12(.q(newSwitches[7]), .d(newMidSwitches[7]), .clk(clkSelect), .Reset(1'b0));
	flop m13(.q(newSwitches[6]), .d(newMidSwitches[6]), .clk(clkSelect), .Reset(1'b0));
	flop m14(.q(newSwitches[5]), .d(newMidSwitches[5]), .clk(clkSelect), .Reset(1'b0));
	flop m15(.q(newSwitches[4]), .d(newMidSwitches[4]), .clk(clkSelect), .Reset(1'b0));
	flop m16(.q(newSwitches[3]), .d(newMidSwitches[3]), .clk(clkSelect), .Reset(1'b0));
	flop m17(.q(newSwitches[2]), .d(newMidSwitches[2]), .clk(clkSelect), .Reset(1'b0));
	flop m18(.q(newSwitches[1]), .d(newMidSwitches[1]), .clk(clkSelect), .Reset(1'b0));
	flop m19(.q(newSwitches[0]), .d(newMidSwitches[0]), .clk(clkSelect), .Reset(1'b0));
	
	
	//These two instantiations call task2 or task3 their write enables are connected
	//to controlSwitch which is SW[9] this allows for independence and so the memories
	//dont write each other.
	 task2 lab_part_2 (.clk(~newKeys[1]), .address(newSwitches[8:4]), .dataIn(newSwitches[3:1]), .write(newSwitches[0]&(~controlSwitch)), .dataOut(outData1));
	//I dont know when to do write enable I just chose SW[0] again
	//I put sw0 & sw9 for the enable so it only works if they are both true otherwise we cannot write
	//ram32x3port2 part_3(.clock(clkSelect), .data(SW[3:1]), .rdaddress(count), .wraddress(SW[8:4]), .wren(SW[0]&controlSwitch), .q(outData2));
	ram32x3port2 part_3 (.clock(clkSelect), .data(newSwitches[3:1]), .rdaddress(count), .wraddress(newSwitches[8:4]), .wren(newSwitches[0]&controlSwitch), .q(outData2));
	
	//The outData should have the correct 3 bit value so we can put it in seven
	//segment display to display it. I use always comb on case controlSwitch (SW[9])
	//to make outData either outData1 (output of task 2) or outData2 (output of task 3).
	always_comb begin
		case (controlSwitch)
			1'b0: outData <= outData1;
			1'b1: outData <= outData2;
		endcase
	end
	
	//Use the display to display the data the values are 3 bit and we need 4 bit
	//leds so I just add a 0 on top.
	seg7 display1 (.hex({1'b0, outData}), .leds(HEX0));
	seg7 display2 (.hex({1'b0, SW[3:1]}), .leds(HEX1));
	
	//Now we need to display the 5 bit address in the 2 HEX displays.
	//So instead I will display the first digit from the 2 digits and a 0 to concatenate
	//and then the second digit is the last 3 digits.
	logic [3:0] hex_5;
	assign hex_5[3] = 1'b0;
	assign hex_5[2] = 1'b0;
	assign hex_5[1] = 1'b0;
	assign hex_5[0] = SW[8];
	//These two are in octal. 5 and 4 have to display write address which is
	//SW[8:4]
	seg7 display5 (.hex(hex_5), .leds(HEX5));
	seg7 display6 (.hex(SW[7:4]), .leds(HEX4));
	
	//These are the seg7 displays for the part 3 however they have to be controlled
	//that is why I use the reset seg 7 module so I can turn them off if control swtich
	//is asserted.
	seg7_reset display7 (.reset(~controlSwitch), .hex({3'b000, count[4]}), .leds(HEX3));
	seg7_reset display8 (.reset(~controlSwitch), .hex(count[3:0]), .leds(HEX2));
	
endmodule  // DE1_SoC

`timescale 1 ps / 1 ps 
/* testbench for the DE1_SoC. This testbench goes through a few reads and writes and sees if the output matches
what is expected. For the sake of ease and simplicity there are not all possible adresses tested, instead a select
sample that is representative of the larger memory space. We tried it first with SW[9] off and then SW[9] on to test
both the task 2 and task 3 parts*/
module DE1_SoC_testbench();
   logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 	
	logic [9:0] LEDR;
	logic  [3:0]  KEY;   
	logic  [9:0]  SW; 
	
	
	// using SystemVerilog's implicit port connection syntax for brevity
	DE1_SoC dut3 (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
   end 
	
	//I toggle the key like the clock is toggled.
	initial begin   
		KEY[3] <= 0;  
		forever #(CLOCK_PERIOD*2) KEY[3] <= ~KEY[3]; // Forever toggle the clock 
   end 
	
	 
	initial begin 
	//I set sw9 as 0 to work on task 2.
		SW[9] <= 0; @(posedge CLOCK_50); 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);  //This sets the switch 9 to 0 so we can do work with
									//the lab task 2
		//I complete a write to address 00001 
	   SW[8:4] <= 5'b00001; SW[3:1] <= 3'b001; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);
				@(posedge CLOCK_50);
	@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);	
                      @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
							 @(posedge CLOCK_50);
		//I turn off the write and read from adress 00001 
		SW[0] <= 0; SW[8:4] <= 5'b00001; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50); 
					@(posedge CLOCK_50);
			@(posedge CLOCK_50);
	@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);	
                      @(posedge CLOCK_50);
							@(posedge CLOCK_50);
						@(posedge CLOCK_50);
					@(posedge CLOCK_50);
				@(posedge CLOCK_50);
			@(posedge CLOCK_50);
		@(posedge CLOCK_50);
	@(posedge CLOCK_50);	
	   //I then write to adress 00010
	   SW[8:4] <= 4'b00010; SW[3:1] <= 3'b010; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);  
						@(posedge CLOCK_50);
					@(posedge CLOCK_50);
				@(posedge CLOCK_50);
			@(posedge CLOCK_50);
		@(posedge CLOCK_50);
	@(posedge CLOCK_50);
@(posedge CLOCK_50);	
                     @(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
		//I turn off the write and read from adress 00010 
		SW[0] <= 0; SW[8:4] <= 5'b00010; @(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);
@(posedge CLOCK_50);		
                     @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							                      @(posedge CLOCK_50);   
    
							 
							 
							 
		//I switch sw9 to 1 to work on task 3. Since the read works automatically
		// and a new address is read every clock edge I keep a gap of a few clock
		//edges to see how the read is doing and allow it to happen
		SW[9] <= 1; @(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);  //This sets the switch 9 to 0 so we can do work with
									//the lab task 2
		//I write to address 00001
	   SW[8:4] <= 5'b00001; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
	   //I then write to adress 00010
	   SW[8:4] <= 5'b00010; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
			   //I then write to adress 00011 
	   SW[8:4] <= 5'b00011; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
							 	   //I then write to adress 00100
			   SW[8:4] <= 5'b00100; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							 	   //I then write to adress 00101
			   SW[8:4] <= 5'b00101; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							 	   //I then write to adress 00110
			   SW[8:4] <= 5'b00110; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							 	   //I then write to adress 00111
			   SW[8:4] <= 5'b00111; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							 	   //I then write to adress 01000
			   SW[8:4] <= 5'b01000; SW[3:1] <= 3'b100; SW[0] <= 1; @(posedge CLOCK_50);   
             //There are a ton of clock edges so the read can cycle through 
				//all the addresses and read them.
													 @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50); 
							@(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);                       @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
							                      @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);
		@(posedge CLOCK_50);   
                     @(posedge CLOCK_50);   
                      @(posedge CLOCK_50);  
		
		
		//$stop; // End the simulation.  
   end
	
endmodule  