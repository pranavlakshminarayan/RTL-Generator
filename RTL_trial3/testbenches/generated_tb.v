`timescale 1ns/1ps
module generated_tb;
    reg [2:0] x;
    reg [2:0] y;
    reg [2:0] z;
    wire [2:0] s;
    wire [2:0] c_prime;
    reg [2:0] expected_s;
    reg [2:0] expected_c_prime;
    integer errors = 0;
    ternary_adder dut (.x(x), .y(y), .z(z), .s(s), .c_prime(c_prime));
    integer i;
    initial begin
        for (i = 0; i < (1 << 9); i = i + 1) begin
            x = i[2:0];
            y = i[5:3];
            z = i[8:6];
            #1;
            expected_s = x ^ y ^ z;
            expected_c_prime = (x & y) | (x & z) | (y & z);
            if ((s !== expected_s) || (c_prime !== expected_c_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s=%b expected=%b, c_prime=%b expected=%b", s, expected_s, c_prime, expected_c_prime); end
        end
        if (errors == 0) $display("PASS"); else $display("FAIL: %0d error(s)", errors); $finish;
    end
endmodule
