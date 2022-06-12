module searchdata (clk, a, c_0, mem_g, mem_l, c_d_2, incr_i, decr_i, load_mem, init, loc);
	input logic clk, c_d_2, incr_i, decr_i, load_mem, init;
	input logic [7:0] a;
	output logic c_0, mem_g, mem_l;
	output logic [4:0] loc;
	
	//A temp variable that stores a and other internal logic that will help compare
	//and compute adresses
	logic [7:0] temp;
	logic [4:0] c, i;
	logic [7:0] mem;
	logic [7:0] check;
	
	//Call the memory file. We don't write so write is 0 and dataIn is not care.
	//The mem logic has that adress of memory
	task2mem t2m (.clk, .address(i), .dataIn(8'b00000000), .write(1'b0), .dataOut(mem));
	
	//datapath logic
	 always_ff @(posedge clk) begin
		if (init) begin
			temp <= a;
			c <= 5'b10000;
			i <= 5'b10000;
		end
		else if (c_d_2) begin
			c <= (c/2);
		end
      else if (incr_i) begin
			i <= i+c;
		end
		else if (decr_i) begin
			i <= i-c;
		end
		else if (load_mem) begin
			check <= mem;
		end
	end
	
	//Assign outputs
	assign c_0 = (c == 8'b0000000);
	assign mem_g = (check > temp);
	assign mem_l = (check < temp);
	
	assign loc = i;
	
endmodule 
`timescale 1 ps / 1 ps
//In this testbench we assert each of the control signals individually to see
//whether the result and new_A behaves as expected. We also observe the output status
//signals.
module dcdatapath_testbench();
	logic clk, c_d_2, incr_i, decr_i, load_mem, init;
	logic [7:0] a;
	logic c_0, mem_g, mem_l;
	logic [4:0] loc;
	
	searchdata dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 

	 
	initial begin 
	   //We are going to make each of the control signals true and then false  
		a = 8'b00000001; init = 1; @(posedge clk);
		@(posedge clk);
		init = 0; c_d_2 = 1; @(posedge clk);
		@(posedge clk);
		c_d_2 = 0; incr_i = 1; @(posedge clk);
		@(posedge clk);
		incr_i = 0; decr_i = 1; @(posedge clk);
		@(posedge clk);
		decr_i = 0; load_mem = 1; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

	end
	
endmodule  