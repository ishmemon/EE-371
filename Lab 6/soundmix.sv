//The soundmiq_out module takes in 7 24 bit sound logics and cycles throuhg each 
//of them using an FSM. The output (which is the sound we are on) is q_out and this
//module takes in the slow clock and a reset.
module soundmix (clk, reset, q_out1, q_out2, q_out3, q_out4, q_out5, q_out6, q_out);
	input logic clk, reset;
	input logic [23:0] q_out1, q_out2, q_out3, q_out4, q_out5, q_out6;
	output logic [23:0] q_out;
	
	enum {S1, S2, S3, S4, S5, S6} ps, ns;
	
	//If reset we go to the first state.
	always_ff @(posedge clk)
		if (reset)
	   	ps <= S1;
		else ps <= ns;
	//The always_comb always increments the state 
	//so we can go through the 6 stage sound.
	always_comb begin 
		case (ps)
			S1: ns = S2;
			S2: ns = S3;
			S3: ns = S4;
			S4: ns = S5;
			S5: ns = S6;
			S6: ns = S1;
		endcase
	end
	//Assign q_out depending on what the state is 
	always_comb begin
		case (ps)
			S1: q_out = q_out1;
			S2: q_out = q_out2;
			S3: q_out = q_out3;
			S4: q_out = q_out4;
			S5: q_out = q_out5;
			S6: q_out = q_out6;
	   endcase
	end 
endmodule

module soundmix_testbench();
	logic clk, reset;
	logic [23:0] q_out1, q_out2, q_out3, q_out4, q_out5, q_out6, q_out;
	
	soundmix dut(.*);
	
	 // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	 
	 initial begin
		reset = 1; q_out1 = 24'd1; q_out2 = 24'd2; q_out3 = 24'd3; q_out4 = 24'd4;
		q_out5 = 24'd5; q_out6 = 24'd6; @(posedge clk);
		reset = 0; @(posedge clk);
		repeat (10) @(posedge clk);
		$stop;
	 end
	 
endmodule 
		