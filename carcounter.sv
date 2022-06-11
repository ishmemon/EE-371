module carcounter (clk, reset, incr, decr, count);
	input logic clk, reset, incr, decr;
	//Output is 5 bit so it can represent 0-31.
	output logic [4:0] count;
	//Works on always flip flop increments, decrements, resets, or stays constant
	always_ff @(posedge clk) begin
	   if (reset) begin
	      count <= 0;
		end else if (incr) begin
			count <= count + 1;
		end else if (decr) begin
		   count <= count - 1;
	   end else begin
			count <= count;
		end
	end
	
endmodule 

module carcounter_testbench();  
	logic  clk, reset, incr, decr;  
	logic [4:0] count;
  
	carcounter dut (clk, reset, incr, decr, count);   
   
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
   
 // Set up the inputs to the design.  Each line is a clock cycle.  
 initial begin  
 //Just simulates a few random sequences of increasing and decreasing.
                      @(posedge clk);   
  reset <= 1;         @(posedge clk); // Always reset FSMs at start  
  reset <= 0; incr <= 0; decr <= 0; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk); 
				incr <= 1; @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);			 
            incr <= 1; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);   
            incr <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
			   decr <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);  
				decr <= 1; @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);			 	 
   
  $stop; // End the simulation.  
 end  
endmodule  