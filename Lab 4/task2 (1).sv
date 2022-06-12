//This module compeltes task 2 by calling the control and datapath modules. It takes in 
//clk, reset, and a (the value searching) and starts and outputs done and loc (the
//address of the found thing) and found if it was found.
module task2 (clk, reset, a, s, done, loc, found);
	input logic clk, reset, s;
	input logic [7:0] a;
	output logic done, found;
	output logic [4:0] loc;
	
	//Declaration of internal signals and instantiation of control and datapath modules
	logic init, load_mem, c_0, mem_g, mem_l, c_d_2, decr_i, incr_i;
	searchctrl ctr (.clk, .reset, .s, .c_0, .mem_g, .mem_l, .done, .found, .c_d_2, .incr_i, .decr_i, .load_mem, .init);
	searchdata dta (.*);
	
endmodule

`timescale 1 ps / 1 ps
//This testbench tries searching for a few values in the original mif file which has
//the values 1-32 in order from adress 0 to 31.
module task2_testbench();
	logic [7:0] a;
	logic s, done, clk, reset, found;
	logic [4:0] loc;
	
	task2 dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 
	
	initial begin
	reset <= 1;     @(posedge clk);
   reset <= 0; a <= 8'b00000100; s <= 1; @(posedge clk); // we are searching for 4
	//so should display adress 3.
        s <= 0;            @(posedge clk);
                     repeat (16)   @(posedge clk);  //16 clk edges is more than enough time
							//to find out.
                        @(posedge clk);
		  a <= 8'b00000111; s <= 1;            @(posedge clk);  //searching for 7 adress should be 6
        s <= 0;            repeat (16)   @(posedge clk);  //16 clk edges is more than enough time
							//to find out.
                        @(posedge clk);
			s <= 1; a <= 0;            @(posedge clk);   //searching for 0 found should not be high
         s <= 0;            repeat (16)   @(posedge clk);  //16 clk edges is more than enough time
							//to find out.
                        @(posedge clk);

    $stop;
    end
endmodule

	
	
	