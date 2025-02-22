module clk_div(
		input clk, 
		input rst, 
		output clk_en);

	reg [24:0] clk_count;
		always @ (posedge clk)
		// posedge defines a rising edge (transition from 0 to 1)
			begin
				if (rst)
					clk_count <= 0;
				else
					clk_count <= clk_count + 1;
				end
			assign clk_en = &clk_count;
endmodule
