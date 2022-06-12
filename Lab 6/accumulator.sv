/*This is the accumulator module implementation. It is actually just an updated flip flop.
I was going to use it to sum things around but then we just ended up doing that in the 
DE1_SoC so this is just a flip flop without a reset. Also,the input and ouptut is 24 bit, q,
and d, and a clock signal goes in.
*/

module accumulator (q, d, enable, clk, reset);
	input logic clk;
	output logic [23:0] q;
	input logic [23:0] d;
	input logic reset, enable;
	
	//Always ff block that changes makes q equal d at rising clock edge.
		always_ff @(posedge clk) begin
			if (reset) begin
				q <= 24'h000000;
			end else if (enable) begin
				q <= d;
			end
	end
	
endmodule



/*A simple testbench for this module. All it does is keep d at a certain value for multiple
clock cycle. The expected behavior is that on the clock edge, the q output keeps becomes 
d. 
*/
module accumulator_testbench();
	logic [23:0] q, d;
	logic clk, reset;
	
	accumulator dut (q, d, clk, reset);
	
	 // Set up a simulated clk.   
 parameter CLOCK_PERIOD=100;  
 initial begin   
  clk <= 0;  
  forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clk 
 end 
	
 initial begin  
				reset <= 1; @(posedge clk);
				reset <= 0; @(posedge clk);
				
				
				d <= 24'h000000; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk); 
				       @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);
				@(posedge clk);   
                      @(posedge clk); 
				       @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);			 
            d <= 24'h00000F; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);   
             @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
				 d <= 24'hFFFFFF; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
				    @(posedge clk);
                      @(posedge clk);

            
  $stop; // End the simulation.  
 end  
endmodule 
