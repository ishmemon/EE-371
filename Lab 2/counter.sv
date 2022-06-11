//This counter has 5 bit output and increments on each positive clock edge.
module counter (clk, reset, out);
	input logic clk, reset;
	output logic [4:0] out;

	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= 5'b00000;
		end else begin
			out <= out + 1;
		end
	
	end
endmodule 