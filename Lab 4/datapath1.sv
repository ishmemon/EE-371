//This module acts as the datapath to the system. Logic is assigned here. 
module datapath1 (A,right_shiftA,load_A,result, incr_result, switchAdd, clk,reset);
					
    //port definitions
	 output logic [3:0]result;
	 output logic [7:0] A;
	 input logic [7:0] switchAdd;
	 input logic load_A, right_shiftA, incr_result, clk, reset;
	 
	 //internal logic
	 
	 //datapath logic
	 always_ff @(posedge clk) begin
		if (load_A) begin
			A <= switchAdd;
			result <= 4'b0;
		end
		if (reset) begin
			A <= 8'b0;
			result <= 4'b0;
		end
		if(right_shiftA) A <= A >>1;
		if(incr_result) result<= result +1;
	end
	
	
endmodule

//This testbench tests the counter and shift. The functions: incr_result which increments the result counter,
//right_shiftA, which shifts the input A from switches to the right, and reset. switchAdd was given a value
//below to simulate the value provided by the switches.  
module datapath1_testbench();
	logic clk, right_shiftA, load_A;
	logic [7:0] switchAdd,A;
	logic	incr_result,reset;
	logic [3:0]result;
	
	datapath1 dut(.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 
	
	initial begin
	reset <= 1; 									@(posedge clk);
	reset <= 0;										@(posedge clk);
	switchAdd <= 8'b11011011;					@(posedge clk);
														@(posedge clk);
	load_A <=1;										@(posedge clk);  // Test if loading function works
	load_A <=0;										@(posedge clk);
														@(posedge clk);
	incr_result <= 1;								@(posedge clk);  // Test if incrementing the counter works
								repeat(6)			@(posedge clk);
	incr_result <=0;                       @(posedge clk);
	right_shiftA <= 1;				         @(posedge clk);	// Test shift function works
								repeat(6)         @(posedge clk);
	right_shiftA <=0;                      @(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
	$stop;													
   end
endmodule
	
	 
	 