module simple (clk, reset, outer, inner, enter, exit);   
 input  logic  clk, reset, outer, inner;   
 output logic enter, exit;   
 
 // State variables 
 enum { unblock, outblock, inblock, bothblock } ps, ns;  
  
 // Next State logic  
 //We have to make this pedestrian proof if the state bothblock is not reached 
 //that means there is a pedestrian. That should be an output check.
 always_comb begin  
  case (ps)  
   unblock:   if ((~outer)&(~inner))  ns = unblock; 
		else if ((outer)&(~inner)) ns = outblock;
		//Cant automatically go to both block
      else  ns = inblock;
	outblock:  if (inner & outer)  ns = bothblock; 
      //I guess I can simplify these bec of the assumptions given	
      else if ((~inner) & outer) ns = outblock;
		else if ((~inner) & (~outer)) ns = unblock;
		else  ns = inblock;  
	inblock:  if (inner & outer)  ns = bothblock;
      //I guess I can simplify these bec of the assumptions given	
      else if ((~inner) & outer) ns = outblock;
		else if ((~inner) & (~outer)) ns = unblock;
		else  ns = inblock;    
	bothblock: if ((~inner) & outer) ns = outblock;
	   else if ((~outer) & inner) ns = inblock;
		//Cant automatically go to unblock
		else ns = bothblock;
  endcase  
 end  
   
 //A car will exit if both are blocked and then only outer is blocked
 //A car will enter if both are blocked and then only inner is blockedd. 
 assign enter = (ps == bothblock) & (ns == inblock);
 assign exit = (ps == bothblock) & (ns == outblock);
	
 
 // DFFs  
 always_ff @(posedge clk) begin  
  if (reset)   
    ps <= unblock;
  else  
   ps <= ns;  
 end
 
 endmodule
 
 module simple_testbench();  
	logic  clk, reset, outer, inner;  
	logic  enter, exit;  
  
	simple dut (clk, reset, outer, inner, enter, exit);   
   
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
   
 // Set up the inputs to the design.  Each line is a clock cycle.  
 initial begin  
                      @(posedge clk);   
  reset <= 1;         @(posedge clk); // Always reset FSMs at start  
  reset <= 0; outer <= 0; inner <= 0; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk); 
				inner <= 1; @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);			 
            outer <= 1; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);   
            inner <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
			   outer <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);  //This sequence simulates a car  exiting 
				outer <= 1; @(posedge clk);
                      @(posedge clk);
				          @(posedge clk);			 
            inner <= 1; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);   
            outer <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
			   inner <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk); //This sequence simulates a care entering
				inner <= 1;	@(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
			   inner <= 0; outer <= 1; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk);
				outer <= 0; @(posedge clk);   
                      @(posedge clk);   
                      @(posedge clk); //This simulates a pedestrian		 
   
  $stop; // End the simulation.  
 end  
endmodule  