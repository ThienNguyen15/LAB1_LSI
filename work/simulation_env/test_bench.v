module boundFlasher_tb;
    reg clk;
    reg flick;
    wire [15:0] lamps;
    
    boundFlasher UUT
    (
        clk, flick, lamps
    );

    // Create clock
    always #1 clk = !clk;

    initial begin
		// Reset state
        clk = 0;
        flick = 0;
        #15;

		// Normal Test Slide (Has no Flick in Progress)
        flick = 1;
        #15;
        flick = 0;
	
		// Normal Test Slide (Has Flick in Progress)
		@(UUT.state == 3)
			begin
				#8000;
				flick = 1;
			end
		#15;
		@(UUT.state == 2) flick = 0;

		// My_test
		@(UUT.state == 3) flick = 1;
		#15;        
		@(UUT.state == 2) flick = 0;
		#15;
		@(UUT.state == 3)
			begin
				#8000;
				flick = 1;
			end
		#15;
		@(UUT.state == 2) flick = 0;
		#15;
		@(UUT.state == 3)
			begin
				#8000;
				flick = 1;
			end
		#15;
		@(UUT.state == 2) flick = 0;
		#15;
		@(UUT.state == 5) flick = 1;
		#15;
		@(UUT.state == 4) flick = 0;
		#15;
		flick = 0;
		#50000;
		$finish;
    end

    initial begin
		$recordfile ("waves");
		$recordvars ("depth=0", boundFlasher_tb);
    end

endmodule
