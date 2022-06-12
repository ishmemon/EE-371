module occupancy (clk, reset, outer, inner, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); 
	input logic clk, reset, outer, inner;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	
	logic enter, exit;
	logic [4:0] count;
	simple s1 (.clk, .reset, .outer, .inner, .enter, .exit);
	carcounter c1 (.clk, .reset, .incr(enter), .decr(exit), .count); 
	//Count gives the number we just need to make it a display
	
	always_comb begin
		if (count == 5'b00000 | reset) begin
			//I dont think I need assign statements here
			HEX0 = 7'b1000000;
			//Has to display CLEAR
			HEX1 = 7'b1001100; //R
			HEX2 = 7'b0001000; //A
			HEX3 = 7'b0000110; //E
			HEX4 = 7'b1000111; //L
			HEX5 = 7'b1000110; //C
		//0 through 9 has all of the things except 0 with the number	
		end else if (count == 5'b00001) begin
			 HEX0 = 7'b1111001;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00010) begin
			 HEX0 = 7'b0100100;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00011) begin
			 HEX0 = 7'b0110000;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00100) begin
			 HEX0 = 7'b0011001;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00101) begin
			 HEX0 = 7'b0010010;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00110) begin
			 HEX0 = 7'b0000010;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b00111) begin
			 HEX0 = 7'b1111000;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01000) begin
			 HEX0 = 7'b0000000;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01001) begin
			 HEX0 = 7'b0011000; //9
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		//Starting from 10 the hex 1 will display a 1
		end else if (count == 5'b01010) begin
			 HEX0 = 7'b1000000;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01011) begin
			 HEX0 = 7'b1111001;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01100) begin
			 HEX0 = 7'b0100100;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01101) begin
			 HEX0 = 7'b0110000;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01110) begin
			 HEX0 = 7'b0011001;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		end else if (count == 5'b01111) begin
			 HEX0 = 7'b0010010;
			 HEX1 = 7'b1111001;
			 HEX2 = 7'b1111111;
			 HEX3 = 7'b1111111;
			 HEX4 = 7'b1111111;
			 HEX5 = 7'b1111111;
		//Otherwise we display FULL on HEX5- HEX2
		end else begin
			 HEX0 = 7'b1111111;
			 HEX1 = 7'b1111111;
			 HEX2 = 7'b1000111;  //L
			 HEX3 = 7'b1000111;  //L
			 HEX4 = 7'b1000001;  //U
			 HEX5 = 7'b0001110;  //F
		end
	end
	

	
	
endmodule 

module occupancy_testbench();  
	logic  clk, reset, outer, inner;  
	logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  
  
	occupancy dut (clk, reset, outer, inner, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);   
   
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
   
 // Set up the inputs to the design.  Each line is a clock cycle.  
 initial begin  
 //I try out a few entries and exits by cars.
                      @(posedge clk);   
  reset <= 1;         @(posedge clk); // Always reset FSMs at start  
  reset <= 0; outer <= 0; inner <= 0; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);  
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering
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
                      @(posedge clk); //This sequence simulates a car entering and reaches 16 so will show FULL
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
                      @(posedge clk);  //This sequence simulates a car  exiting and reaches 0 cars so shows CLEAR
	 
   
  $stop; // End the simulation.  
 end  
endmodule  