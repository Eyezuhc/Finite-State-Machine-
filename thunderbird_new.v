module state_n(
    input clk,
    input reset,
    input state,
    output reg Q
);
    output_logic uut()
    always @(posedge clk or negedge reset) begin
        if (reset)
            Q = 1'b0;
        else 
            Q = D;
    end
endmodule

module next_state_logic(
    input [3:0] state_p,
    input left,
    input right,
    output reg state_n
);
    always @(*) begin
		case(state_p)
        4'b0000: begin
				case(state_p)
				4'b0001: state_n = 4'b0010;
				4'b0100: state_n = 4'b0101;
				4'b1000: state_n = 4'b1001;
				default: state_n = 4'b0000;
			endcase
		end
            4'b0001: state_n = 4'b0010;
            4'b0010: state_n = 4'b0011;
            4'b0011: state_n = 4'b0000;

            4'b0100: state_n = 4'b0101;
            4'b0101: state_n = 4'b0110;
            4'b0110: state_n = 4'b0000;

            4'b1000: state_n = 4'b1001;
            4'b1001: state_n = 4'b0111;
            4'b0111: state_n = 4'b1010;
            4'b1010: state_n = 4'b1011;
            4'b1011: state_n = 4'b0000;
				default: state_n = 4'b0000;
		endcase
	end
endmodule

module output_logic(
    input [3:0] state,
    output reg [5:0] Light
);
    always @(*) begin
        case (state)
        4'b0000: Light = 6'b000000; // Off state
        4'b0001: Light = 6'b001000;
        4'b0010: Light = 6'b011000;
        4'b0011: Light = 6'b111000;
        4'b0100: Light = 6'b000100;
        4'b0101: Light = 6'b000110;
        4'b0110: Light = 6'b000111;
        4'b0111: Light = 6'b111111; // All lights on 
        4'b1000: Light = 6'b001100;
        4'b1001: Light = 6'b011110;
        4'b1010: Light = 6'b000000; // All lights off
        4'b1011: Light = 6'b111111; // All light on(1) used in (left && right)
        // Another 'All lights on' for no confusion in next state logic
        default: Light = 6'b000000;
        endcase 
    end
endmodule
