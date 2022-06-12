//This is a module that checks if the time the user inputs (via the switches) is equal
//to the count_clock, which represents the moving clock in our project. The input is the
//swithces and the count_clock and the ouput ring is asserted if the alarm time is equal
//to the clock time, AND the ring will stay asserted for 30 more clock cycles after the time
//are equal (so total of 31 edges its asserted).
// The user enters the times in military standard so 5 pm is 17:00. We only need
//7 swithces, the last two allow us to chose between the :00. :15. :30, and :45 and the
//other 5 allow us to chose from 0-24 (if 25-32 are there we have to wait the next "day" so
//for the entire 24 hours to happen.
module alarm_time (clk, SW, count_clock, ring);
	input logic clk;
	input logic [6:0] SW;
	input logic [16:0] count_clock;
	output logic ring;
	
	//Declare logics.
	logic [16:0] hour;
	logic [16:0] min;
	logic [16:0] compare;
	
	//This part calculates the time and puts it into a 17 bit logic so we can compare
	//it with the count_clock;
	assign hour[4:0] = SW[6:2];
	assign hour[16:5] = 12'd0; 
	assign min[1:0] = SW[1:0];
	assign min[16:2] = 15'd0;
	assign compare = (hour*17'd3600) + (min*17'd900);
	
	//The way I chose to assert ring for 30 edges is by having the condition to assert ring
	//be that compare is equal to count_clock or count_clock - 1 or count_clock - 2 all the
	//way to 30 so ring is asserted for the whole time.
	assign ring = ((compare == count_clock) | (compare == (count_clock-17'd1)) | 
	(compare == (count_clock-17'd2)) | (compare == (count_clock-17'd3)) |
	(compare == (count_clock-17'd4)) | (compare == (count_clock-17'd5)) |
	(compare == (count_clock-17'd6)) | (compare == (count_clock-17'd7)) |
	(compare == (count_clock-17'd8)) | (compare == (count_clock-17'd9)) | 
	(compare == (count_clock-17'd10)) | (compare == (count_clock-17'd11)) |
	(compare == (count_clock-17'd12)) | (compare == (count_clock-17'd13)) |
	(compare == (count_clock-17'd14)) | (compare == (count_clock-17'd15)) |
	(compare == (count_clock-17'd16)) | (compare == (count_clock-17'd17)) |
	(compare == (count_clock-17'd18)) | (compare == (count_clock-17'd19)) |
	(compare == (count_clock-17'd20)) | (compare == (count_clock-17'd21)) |
	(compare == (count_clock-17'd22)) | (compare == (count_clock-17'd23)) |
	(compare == (count_clock-17'd24)) | (compare == (count_clock-17'd25)) |
	(compare == (count_clock-17'd26)) | (compare == (count_clock-17'd27)) |
	(compare == (count_clock-17'd28)) | (compare == (count_clock-17'd29)) |
	(compare == (count_clock-17'd30))	);
	
endmodule 

//The testbench just tests one possible alarm time and makes sure ring is asserted
//when the alarm time equals clock time and that ring is asserted for the whole 31 edges.
module alarm_time_testbench();
	logic [6:0] SW;
	logic [16:0] count_clock;
	logic ring, clk;
	
	alarm_time dut(.*);
	
		 // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	 
	 initial begin
	    //Switch is 0000001 so 00:15 we start count_clock at 898 so 14 min and 58 sec 
		 SW = 7'b0000001; count_clock = 17'd898; @(posedge clk);
		 count_clock = 17'd899; @(posedge clk);
		 //The alarm should ring now and do so until count_clock equals 931.
		 count_clock = 17'd900; @(posedge clk);
		 
		 count_clock = 17'd901; @(posedge clk);
		 count_clock = 17'd902; @(posedge clk);
		 count_clock = 17'd903; @(posedge clk);
		 count_clock = 17'd904; @(posedge clk);
		 count_clock = 17'd905; @(posedge clk);
		 count_clock = 17'd906; @(posedge clk);
		 count_clock = 17'd907; @(posedge clk);
		 count_clock = 17'd908; @(posedge clk);
		 count_clock = 17'd909; @(posedge clk);
		 count_clock = 17'd910; @(posedge clk);
		 count_clock = 17'd911; @(posedge clk);
		 count_clock = 17'd912; @(posedge clk);
		 count_clock = 17'd913; @(posedge clk);
		 count_clock = 17'd914; @(posedge clk);
		 count_clock = 17'd915; @(posedge clk);
		 count_clock = 17'd916; @(posedge clk);
		 count_clock = 17'd917; @(posedge clk);
		 count_clock = 17'd918; @(posedge clk);
		 count_clock = 17'd919; @(posedge clk);
		 count_clock = 17'd920; @(posedge clk);
		 count_clock = 17'd921; @(posedge clk);
		 count_clock = 17'd922; @(posedge clk);
		 count_clock = 17'd923; @(posedge clk);
		 count_clock = 17'd924; @(posedge clk);
		 count_clock = 17'd925; @(posedge clk);
		 count_clock = 17'd926; @(posedge clk);
		 count_clock = 17'd927; @(posedge clk);
		 count_clock = 17'd928; @(posedge clk);
		 count_clock = 17'd929; @(posedge clk);
		 count_clock = 17'd930; @(posedge clk);
		 count_clock = 17'd931; @(posedge clk);
		 count_clock = 17'd932; @(posedge clk);
		 count_clock = 17'd933; @(posedge clk);
		 count_clock = 17'd934; @(posedge clk);
	 
	 $stop;
	 end
	 
endmodule