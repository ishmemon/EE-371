module dcdatapath (a, loadA, done, rsA, result_incr, result_z, a_eq_0, a0, result);
	input logic [7:0] a;
	input logic loadA, done, rsA, result_incr, result_z;
	output logic a_eq_0, a0;
	output logic [3:0] result;
	
	//The new_A is the a with the shifts accounted for. I dont need to send this off
	//anywhere so it does not need to be outputted.
	logic [7:0] new_A;
	
	/*always_comb begin 
		if (loadA) begin
			new_A = a;
		end else if (rsA) begin
			new_A[7] = a[7];
			new_A[6:0] = a[7:1];
		end else if (result_incr) begin
			result = result + 1;
		end else if (result_z) begin 
			result = 4'b0000;	
		end
	end*/
	
	//We assign the ouputs we have to use new_A since a is not altered.
	assign a_eq_0 = (new_A == 0);
	assign a0 = new_A[0];
endmodule 

//In this testbench we assert each of the control signals individually to see
//whether the result and new_A behaves as expected. We also observe the output status
//signals.
module dcdatapath_testbench();
	logic [7:0] a;
	logic loadA, done, rsA, result_incr, result_z;
	logic a_eq_0, a0;
	logic [3:0] result;
	logic clk;
	
	dcdatapath dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 

	 
	initial begin 
	   //We are going to make each of the control signals true and then false  
		loadA = 1; @(posedge clk);
		@(posedge clk);
		loadA = 0; rsA = 1; @(posedge clk);
		@(posedge clk);
		rsA = 0; result_z = 1; @(posedge clk);
		@(posedge clk);
		result_z = 0; result_incr = 1; @(posedge clk);
		//We keep the result_incr on a few cycles to make sure the incrementing is going right
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
	end
	
endmodule  