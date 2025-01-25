module d_ff (
    input Clk,
    input Clear_n,
    input D,
    output reg Q
);
    always @(posedge Clk or negedge Clear_n) begin
        if (!Clear_n) 
            Q <= 1'b0;  
        else 
            Q <= D;     
    end
endmodule

module state_holding_register(
    input Clk,
    input Clear_n,
    input [2:0] D,
    output [2:0] Q
);
    d_ff dff0 (.Clk(Clk), .Clear_n(Clear_n), .D(D[0]), .Q(Q[0]));
    d_ff dff1 (.Clk(Clk), .Clear_n(Clear_n), .D(D[1]), .Q(Q[1]));
    d_ff dff2 (.Clk(Clk), .Clear_n(Clear_n), .D(D[2]), .Q(Q[2]));
endmodule

module next_state_logic(
    input [2:0] state_p,
    input [2:0] inputs,
    output reg [2:0] state_n
);
    always @(*) begin
        if (inputs[1] == 1'b1) begin
            state_n = 3'b000;
        end else begin
            case (state_p)
                3'b000: begin
                    case (inputs)
                        3'b100: state_n = 3'b001;
                        3'b001: state_n = 3'b100;
                        3'b010: state_n = 3'b000;
                        default: state_n = state_p;
                    endcase
                end
                3'b001: state_n = 3'b010;
                3'b010: state_n = 3'b011;
                3'b011: state_n = 3'b000;

                3'b100: state_n = 3'b101;
                3'b101: state_n = 3'b110;
                3'b110: state_n = 3'b000 ;
                default: state_n = state_p; 
            endcase
        end
    end
endmodule

module output_logic(
    input [2:0] state,
    output reg [5:0] led
);
    always @(*) begin
        case (state)
            3'b000: led = 6'b000000;
            3'b001: led = 6'b001000;
            3'b010: led = 6'b011000;
            3'b011: led = 6'b111000;
            3'b100: led = 6'b000100;
            3'b101: led = 6'b000110;
            3'b110: led = 6'b000111;
            default: led = 6'b111111;
        endcase
    end
endmodule


module thunderbird(
    input clk,
    input reset,
    input left,
    input right,
    output reg [2:0] L,
    output reg [2:0] R
);
    // Parameters for tail lights
    localparam Off   =     4'b0000,
               LA    =     4'b0001,
               LB    =     4'b0010,
               LC    =     4'b0011,
               RA    =     4'b0100,
               RB    =     4'b0101,
               RC    =     4'b0110,
               LA_RA =     4'b0111,
               LAB_RAB =   4'b1000,
               LABC_RABC = 4'b1001;
                 
    reg [2:0] state_p, state_n;

    // State transition on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state_p <= Off; // Reset to Off state
        else
            state_p <= state_n; 
    end

    // Next state logic
    always @(*) begin
        case (state_p)
            Off: begin
                if (left)
                    state_n = LA;
                else if (right)
                    state_n = RA;
                else if (left && right)
                    state_n = LA_RA;
                else
                    state_n = Off;
            end
            // Left turn sequence
            Off: state_n = LA;
            LA: state_n = LB; 
            LB: state_n = LC;
            LC: state_n = Off;

            // Right turn sequence
            Off: state_n = RA;
            RA: state_n = RB;
            RB: state_n = RC;
            RC: state_n = Off;

            // Left and Right (Blink then Simultaneous L and R then blink and off)
            Off:        state_n = LA_RA;
            LA_RA:      state_n = LAB_RAB;
            LAB_RAB:    state_n = LABC_RABC;
            LABC_RABC:  state_n = Off;
            default: state_n = Off;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default all outputs to Off
        L = 3'b000;
        R = 3'b000;

        case (state_p)
            // Left turn light sequence
            LA: L[0] = 3'b001; // Only LA active
            LB: L[1] = 3'b011; // LA and LB active
            LC: L[2] = 3'b111; // All left lights active

            // Right turn light sequence
            RA: R[0] = 3'b001; // Only RA active
            RB: R[1] = 3'b011; // RA and RB active
            RC: R[2] = 3'b111; // All right lights active

            // Left and Right tail lights on
            LABC_RABC: begin
                L = 3'b111;
                R = 3'b111;
            end

            LA_RA: begin // LA and RA both active
                L = 3'b001; 
                R = 3'b001;
            end

            LAB_RAB: begin // LA, LB and RA, RB active
                L = 3'b011;
                R = 3'b011;
            end

            default: begin
                L = 3'b000;
                R = 3'b000;
            end
        endcase
    end
endmodule