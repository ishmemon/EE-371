/* Attribution: This file was contributed by the UW Electrical Engineering Faculty.

FIFO buffer FWFT implementation for specified data and address
 * bus widths based on internal register file and FIFO controller.
 * Inputs: 1-bit rd removes head of buffer and 1-bit wr writes
 * w_data to the tail of the buffer.
 * Outputs: 1-bit empty and full indicate the status of the buffer
 * and r_data holds the value of the head of the buffer (unless empty).
 */
 
 //The data_width is 24. Address is 16 bit
/* FIFO buffer FWFT implementation for specified data and address
 * bus widths based on internal register file and FIFO controller.
 * Inputs: 1-bit rd removes head of buffer and 1-bit wr writes
 * w_data to the tail of the buffer.
 * Outputs: 1-bit empty and full indicate the status of the buffer
 * and r_data holds the value of the head of the buffer (unless empty).
 */
module fifo #(parameter DATA_WIDTH=24, ADDR_WIDTH=3)
            (clk, reset, rd, wr, empty, full, w_data, r_data);

	input  logic clk, reset, rd, wr;
	output logic empty, full;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	logic w_en;
	
	// enable write only when FIFO is not full
	// or if reading and writing simultaneously
	assign w_en = wr & (~full | rd);
	
	// instantiate FIFO controller and register file
	fifo_ctrl #(ADDR_WIDTH) c_unit (.*);
	reg_file #(DATA_WIDTH, ADDR_WIDTH) r_unit (.*);
	
endmodule  // fifo

/* A testbench for this module keeps read and write asserted the WHOLE TIMe because 
the expected behavior we wish to see
is that once the buffer is full then only do we start reading.  
*/
module fifo_testbench();
	logic clk, reset, rd, wr, empty, full;
   logic [23:0] w_data, r_data;
	
	fifo dut (clk, reset, rd, wr, empty, full, w_data, r_data);
	
	// Set up a simulated clk.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
	clk <= 0;  
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clk 
	end 
	
	initial begin  
                      @(posedge clk);   
	reset <= 1;         @(posedge clk); // Always reset FSMs at start  
							@(posedge clk);   
   rd <= 1; wr <= 1; w_data <= 24'h00000F; @(posedge clk);  //We set rd and wr = 1 and set
			 @(posedge clk);                                     //a w_data
			  @(posedge clk);
			   @(posedge clk);                          //Now the buffer has to be filled and then
				 @(posedge clk);									//it should read.
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
						  @(posedge clk);
						   @(posedge clk);
							 @(posedge clk);
							  @(posedge clk);
							   @(posedge clk);
								 @(posedge clk);
  $stop; // End the simulation.  
 end  
endmodule 
	
	
	
