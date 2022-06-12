//This module universal clock is basically a counter. All it does is take reset and if 
//reset is 1 its 0 also when we hit 86,400 (how many seconds in a day) we reset as well.
//Each clock edge is 1 second. The 17 bit output can hold the 86,400 and it is just
//a count of how many seconds have passed. 
module universal_clock (clk, reset, count_clock);
	input logic clk, reset;
	output logic [16:0] count_clock;
	
	//If reset or count_clock = 86,399 then we have set count_clock to 0, else we increment
	//by 1.
	always_ff @(posedge clk) begin
		if (reset) begin
			count_clock = 17'b00000000000000000;
		end else if (count_clock == 17'b10101000101111111) begin
			count_clock = 17'b00000000000000000;
		end else begin
			count_clock = count_clock + 1;
		end
	end
endmodule

//The testbench just goes through a few edges to make sure we are doing this right.
module universal_clock_testbench();
	logic reset, clk;
	logic [16:0] count_clock;
	
	universal_clock dut(.*);
	
	 // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	 
	 initial begin
	 
	 reset <= 1; @(posedge clk);
	 reset <= 0; @(posedge clk);
	 repeat (86401) @(posedge clk); 
	 $stop;
	 end
	 
endmodule 