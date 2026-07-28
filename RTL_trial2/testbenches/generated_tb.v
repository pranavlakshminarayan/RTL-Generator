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
    reg [2:0] manual_vector;
    integer manual_idx;
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
        for (manual_idx = 0; manual_idx < 6; manual_idx = manual_idx + 1) begin
            case (manual_idx)
                0: manual_vector = 3'b000;
                1: manual_vector = 3'b001;
                2: manual_vector = 3'b011;
                3: manual_vector = 3'b100;
                4: manual_vector = 3'b101;
                5: manual_vector = 3'b111;
                default: manual_vector = 3'bx;
            endcase
            x_i = manual_vector[2];
            y_i = manual_vector[1];
            z_i = manual_vector[0];
            #1;
            expected_s_i = x_i ^ y_i ^ z_i;
            expected_c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);
            if ((s_i !== expected_s_i) || (c_i_prime !== expected_c_i_prime)) begin errors = errors + 1; $display("FAIL: output mismatch s_i=%b expected=%b, c_i_prime=%b expected=%b", s_i, expected_s_i, c_i_prime, expected_c_i_prime); end
            $display("MANUAL_VECTOR %b -> s_i=%b c_i_prime=%b", manual_vector, s_i, c_i_prime);
        end
        if (errors == 0) $display("PASS"); else $display("FAIL: %0d error(s)", errors); $finish;
    end
endmodule
