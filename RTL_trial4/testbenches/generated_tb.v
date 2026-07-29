`timescale 1ns/1ps

module generated_tb;
    reg CLK;
    reg RES;
    reg STB;
    reg DATA_VALID_IN;
    reg [1:0] SEL;
    reg [7:0] DATA_IN_0;
    reg [7:0] DATA_IN_1;
    reg [7:0] DATA_IN_2;

    wire VALID_0;
    wire VALID_1;
    wire [15:0] DATA_OUT_0;
    wire [15:0] DATA_OUT_1;
    wire PARITY_0;
    wire PARITY_1;

    integer errors;

    alu_selective_io dut (
        .CLK(CLK),
        .RES(RES),
        .STB(STB),
        .DATA_VALID_IN(DATA_VALID_IN),
        .SEL(SEL),
        .DATA_IN_0(DATA_IN_0),
        .DATA_IN_1(DATA_IN_1),
        .DATA_IN_2(DATA_IN_2),
        .VALID_0(VALID_0),
        .VALID_1(VALID_1),
        .DATA_OUT_0(DATA_OUT_0),
        .DATA_OUT_1(DATA_OUT_1),
        .PARITY_0(PARITY_0),
        .PARITY_1(PARITY_1)
    );

    task expect_channel;
        input [1:0] sel;
        input [7:0] a;
        input [7:0] b;
        input [15:0] expected;
        reg expected_parity;
        begin
            SEL = sel;
            DATA_IN_0 = a;
            DATA_IN_1 = b;
            DATA_IN_2 = 8'hA5;
            STB = 1'b1;
            DATA_VALID_IN = 1'b1;
            RES = 1'b0;
            #1;
            expected_parity = ^expected;
            if (sel[0] == 1'b0) begin
                if (VALID_0 !== 1'b1 || VALID_1 !== 1'b0 ||
                    DATA_OUT_0 !== expected || DATA_OUT_1 !== 16'h0000 ||
                    PARITY_0 !== expected_parity || PARITY_1 !== 1'b0) begin
                    errors = errors + 1;
                    $display("FAIL_PRIMARY sel=%b a=%0d b=%0d expected_ch0=%0d got0=%0d got1=%0d valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end else begin
                    $display("PASS_PRIMARY sel=%b a=%0d b=%0d result=%0d channel=0", sel, a, b, expected);
                end
            end else begin
                if (VALID_0 !== 1'b0 || VALID_1 !== 1'b1 ||
                    DATA_OUT_0 !== 16'h0000 || DATA_OUT_1 !== expected ||
                    PARITY_0 !== 1'b0 || PARITY_1 !== expected_parity) begin
                    errors = errors + 1;
                    $display("FAIL_PRIMARY sel=%b a=%0d b=%0d expected_ch1=%0d got0=%0d got1=%0d valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end else begin
                    $display("PASS_PRIMARY sel=%b a=%0d b=%0d result=%0d channel=1", sel, a, b, expected);
                end
            end
        end
    endtask

    task expect_inactive_when_not_valid;
        begin
            RES = 1'b0;
            STB = 1'b0;
            DATA_VALID_IN = 1'b1;
            SEL = 2'b00;
            DATA_IN_0 = 8'd9;
            DATA_IN_1 = 8'd9;
            DATA_IN_2 = 8'hA5;
            #1;
            if (VALID_0 !== 1'b0 || VALID_1 !== 1'b0 ||
                DATA_OUT_0 !== 16'h0000 || DATA_OUT_1 !== 16'h0000 ||
                PARITY_0 !== 1'b0 || PARITY_1 !== 1'b0) begin
                errors = errors + 1;
                $display("FAIL_PRIMARY inactive gate did not clear outputs");
            end else begin
                $display("PASS_PRIMARY inactive gate clears outputs");
            end
        end
    endtask

    initial begin
        CLK = 1'b0;
        RES = 1'b0;
        STB = 1'b0;
        DATA_VALID_IN = 1'b0;
        SEL = 2'b00;
        DATA_IN_0 = 8'h00;
        DATA_IN_1 = 8'h00;
        DATA_IN_2 = 8'h00;
        errors = 0;

        expect_channel(2'b00, 8'd6,  8'd3,  16'd18);
        expect_channel(2'b00, 8'd5,  8'd5,  16'd25);
        expect_channel(2'b01, 8'd9,  8'd2,  16'd7);
        expect_channel(2'b01, 8'd8,  8'd6,  16'd2);
        expect_channel(2'b10, 8'd12, 8'd3,  16'd4);
        expect_channel(2'b10, 8'd9,  8'd4,  16'd2);
        expect_channel(2'b11, 8'd13, 8'd5,  16'd3);
        expect_channel(2'b10, 8'd7,  8'd0,  16'd0);
        expect_inactive_when_not_valid();

        if (errors == 0) $display("PASS");
        else $display("FAIL: %0d primary testbench error(s)", errors);
        $finish;
    end
endmodule
