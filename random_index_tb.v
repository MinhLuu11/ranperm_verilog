`timescale 1ns/1ns

module random_index_tb;
    parameter N = 16; 

    reg clk;
    reg reset;
    reg enable;
    wire [N * $clog2(N)-1:0] rand_index;
    wire done;
    reg [$clog2(N)-1:0] index_out [0:N-1];

    random_index #(.N(N)) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .rand_index(rand_index),
        .done(done)
    );

    initial clk = 0;
    always #10 clk = ~clk; 

    initial begin
        $display("Starting generation...");
        reset = 1;
        enable = 0;
        #200;

        reset = 0;
        enable = 1;
        #2000; 0

        if (done) begin
            for (integer i = 0; i < N; i = i + 1) begin
                index_out[i] = rand_index[i * $clog2(N) +: $clog2(N)];
            end

            $display("Random permutation indices:");
            for (integer i = 0; i < N; i = i + 1) begin
                $display("index_out[%0d] = %0d", i, index_out[i]);
            end
        end
        $finish;
    end
endmodule
