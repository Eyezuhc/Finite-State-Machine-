module state_holding_register(
    input clk,
    input reset,
    input  D,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 1'b0;
        else
            Q <= D;
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
	 output reg off, High1,High2,
    output reg LA,LB,LC,
	 output reg	RA,RB,RC,
	 output reg LR1,LR2,LR0
);
    always @(*) begin
        case (state)
        4'b0000: off = 6'b000000; // Off state
        4'b0001: LA = 6'b001000;
        4'b0010: LB = 6'b011000;
        4'b0011: LC = 6'b111000;
        4'b0100: RA = 6'b000100;
        4'b0101: RB = 6'b000110;
        4'b0110: RC = 6'b000111;
        4'b0111: High1 = 6'b111111; // All lights on 
        4'b1000: LR1 = 6'b001100;
        4'b1001: LR2 = 6'b011110;
        4'b1010: LR0 = 6'b000000; // All lights off
        4'b1011: High2 = 6'b111111; // All light on(1) used in (left && right)
        // Another 'All lights on' for no confusion in next state logic
        default: off = 0;
        endcase 
    end
endmodule
