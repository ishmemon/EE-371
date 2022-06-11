//Our task1 testbench takes in the clk, write enabler write, address, data input dataIn, and data output dataOut.
//We first initialized everything to 0 then: when write is enabled, the memory at the address specified and dataOut will match dataIn and the memory continues to //stay at the same value until it is rewritten. When write is disabled, dataOut represents the current data at the address and is not affected by dataIn. We chose //to test this by writing to 2 different addresses and consequently reading from them. 
module task1 (clk, address, dataIn, write, dataOut);
	input logic clk;
	input logic [4:0] address;
	input logic [2:0] dataIn;
	input logic write;
	output logic [2:0] dataOut;
	
	//Declare new signals that will be the old signals passed through flip flop
	logic [4:0] new_address;
	logic [2:0] new_dataIn;
	logic new_write;
	

	//Use 1 bit flip flops from ee 271 to process each bit of address, dataIn, and write.
	flop f1(.q(new_address[0]), .d(address[0]), .clk, .Reset(1'b0));
	flop f2(.q(new_address[1]), .d(address[1]), .clk, .Reset(1'b0));
	flop f3(.q(new_address[2]), .d(address[2]), .clk, .Reset(1'b0));
	flop f4(.q(new_address[3]), .d(address[3]), .clk, .Reset(1'b0));
	flop f5(.q(new_address[4]), .d(address[4]), .clk, .Reset(1'b0));
	
	flop f6(.q(new_dataIn[0]), .d(dataIn[0]), .clk, .Reset(1'b0));
	flop f7(.q(new_dataIn[1]), .d(dataIn[1]), .clk, .Reset(1'b0));
	flop f8(.q(new_dataIn[2]), .d(dataIn[2]), .clk, .Reset(1'b0));
	
	flop f9(.q(new_write), .d(write), .clk, .Reset(1'b0));
	
	
	//Call the ram memory file with the given flip flopped parameters
	ram32x3 memory (.address(new_address), .clock(clk), .data(new_dataIn), .wren(new_write), .q(dataOut));
	
endmodule 

`timescale 1 ps / 1 ps

//Our task1 testbench takes in the clk, write enabler write, address, data input dataIn, and data output dataOut. 
//We first initialized everything to 0 then: when write is enabled, the memory at the address specified and dataOut will match dataIn and the memory continues to //stay at the same value until it is rewritten. When write is disabled, dataOut represents the current data at the address and is not affected by dataIn. We chose //to test this by writing to 2 different addresses and consequently reading from them. 

module task1_testbench();
	logic clk;
	logic [4:0] address;
	logic [2:0] dataIn;
	logic write;
	logic [2:0] dataOut;
	
	task1 dut(clk, address, dataIn, write, dataOut);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end 
	
	initial begin   	   
	   //First i initialize everythign to 0.
		write <= 0; dataIn <= 3'b000; address <= 0; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		//Here I write to adress 00001
		address <= 5'b00001; dataIn <= 3'b001; write <= 1; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		//I turn off the write enable and read from adress 00001 
		write <= 0; address <= 5'b00001; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk); 
	   //I then write to adress 00010
	   address <= 4'b00010; dataIn <= 3'b010; write <= 1; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		//I turn off the write enable and read from adress 00010 
		write <= 0; address <= 5'b00010; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		$stop; // End the simulation.  
   end 
	
endmodule 