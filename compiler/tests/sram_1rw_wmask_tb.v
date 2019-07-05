`define assert(signal, value) \
if (!(signal === value)) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish;\
end

module sram_1rw_wmask_tb;
   reg 	     clk;

   reg [3:0] addr0;
   reg [1:0] din0;
   reg 	     csb0;
   reg 	     web0;
   reg  [1:0]    wmask0;
   wire [1:0] dout0;

   sram_2b_16_1rw_freepdk45 U0 (.DIN0(din0),
			    .DOUT0(dout0),
			    .ADDR0(addr0),
			    .csb0(csb0),
			    .web0(web0),
			    .wmask0(wmask0),
			    .clk0(clk)
			     );


   initial
     begin
	//$monitor("%g addr0=%b din0=%b dout0=%b",
	//	 $time, addr0, din0, dout0);


	clk = 1;
	csb0 = 1;
	web0 = 1;
	wmask0 = 2'b01;
	addr0 = 0;
	din0 = 0;

	// write
	#10 din0=2'b10;
	addr0=4'h1;
	web0 = 0;
	csb0 = 0;
	wmask0 = 2'b10;

	// read
	#10 din0=2'b11;
	addr0=4'h1;
	web0 = 1;
	csb0 = 0;

	#10 `assert(dout0, 2'b1x)

	// write another
	#10 din0=2'b01;
	addr0=4'hC;
	web0 = 0;
	csb0 = 0;
	wmask0 = 2'b01;

	// read undefined
	#10 din0=2'b11;
	addr0=4'h0;
	web0 = 1;
	csb0 = 0;
	wmask0 = 2'b01;

	#10 `assert(dout0, 2'bxx)

	// read defined
	din0=2'b11;
	addr0=4'hC;
	web0 = 1;
	csb0 = 0;
	wmask0 = 2'b01;

	#10 `assert(dout0, 2'bx1)

	// write another
	din0=2'b01;
	addr0=4'h1;
	web0 = 0;
	csb0 = 0;

	// read defined
	#10 din0=2'b11;
	addr0=4'h1;
	web0 = 1;
	csb0 = 0;


	#10 `assert(dout0, 2'b11)

	// read undefined
	din0=2'b11;
	addr0=4'h0;
	web0 = 1;
	csb0 = 0;

	#10 `assert(dout0, 2'bxx)

	#10 $finish;

  end

  always
    #5 clk = !clk;

endmodule