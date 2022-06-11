//This module is here to be the replacement of ram32x3 in task 2 so I can use all 
//the same code from task1 file just change one word
module task2mem (address, clock, data, wren, q);
	input logic	[4:0]  address;
	input	logic   clock;
	input	logic [2:0]  data;
	input	logic   wren;
	output logic	[2:0]  q;
	
	//Array of memory
	logic [2:0] memory_array [31:0];
	
	//If write is enabled we write to the given address in memory.
	//We do this on the clockedge.
	//We do everything on the clockedge so everything is connected to it.
	always_ff @(posedge clock) begin
		if (wren) begin
			memory_array[address] <= data;
			q <= memory_array[address];
		end 
		q <= memory_array[address];
	end
	
endmodule 


module task2mem_testbench();
	logic clock, wren;
	logic [4:0] address;
	logic [2:0] data;
	logic [2:0] q;
	
	task2mem dut (address, clock, data, wren, q);
   
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clock <= 0;  
		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock 
	end  
	
	
	initial begin   	   
	   //First i initialize everythign to 0.
		wren <= 0; data <= 3'b000; address <= 0; @(posedge clock);   
                     @(posedge clock);   
                      @(posedge clock);
		//Here I write to adress 00001
		address <= 5'b00001; data <= 3'b001; wren <= 1; @(posedge clock);   
                     @(posedge clock);   
                      @(posedge clock);
		//I turn off the write enable and read from adress 00001 
		wren <= 0; address <= 5'b00001; @(posedge clock);   
                     @(posedge clock);   
                      @(posedge clock); 
	   //I then write to adress 00010
	   address <= 4'b00010; data <= 3'b010; wren <= 1; @(posedge clock);   
                     @(posedge clock);   
                      @(posedge clock);
		//I turn off the write enable and read from adress 00010 
		wren <= 0; address <= 5'b00010; @(posedge clock);   
                     @(posedge clock);   
                      @(posedge clock);
		$stop; // End the simulation.  
   end 
	
endmodule 