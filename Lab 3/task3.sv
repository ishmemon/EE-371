module task3 (clk, reset, writedata_left1, writedata_left3, read, write);
        input logic clk, reset, read, write;
        input logic signed [23:0] writedata_left1;
        output logic signed [23:0] writedata_left3;
	//TASK 3
	
	//Uses the inputs from the left1/right1 and left2/right2 and creates new temp
	//outputs that are used to remove noise
	//The first number we will try is divide by 4. So N = 4 and n = 2
	//I think the plan is to take each incoming bit of data 1 and 2 from both tasks
	//divide each value by N and store in FIFO buffer of size N
	//So we need 4 divided logics. 
	//The first number for N = 4 did not do anything so we will try doing a bigger number
	//to smooth things out more. N = 1024 , so 2^10.
	logic signed [23:0] divided2;
	
	assign divided2 = {{3{writedata_left1[23]}}, writedata_left1[23:3]};
	
	//All of the divideds now go into the buffer. The buffers outputs are stored.
	//The buffer should not started reading until full is hit. And then new things can come 
	//The reason its not working could be because full is now used circularly
	logic [23:0] buff2;
	logic empty2;
	logic full2;
 
	fifo b2 (.clk, .reset, .rd(read & full2), .wr(write), .empty(empty2), .full(full2), .w_data(divided2), .r_data(buff2)); 
	
	//The buffer's output is subtracted from the divided and that goes in accumulator's flip flop
	logic signed [23:0] d2, sum1;
	logic signed [23:0] q2;
	

	
	
	//They all also go into the accumulator which is just a flip flop
	accumulator accum2 (.q(q2), .d(d2), .enable(read), .clk(clk), .reset(reset));
	assign sum1 = full2 ? (divided2 - buff2) : divided2;
	assign d2 =  q2 + sum1;
	
	//Since both writedata_left1 and writedata_right1 are the same we can assign both
	//writedata_left3 and writedata_right3 to be equal to d2.
	assign writedata_left3 = d2;
   
 endmodule

 
 //A testbench for this module averages a few signals. What we do is add a few values to
 //the module and the module should average N samples and kick out the N+1 sample as well
 //Since the implementation is the same for all the 4 inputs I just focus on one input and 
 //one output for simplicity.
 module task3_testbench();
        logic clk, reset, read, write;
        logic signed [23:0] writedata_left1;
        logic signed [23:0] writedata_left3;
	 task3 dut (.*);
	 
	 parameter CLOCK_PERIOD=100;  
	initial begin   
	clk <= 0;  
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clk 
	end 
	
	initial begin 
	//Initial them all to 0
		reset = 1; writedata_left1 = 0; 
					@(posedge clk);
			//I set them both read and write to 1. it should not write until full.
		reset = 0; write = 1; read = 1; writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					repeat (10) @(posedge clk);
					@(posedge clk);
//The buffer size is 16 so the average now should be computed and subsequent averages
//should be diff since the old data is being kicked out. 
		writedata_left1 = 10; 
					@(posedge clk);
					@(posedge clk);
		writedata_left1 = 10; 
					repeat(16) @(posedge clk);
					@(posedge clk);
									 
									 
  $stop; // End the simulation.  
 end  
endmodule 
	