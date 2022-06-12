//This module takes in the count_clock counter that has the number of seconds
//and displays it on the HEX's the HEX1 and HEX0 display the minutes and the HEX3 and HEX2
//display hours. To allow the clock to be seen and the minutes to move at a reasonable
//pace we display the 15, 30, 45, and 00 minutes not the other edges.
module display_clock (count_clock, HEX0, HEX1, HEX2, HEX3);
	input logic [16:0] count_clock;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	//These logics are here to contain the values we will put in the seg7 displays to 
	//display the hex.
	logic [3:0] hex0, hex1, hex2, hex3;
	seg7 h0 (.hex(hex0), .leds(HEX0));
	seg7 h1 (.hex(hex1), .leds(HEX1));
	seg7 h2 (.hex(hex2), .leds(HEX2));
	seg7 h3 (.hex(hex3), .leds(HEX3));
	//We know that there are only 60 minutes in an hour. There are 3600 seconds in a minute,
	//so only the we can mod by 3600.
	logic [16:0] minu;
	assign minu = count_clock%(17'd3600);
   always_comb begin	
	//If below 15 we display 00
		if (minu < 17'd900) begin
			hex0 = 4'h0;
			hex1 = 4'h0;
		//If between 15 and 30 we display 15.
		end else if ((minu > 17'd900) & (minu < 17'd1800)) begin
			hex0 = 4'h1;
			hex1 = 4'h5;
		//If between 30 and 45 we display 30.
		end else if ((minu < 17'd2700) & (minu > 17'd1800)) begin
			hex0 = 4'h3;
			hex1 = 4'h0;
		//Else we display 45.
		end else begin
			hex0 = 4'h4;
			hex1 = 4'h5;
		end
	end
	
	//We can divide by 3600 to get the hour value. It truncates so we can just use that
	logic [16:0] hours;
	logic [3:0] hourright, hourtemp;    
	assign hours = count_clock/17'd3600;
	assign hourright = hours[3:0];
	always_comb begin
		//If it is greater than 9 then we need to make sure the decimal is displayed
		//not the HEX.
		if (hours > 17'd9) begin
			//If between 10 and 15 the left hex is 1 and right hex is what it was before -10
			if (hours < 17'd16) begin
				hex2 = 4'h1;
				hex3 = hourright - 4'd10;
			//If between 16 and 29 then the left hex is 1 but the right hex needs to be added 6
      	//because it starts at 10 when we are at 16 and ends at 13 when we are at 19.
			end else if (hours > 17'd15 & hours < 17'd20) begin
				hex2 = 4'h1;
				hex3 = hourright + 4'd6;
			//If between 20 and 24 the left hex is 1 and right hex is what it was -4
			//It starts at 14 when we are at 20 and ends at 18 when we are at 24. Since
			//We only care about ones digit we can just do -4.
			//?????????????
			end else begin
				hex2 = 4'h2;
				hex3 = hourright - 4'h4;
			end
		//Else we just do the normal thing since the hex will dispaly correctly and the left
		//hex is just 0
		end else begin
			hex2 = 4'h0;
			hex3 = hours;
		end
	
	end 
endmodule  

//The testbench tests a few values of the count to see if the hours and seconds are 
//displayed right.
module display_clock_testbench();
	logic [16:0] count_clock;
	logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	display_clock dut(.*);
	
	 
	 initial begin
	 //This is supposed to display 00:00
	 count_clock <= 17'd800; 
	 #10;
	 //This is supposed to display 00:15
	 count_clock <= 17'd1200; 
	 #10;
	 //This is supposed to display 00:30
	 count_clock <= 17'd2000; 
	 #10;
	 //This is supposed to display 00:45
	 count_clock <= 17'd3200;
	 #10;
	 //This is supposed to display 02:45
	 count_clock <= 17'd9900; 
	 #10;
	 //This is supposed to display 11:45
	 count_clock <= 17'd42300; 
	 #10;
	 //This is supposed to display 18:45
	 count_clock <= 17'd67500; 
	 #10;
	 //This is supposed to display 21:45
	 count_clock <= 17'd78300;
	 #10;
	 $stop;
	 
	 end
	 
	 
endmodule 