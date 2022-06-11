//Attribution: This file was contributed by the UW Electrical Engineering Faculty.
/* Register file module for specified data and address bus widths.
 * synchronous read port (r_addr -> r_data) and synchronous write
 * port (w_data -> w_addr if w_en). I think they both should be synch
 */
module reg_file #(parameter DATA_WIDTH=8, ADDR_WIDTH=2)
                (clk, w_data, w_en, w_addr, r_addr, r_data);

	input  logic clk, w_en;
	input  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// array declaration (registers)
	logic [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];
	
	// write operation (synchronous)
	always_ff @(posedge clk)
	   if (w_en)
		   array_reg[w_addr] <= w_data;
	
	// read operation (asynchronous)
	assign r_data = array_reg[r_addr];
	
endmodule  // reg_file

/* This simple testbench writes to a few adresses and then reads from them. We also test
to make sure reading happens even if w_en is asserted. THe point of this is just to ensure
that the register file works properly.

*/
module reg_file_testbench();
	logic clk, w_en;
	logic [15:0] w_addr, r_addr;
	logic [23:0] w_data, r_data;
	
	reg_file dut (clk, w_data, w_en, w_addr, r_addr, r_data);
   
	// Set up a simulated clk.   
	parameter CLOCK_PERIOD=100;  
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clk 
	end  
	
	
	initial begin   	   
		//Here I write to adress 1
		w_addr <= 16'h0001; w_data <= 24'h00000F; w_en <= 1; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		//I turn off the write enable and read from adress 00001 
		r_addr <= 16'h0001; w_en <= 0; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk); 
	   //I then write to adress 2
	   w_addr <= 16'h0002; w_data <= 24'h00000F; w_en <= 1; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		//I read from adress 2 while keeping the write on to make sure it works for both
		//signals asserted.
		r_addr <= 16'h0002; @(posedge clk);   
                     @(posedge clk);   
                      @(posedge clk);
		$stop; // End the simulation.  
   end 
	
endmodule 
