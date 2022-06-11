/* Top-level module for DE1-SoC hardware connections to implement a fullAdder.
 *
 * The inputs are connected to switches (a - SW2, b - SW1, cin - SW0).
 * The outputs are connected to LEDs (sum - LEDR0, cout - LEDR1).
 */
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0, LEDR);
   input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	inout logic [33:0] GPIO_0;
	//input  logic  [3:0]  KEY;                               // True when not pressed, False when pressed  
	//input  logic  [9:0]  SW; 
	
	
	//I have to do the port GPO thing and call the occupancy to make it all work
	logic reset;
	logic outer;
	logic inner;
	
	//These are the switches connected to the photosensor
	assign reset = GPIO_0[5];
	assign outer = GPIO_0[6];
	assign inner = GPIO_0[7];
	
	//These are the two LEDs indicating outer and inner signals.
	assign GPIO_0[26] = GPIO_0[6];   //Outer
	assign GPIO_0[27] = GPIO_0[7];   //Inner
	
	//Here we call the occupany module
	occupancy parking_lot (.clk(CLOCK_50), .reset, .outer, .inner, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

endmodule  // DE1_SoC


/* testbench for the DE1_SoC */
module DE1_SoC_testbench();
   logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 	
	logic [9:0] LEDR;
	//logic  [3:0]  KEY;   
	//logic  [9:0]  SW; 
	// inout pins must be connected to a wire type 
   wire  [33:0] GPIO_0; 
   // additional logic required to simulate inout pins 
   logic [33:0] GPIO_0_in; 
   logic [33:0] GPIO_0_dir;  // 1 = input, 0 = output 
	 
	
	// set up tristate buffers for inout pins 
   genvar i; 
   generate 
      for (i = 0; i < 34; i++) begin : gpio 
         assign GPIO_0[i] = GPIO_0_dir[i] ? GPIO_0_in[i] : 1'bZ; 
      end 
   endgenerate 
	
	// using SystemVerilog's implicit port connection syntax for brevity
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .GPIO_0, .LEDR);
	
	//Set up a clock
	parameter CLOCK_PERIOD=100;  
		initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
   end 

	 
	 initial begin 
      // you only need to set the pin directions once 
      GPIO_0_dir[6]  = 1'b1; 
      GPIO_0_dir[26] = 1'b0; 
		GPIO_0_dir[7]  = 1'b1; 
      GPIO_0_dir[27] = 1'b0; 
      // manipulate the GPIO_0 input bits indirectly through GPIO_0_in 
	   GPIO_0_in[6] = 1'b1; GPIO_0_in[7] = 1'b1; #50; 
		GPIO_0_in[6] = 1'b0; GPIO_0_in[7] = 1'b1; #50;
		GPIO_0_in[6] = 1'b1; GPIO_0_in[7] = 1'b0; #50;
		GPIO_0_in[6] = 1'b0; GPIO_0_in[7] = 1'b0; #50;
		
   end
	
endmodule  // DE1_SoC_testbench
