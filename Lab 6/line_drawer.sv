/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	//output logic done;
	output logic [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	 logic done;
	logic signed [11:0] error;// example - feel free to change/delete
	logic signed [10:0] dx,dy;
	logic signed [10:0] abs_dx, abs_dy;
	logic steepLine;
	
	//Assign absolute dx and dy by getting the larger x/y value and subtracting the smaller x/y value.
	assign abs_dx = (x0 <= x1) ? (x1 - x0) : (x0 - x1);
	assign abs_dy = (y0 <= y1) ? (y1 - y0) : (y0 - y1);
	
	//Assign steepline as true when absolute dy > absolute dx, else false. 
	assign steepLine = (abs_dy > abs_dx) ? 1:0;
	
	
	// If steepLine is true, swap X and Y values, if not keep same.
	// If x0 > x1 we want to switch them around to accomadate so that x0 is now where x1 is on the coordinate plane
	//and x1 is now where x0 is on the coordinate plane, else we keep the same values and store them. 
	//This always_comb block sorts cases of steep and left/right so that we can retreive the right values for the algorithm.
	logic [10:0] x0_sw, x1_sw, y0_sw, y1_sw;
	logic [10:0] x0_dr,x1_dr,y0_dr,y1_dr;
	
	//If steepLine is true, we want to switch x values with y values and store it in a new variable x_sw and y_sw.
	assign x0_sw = (steepLine)? y0: x0;
	assign y0_sw = (steepLine)? x0: y0;
	assign x1_sw = (steepLine)? y1: x1;
	assign y1_sw = (steepLine)? x1: y1;
	
	//Here we test for the left case where x0 > x1. We use our x_sw and y_sw variables from the previous test.
	//If x0_sw is bigger than x1_sw, we switch the 2 coordinates and store them in new variables x_dr and y_dr
   //so that x1_sw and y1_sw is now stored in x0_dr and y0_dr; And x0_sw and y0_sw is now stored in x1_dr and y1_dr. 
	assign x0_dr = (x0_sw > x1_sw)? x1_sw: x0_sw;
	assign y0_dr = (x0_sw > x1_sw)? y1_sw: y0_sw;
	assign x1_dr = (x0_sw > x1_sw)? x0_sw: x1_sw;
	assign y1_dr = (x0_sw > x1_sw)? y0_sw: y1_sw;
	
	
	//Here we assign dy and dx according to the steep line case. If steep line is true, we want to assign dx with
	//absolute value of dy and dy with absolute value of dx. If false we assign them as normal. 
	assign dx = x1_dr - x0_dr;
	assign dy = y1_dr - y0_dr;
	
	
	//Here we test and assign for y_step. If y0 is smaller than y1, we set y_step to 1 so that it increments by 1.
	//If y0 > y1 then we set y_step by -1 so that it decreases correctly. If y0 = y1 then we set y_step to 0 for the horizontal line case.
	logic signed [10:0]y_step;
//	always_comb begin
//		if (y0_dr < y1_dr) begin
//			y_step = 1;
//		end
//		else if (y0_dr > y1_dr) begin
//			y_step = -1;
//		end 
//		else begin
//			y_step = 0;
//		end
//	end

	assign y_step = (y0_dr < y1_dr)? 1:-1;
	

	logic load;
	logic signed [10:0] x_alg, y_alg, x1_val;
	always_ff @(posedge clk) begin
		if (reset) begin
			error <= 0;
			done <= 0;
			load <= 1;
		end 
		else begin
			if (load == 1) begin   // Load in the variables required
					x_alg <= x0_dr;
					y_alg <= y0_dr;
					x1_val <= x1_dr;
					error <= 2*dy -(dx);
					load <=0;
			end else if (x_alg < x1_val) begin //Algorithm continues as long as x_alg < x1_val
				x_alg <= x_alg +1;
				if (error < 0) begin                  //Algorithm draws line by storing new values into x and y based
																	//off the error variable and y_step.
					error <= error + 2*dy;
				end
				else if (error >= 0) begin
					error <= error +2*dy - 2*dx;
					y_alg <= y_alg + y_step;
				end
			end else begin
			done <= 1;
			end
		end
	end  // always_ff
	

	
	assign x = steepLine? y_alg:x_alg;
	assign y = steepLine? x_alg:y_alg;
	
endmodule  // line_drawer


module line_drawer_testbench();
	 logic clk, reset;
	 logic [10:0]	x0, y0, x1, y1;
	 logic done;
	 logic [10:0]	x, y;
	
	line_drawer dut(.*);
	
	 // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	 
	 initial begin
	 
	 reset <= 1;  												    @(posedge clk)
	 
	 
	 reset <= 0; x0 <= 12; y0 <= 4;  x1 <= 20; y1 <= 4; @(posedge clk);  // Horizontal Line
												          			 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 4; y0 <= 5;  x1 <= 4; y1 <= 16;   @(posedge clk);  // Vertical Line
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
   reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 5; y0 <= 6;  x1 <= 15; y1 <= 9;   @(posedge clk);  // Diagonal Line GRADUAL RIGHT UP
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 10; y0 <= 3;  x1 <= 1; y1 <= 8;   @(posedge clk);  // Diagonal Line GRADUAL LEFT UP
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 5; y0 <= 6;  x1 <= 9; y1 <= 3;    @(posedge clk);  // Diagonal Line GRADUAL RIGHT DOWN
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 10; y0 <= 7;  x1 <= 1; y1 <= 5;    @(posedge clk);  // Diagonal Line GRADUAL LEFT DOWN
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 																	 																	 
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 5; y0 <= 6;  x1 <= 10; y1 <= 14;  @(posedge clk);  // Diagonal Line STEEP RIGHT UP
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
    
	 reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 15; y0 <= 8;  x1 <= 11; y1 <= 19; @(posedge clk);  // Diagonal Line STEEP LEFT UP
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
	
	reset <= 1; 													 @(posedge clk);
																		 
	reset <= 0; x0 <= 7; y0 <= 16;  x1 <= 12; y1 <= 5;  @(posedge clk);  // Diagonal Line STEEP RIGHT DOWN
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
  
  reset <= 1; 													    @(posedge clk);
																		 
	reset <= 0; x0 <= 11; y0 <= 14;  x1 <= 4; y1 <= 2;  @(posedge clk);  // Diagonal Line STEEP LEFT DOWN
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
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
																		 @(posedge clk);
	 $stop;
	 
	 end 
endmodule
	 
	