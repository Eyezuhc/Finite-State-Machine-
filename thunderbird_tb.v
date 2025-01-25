`include "thunderbird.v"

module thunderbird_tb;
    reg clk,reset,left,right;
    wire [2:0] L;
    wire [2:0] R;

    thunderbird fsm(.clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .L(L),
        .R(R)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $dumpfile("thunderbird.vcd");
        $dumpvars(0, thunderbird_tb);
        left = 0; right = 0; reset = 0;
        #10 left = 1;
        #50 left = 0;
        #40 left = 1;
        #50 left = 0;
        $finish; 
    end
endmodule