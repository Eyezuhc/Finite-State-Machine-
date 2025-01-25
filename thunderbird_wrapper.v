module thunderbird_wrapper(
	input clk,
	input reset,
	input left,
	input right,
	output LA, 
	output LB, 
	output LC,
	output RA,
	output RB,
	output RC
	);

	wire [3:0] state_p;
	wire [3:0] state_n;
	wire clk_en;

	clk_div CLK(
		.clk(clk),
		.rst(reset),
		.clk_en(clk_en)
		);

	state_holding_register state_reg(
		.clk(clk_en),
		.reset(reset),
		.D(state_n),
		.Q(state_p)
		);

	next_state_logic next_state(
		.state_p(state_p),
		.left(left),
		.right(right),
		.state_n(state_n)
		);
		
	output_logic output_mod(
		.state(state_p),
		.LA(LA),
		.LB(LB),
		.LC(LC),
		.RA(RA),
		.RB(RB),
		.RC(RC)
		);
		
endmodule