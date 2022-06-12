module searchctrl (clk, reset, s, c_0, mem_g, mem_l, done, found, c_d_2, incr_i, decr_i, load_mem, init);
	input logic clk, reset, s, c_0, mem_g, mem_l;
	output logic done, found, c_d_2, incr_i, decr_i, load_mem, init;
	
	enum {S1, S2, S3, S4, S5} ps, ns;
	
	//Reset case
	always_ff @(posedge clk)
		if (reset) 
			ps <= S1;
		else 
			ps <= ns;
			
	//Next state logic
	always_comb begin
		case(ps)
			S1: begin
				if (s) ns = S2;
			   else ns = S1;	
			end
			S2: begin
				if (c_0) ns = S3;
			   else if (mem_g) ns = S5; 
			   else if (mem_l) ns = S4;
			   else ns = S3;	
			end
			S3: begin
				if (s) ns = S3;
				else ns = S1;
			end
			S4: begin
				ns = S2;
         end	
			S5: begin
				ns = S2;
			end
		
		endcase 
	end
	
	//Output assignments
	assign load_mem = (ps == S2);
	assign done = (ps == S3);
	assign c_d_2 = (ps == S2) & (~c_0) & (mem_g | mem_l);
	assign incr_i = (ps == S4);
	assign decr_i = (ps == S5);
	assign init = (ps == S1) & (~s);
	assign found = (ps == S2) & (~c_0) & (~mem_g) & (~mem_l);
	
endmodule 

//We made a simple testbench for the control. We start at reset and then change the
//inputs one by one to make sure that state transition is going correctly and that the
//correct outputs are being true at the correct times. 
module searchctrl_testbench();
	logic clk, reset, s, c_0, mem_g, mem_l;
	logic done, found, c_d_2, incr_i, decr_i, load_mem, init;
	
	// using SystemVerilog's implicit port connection syntax for brevity
	searchctrl dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 

	 
	initial begin 
	   //We should go S1 to S2 to S3 to S1. Then to S2 and S4 and S2 and S5 and S2 and S3.
		reset = 1; @(posedge clk);
		reset = 0; s = 0; @(posedge clk);
		@(posedge clk);
		//The a0 being 1 will allow the result_incr to be tested too.
		s = 1; @(posedge clk);
		c_0 = 1; @(posedge clk);
		c_0 = 0; s = 0; @(posedge clk);
		s = 1; @(posedge clk);
		mem_g = 1; @(posedge clk);
		@(posedge clk);
		mem_g = 0; mem_l = 1; @(posedge clk);
		@(posedge clk);
		c_0 = 0; mem_g = 0; mem_l = 0; @(posedge clk);
		@(posedge clk);
   end
	
endmodule  