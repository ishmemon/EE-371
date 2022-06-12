 //Module to build flop
 module flop (q, d, clk, Reset);
	output logic q;
	input logic d;
	input logic clk;
	input logic Reset;
	
	always_ff @(posedge clk) begin
		  if (Reset)   
    q <= 0;
  else  
		q <= d;
	end
endmodule 

	module flop_testbench(); 
		logic clk, Reset, d;
		logic q;
		
		flop dut (q, d, clk, Reset);

		 // Set up a simulated clk.   
 parameter CLOCK_PERIOD=100;  
 initial begin   
  clk <= 0;  
  forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clk 
 end 
	
 initial begin  
                      @(posedge clk);   
  Reset <= 1;         @(posedge clk); // Always reset FSMs at start  
							@(posedge clk);   
                      @(posedge clk); 
				       @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);
  Reset <= 0; d <= 0; @(posedge clk);   
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
            d <= 1; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);   
             @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
				 d <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
				    @(posedge clk);
                      @(posedge clk);

            
  $stop; // End the simulation.  
 end  
endmodule 