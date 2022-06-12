module bccontrol (clk, start, reset, result_z, a_eq_0, a0, loadA, done, rsA, result_incr);
	input logic clk, start, reset, a_eq_0, a0;
	output logic result_z;
   output logic loadA, done, rsA, result_incr;
	
	enum {S1, S2, S3} ps, ns;
	//Rest signal is handled here
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S1;
		else 
			ps <= ns;
   end
	
	//Combinational logic to implement the FSM in the control path ASM chart.
	always_comb begin
		case (ps) 
		S1: begin
			if (start) ns = S2;
		   else ns = S1;	
		end
		S2: begin
			if (a_eq_0) ns = S3;
			else ns = S2;
		end
		S3: begin
			if (start) ns = S3;
			else ns = S1;
		end
		endcase
	end
	
	//Logic to assign the Mealy and Moore outputs
	assign result_z = (ps == S1);
	assign loadA = ((ps == S1) & (~start));
	assign done = (ps == S3);
	assign rsA = (ps == S2);
	assign result_incr = ((ps == S2) & (~a_eq_0) & (a0));
endmodule 

//We made a simple testbench for the control. We start at reset and then change the
//inputs one by one to make sure that state transition is going correctly and that the
//correct outputs are being true at the correct times. 
module bccontrol_testbench();
	logic clk, start, reset, a_eq_0, a0;
	logic result_z;
   logic loadA, done, rsA, result_incr;
	
	// using SystemVerilog's implicit port connection syntax for brevity
	bccontrol dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 

	 
	initial begin 
	   //We should go S1 to S2 to S3 to S1. IT should also stay in the middle and stay
		//in the state for 1 cycle more.
		reset = 1; @(posedge clk);
		reset = 0; @(posedge clk);
		@(posedge clk);
		//The a0 being 1 will allow the result_incr to be tested too.
		start = 1; a0 = 1; a_eq_0 = 0; @(posedge clk);
		@(posedge clk);
		a_eq_0 = 1; @(posedge clk);
		@(posedge clk);
		start = 0; @(posedge clk);
   end
	
endmodule  