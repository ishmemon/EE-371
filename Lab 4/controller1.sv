//This module acts as the controller to the system. The state transitions are mentioned here.
module controller1 (right_shiftA, s, done, load_A, incr_result, A_zero, a0, clk, reset);
	
	// port definitions
	input logic  s, A_zero, a0, clk, reset;
	output logic right_shiftA, load_A, done, incr_result;
	
	//state names and variables
	enum {S1, S2, S3} ps,ns;
	
	always_ff @(posedge clk)
		if (reset) 
			ps <= S1;
		else 
			ps <= ns;
	
	always_comb begin
		case(ps)
			S1: ns = s? S2:S1;
			S2: ns = A_zero? S3:S2;
			S3: ns = s? S3:S1;
		
		endcase
		
	end
	
	//assign outputs
	assign right_shiftA = (ps==S2);
	assign done = (ps==S3);
	assign incr_result = (ps==S2)&(~A_zero)&a0;
	assign load_A = (ps==S1)&(~s);
	
	
endmodule

//This testbench tests the movement through the states S1, S2 and S3. We move from S1 to S2 when s
//is high, else we stay at S1. We move from S2 to S3 when A_zero is high, else we stay at S2. We move
//from S3 to S1 when s is low, else we stay at S3. This is shown in the testbench below. Besides 
//movement through states, the testbench was also used to test the assigned outputs mentioned above,
//these are vital to the datapath module and are tested below per state. 

module controller1_testbench();
	logic s, done, A_zero, a0, clk, reset,right_shiftA, load_A, incr_result;
	
	controller1 dut(.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 
	
	
	initial begin 
	reset <= 1;	A_zero =0; s<=0;   	@(posedge clk)// Starts at state S1 with reset
	reset <= 0;						@(posedge clk)// Outputs load_A as ~s
										@(posedge clk)
										@(posedge clk)
	s <= 1; 							@(posedge clk)// Goes to state S2 and outputs right_ShiftA
	s <= 0;							@(posedge clk)// Outputs 
										@(posedge clk)
	a0 <= 1;							@(posedge clk)// Only outputs incr_result if a0 = 1
	a0 <= 0;							@(posedge clk)
	a0 <= 0;							@(posedge clk)
	a0 <= 1;							@(posedge clk)
   a0 <= 1;                	@(posedge clk)
										@(posedge clk)
	A_zero <= 1;					@(posedge clk)// Goes to state S3 and outputs done 
	A_zero <=0;	s <=1;			@(posedge clk)// Stays on S3
										@(posedge clk)
	s <= 0;							@(posedge clk)// Returns to S1
										@(posedge clk)
										@(posedge clk)
	$stop;
	end
endmodule
					
	