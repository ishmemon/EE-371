//Task 1 controls the instantiation of the datapath and controller for the bit counter.
//It takes in the switch values that make up the number, start, and reset, and ouputs
//done and result which is the number of 1's in the number.
module task1 (switchAdd,s,done,result, clk,reset);
		
		//port definitions
		input logic clk, reset, s;
		input logic [7:0] switchAdd;
		output logic done;
		output logic [3:0] result;
		
		//internal logic
		logic load_A, incr_result, right_shiftA, A_zero;
		logic [7:0] A;
		
		
		
		datapath1 bitCounter (.A,.right_shiftA,.load_A,.result, .incr_result, .switchAdd, .clk,.reset);
	   
		controller1 bitCounter1 (.right_shiftA, .s, .done, .load_A, .incr_result, .A_zero(A[7:0]==8'b0), .a0(A[0]), .clk, .reset);
		

endmodule

//This testbench tests some simple cases of the countOnes and display the number of
//ones correctly in our test.
module task1_testbench();
	logic [7:0] switchAdd;
	logic s,done,clk,reset;
	logic [3:0] result;
	
	task1 dut (.*);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
   end 
	
	initial begin
 reset <= 1;     @(posedge clk);
        reset <= 0; switchAdd <= 8'b00000000; s <= 1; @(posedge clk); // should display 0
        s <= 0;            @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
        switchAdd <= 8'b11011001; @(posedge clk); // should display 5
                @(posedge clk);
                @(posedge clk);
        s <= 1; @(posedge clk); // start computation
        s <= 0;    @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
        s <= 1; @(posedge clk);
        s <= 0;    @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

    $stop;
    end
endmodule

	