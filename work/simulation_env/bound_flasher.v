`timescale 1ns / 1ps
module boundFlasher(input clk, flick, output [15:0] lamps);
	// Define States & some parameters
	parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7;
	parameter time_limit = 500;
	integer counter = 0;
	reg [3:0] state = s0;
	reg [15:0] temp;

	// State Machine
	always @(posedge clk)
	begin
		case(state)
			s0:
				begin
					temp <= 16'h0000;
					if(flick == 0) state <= s0;
					else state <= s1;
				end
			s1:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= (temp << 1) + 1;
						end
					if(temp == 16'h003F)
						begin
							counter <= 0;
							state <= s2;
						end
				end
			s2:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= temp >> 1;
						end
					if(temp == 16'h0000)
						begin
							counter <= 0;
							state <= s3;
						end
				end
			s3:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= (temp << 1) + 1;
						end
					if(temp == 16'h003F)
						begin
							if(flick == 1)
								begin
									counter <= 0;
									state <= s2;
								end
						end
					else if(temp == 16'h07FF)
						begin
							counter <= 0;
							if(flick == 1) state <= s2;
							else state <= s4;
						end
				end
			s4:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= temp >> 1;
						end
					if(temp == 16'h001F)
						begin
							counter <= 0;
							state <= s5;
						end
				end
			s5:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= (temp << 1) + 1;
						end
					if(temp == 16'h003F || temp == 16'h07FF)
						begin
							if(flick == 1)
								begin
									counter <= 0;
									state <= s4;
								end
						end
					else if(temp == 16'hFFFF)
						begin
							counter <= 0;
							state <= s6;
						end
				end
			s6:
				begin
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							temp <= temp >> 1;
						end
					if(temp == 16'h0000)
						begin
							counter <= 0;
							state <= s7;
						end
				end
			s7:
				begin
					temp <= 16'hFFFF;
					counter <= counter + 1;
					if(counter == time_limit)
						begin
							counter <= 0;
							state <= s0;
						end
				end
		endcase
	end

	// Assign Output
	assign lamps = temp;

endmodule
