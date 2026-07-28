`timescale 1ns/1ps
module manual_adder_ops_tb;
    localparam N = 3;
    localparam MAX_VALUE = (1 << N) - 1;

    reg  [N-1:0] x;
    reg  [N-1:0] y;
    reg  [N-1:0] z;
    wire [N-1:0] s;
    wire [N-1:0] c_prime;

    reg [N+1:0] expected_sum;
    reg [N+1:0] observed_sum;
    integer errors = 0;
    integer invalid_cases = 0;

    ternary_adder #(.N(N)) dut (
        .x(x),
        .y(y),
        .z(z),
        .s(s),
        .c_prime(c_prime)
    );

    task run_case;
        input integer xi;
        input integer yi;
        input integer zi;
        begin
            if ((xi > MAX_VALUE) || (yi > MAX_VALUE) || (zi > MAX_VALUE)) begin
                invalid_cases = invalid_cases + 1;
                $display("INVALID %0d+%0d+%0d reason=out_of_range_for_N3 expected=zzz observed=zzz s=zzz c_prime=zzz",
                         xi, yi, zi);
            end else begin
            x = xi[N-1:0];
            y = yi[N-1:0];
            z = zi[N-1:0];
            #1;
            expected_sum = xi + yi + zi;
            observed_sum = {1'b0, s} + ({1'b0, c_prime} << 1);
            if (observed_sum !== expected_sum) begin
                errors = errors + 1;
                $display("FAIL %0d+%0d+%0d expected=%0d observed=%0d s=%b c_prime=%b",
                         xi, yi, zi, expected_sum, observed_sum, s, c_prime);
            end else begin
                $display("PASS %0d+%0d+%0d expected=%0d observed=%0d s=%b c_prime=%b",
                         xi, yi, zi, expected_sum, observed_sum, s, c_prime);
            end
            end
        end
    endtask

    initial begin
        $dumpfile("manual_adder_ops.vcd");
        $dumpvars(0, manual_adder_ops_tb);

        run_case(3, 6, 9);
        run_case(7, 6, 5);
        run_case(0, 0, 0);
        run_case(1, 1, 0);
        run_case(0, 8, 2);

        if (errors == 0) $display("OVERALL PASS valid_cases_passed invalid_cases=%0d", invalid_cases);
        else $display("OVERALL FAIL: %0d error(s) invalid_cases=%0d", errors, invalid_cases);
        $finish;
    end
endmodule
