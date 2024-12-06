module random_index #(
    parameter N = 100 
) (
    input clk,                 
    input reset,              
    input enable,              
    output reg [$clog2(N)-1:0] rand_index [0:(N * $clog2(N))-1], 
    output reg done            
);
    reg [$clog2(N)-1:0] array [0:N-1]; 
    integer i, j;
    reg [$clog2(N)-1:0] temp;
    reg [31:0] lfsr;           

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                array[i] <= i;
            end
            lfsr <= 32'hACE1; 
            done <= 0;
        end else if (enable) begin
            if (!done) begin
                for (i = N-1; i > 0; i = i - 1) begin
                    lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
                    j = lfsr % (i + 1);
                    temp = array[i];
                    array[i] = array[j];
                    array[j] = temp;
                end
                for (i = 0; i < N; i = i + 1) begin
                    rand_index[i * $clog2(N) +: $clog2(N)] <= array[i];
                end

                done <= 1;
            end
        end
    end
endmodule
