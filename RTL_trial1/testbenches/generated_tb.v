`timescale 1ns/1ps
module generated_tb;
    reg x_i;
    reg y_i;
    reg z_i;
    wire s_i;
    wire c_i_prime;
    reg expected_s_i;
    reg expected_c_i_prime;
    integer errors = 0;
    full_adder dut (.x_i(x_i), .y_i(y_i), .z_i(z_i), .s_i(s_i), .c_i_prime(c_i_prime));
    integer i;
    initial begin
        for (i = 0; i < (1 << 3); i = i + 1) begin
            x_i = i[0:0];
            y_i = i[1:1];
            z_i = i[2:2];
            #1;
            expected_s_i = x_i ^ y_i ^ z_i;
            expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
            if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        end
        // Manual user vector 000
        x_i = 1'b0;
        y_i = 1'b0;
        z_i = 1'b0;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        // Manual user vector 001
        x_i = 1'b0;
        y_i = 1'b0;
        z_i = 1'b1;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        // Manual user vector 011
        x_i = 1'b0;
        y_i = 1'b1;
        z_i = 1'b1;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        // Manual user vector 100
        x_i = 1'b1;
        y_i = 1'b0;
        z_i = 1'b0;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        // Manual user vector 101
        x_i = 1'b1;
        y_i = 1'b0;
        z_i = 1'b1;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        // Manual user vector 111
        x_i = 1'b1;
        y_i = 1'b1;
        z_i = 1'b1;
        #1;
        expected_s_i = x_i ^ y_i ^ z_i;
        expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
        if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
        if (errors == 0) $display("PASS"); else $display("FAIL: %0d error(s)", errors); $finish;
    end
endmodule
