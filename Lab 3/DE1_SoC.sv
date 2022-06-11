//This will be top level it contains both task 1 and 2 code and a swithc input that 
//allows switch 9 to control the two.
module DE1_SoC (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, SW);

	input logic CLOCK_50, CLOCK2_50;
	input logic [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	//Edited was not in default
	input logic [9:0] SW;
	
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	
	//Flip flops allow us to metastabilized SW[9] so it can be used as the toggler.
	//We use 2 flip flops. 
	logic controlDummy;
	logic controlSwitch;
	flop f3(.q(controlDummy), .d(SW[9]), .clk(CLOCK_50), .Reset(1'b0));
	flop g3(.q(controlSwitch), .d(controlDummy), .clk(CLOCK_50), .Reset(1'b0));
	
	//Flip flops allow us to metastabilized SW[8] so it can be used as the toggler.
	//We use 2 flip flops. The control switch is controlswitch3 since it controls task3 
	logic controlDummy3;
	logic controlSwitch3;
	flop f4(.q(controlDummy3), .d(SW[8]), .clk(CLOCK_50), .Reset(1'b0));
	flop g4(.q(controlSwitch3), .d(controlDummy3), .clk(CLOCK_50), .Reset(1'b0));
	
	//4 logics 2 for each task and then we use a control switche (sw9) to toggle which one
	//is displayed.
	logic signed [23:0] writedata_left1;
	logic signed [23:0] writedata_right1;
	logic signed [23:0] writedata_left2;
	logic signed [23:0] writedata_right2;
	//For task 3 we need 4 more logics that are the filtered version and we use sw8 to toggle
	logic signed [23:0] writedata_left3;
	logic signed [23:0] writedata_right3;
	logic signed [23:0] writedata_left4;
	logic signed [23:0] writedata_right4;
	
	logic signed [23:0] temp_filtered_1;
	logic signed [23:0] temp_filtered_2;
	
	//TASK 2
	logic [15:0] address;
	logic [23:0] q_out;
	always_ff @(posedge CLOCK2_50) begin
	    if(reset) address <= 0;
		else begin
			address <= address + 1;
		end
	end 
	logic clock;
	assign clock = CLOCK2_50;
	
	rom_1_port rom(.address, .clock, .q(q_out));
	
	assign writedata_left1 = SW[8] ? writedata_left3: q_out;
	
	//TASK 1
	assign writedata_left2 = SW[8] ? writedata_left4 : readdata_left;
	
	task3 t_3 (.clk(CLOCK2_50), .reset, .writedata_left1(q_out), 
                .writedata_left3, .read, .write);
					 
	task3 t_4 (.clk(CLOCK2_50), .reset, .writedata_left1(readdata_left),
             .writedata_left3(writedata_left4), .read, .write);
	
	//Read and write always the same
	assign read = read_ready & write_ready;
	assign write = write_ready & read_ready;
	
	//Use sw9 (controlswithc) and sw8 to toggle between the two. if control swithc then
	//we chose between either task 1 or task 2 audio and the controlswithch3 tells us
	//whether its filtered or unfiltered.
	
// 	always_comb begin
// 		case ({controlSwitch, controlSwitch3})
// 			2'b00:  begin
// 					writedata_left = writedata_left2; 
// 					writedata_right = writedata_right2;
// 					end
// 			2'b01:	begin
// 					writedata_left = writedata_left4; 
// 					writedata_right = writedata_left4;				
// 				end
// 			2'b10: begin
// 					writedata_left = writedata_left1; 
// 					writedata_right = writedata_right1;
// 			end
// 			2'b11: begin	
// 					writedata_left = writedata_left3; 
// 					writedata_right = writedata_left3;
// 				end 
// 		endcase
// 	end

    assign writedata_left = SW[9] ? writedata_left2 : q_out;
    assign writedata_right = SW[9] ? writedata_left2 : q_out;
	
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


