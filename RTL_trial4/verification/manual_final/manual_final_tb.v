`timescale 1ns/1ps

module manual_final_tb;
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

    task run_case;
        input [1:0] sel;
        input [7:0] a;
        input [7:0] b;
        input [15:0] expected;
        reg expected_parity;
        reg expected_channel;
        begin
            SEL = sel;
            DATA_IN_0 = a;
            DATA_IN_1 = b;
            DATA_IN_2 = 8'h00;
            STB = 1'b1;
            DATA_VALID_IN = 1'b1;
            RES = 1'b0;
            #5;
            expected_parity = ^expected;
            expected_channel = sel[0];
            if (expected_channel == 1'b0) begin
                if (VALID_0 === 1'b1 && VALID_1 === 1'b0 &&
                    DATA_OUT_0 === expected && DATA_OUT_1 === 16'h0000 &&
                    PARITY_0 === expected_parity && PARITY_1 === 1'b0) begin
                    $display("PASS sel=%b DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed=%0d channel=0 parity=%b",
                             sel, a, b, expected, DATA_OUT_0, PARITY_0);
                end else begin
                    errors = errors + 1;
                    $display("FAIL sel=%b DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed0=%0d observed1=%0d valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end
            end else begin
                if (VALID_0 === 1'b0 && VALID_1 === 1'b1 &&
                    DATA_OUT_0 === 16'h0000 && DATA_OUT_1 === expected &&
                    PARITY_0 === 1'b0 && PARITY_1 === expected_parity) begin
                    $display("PASS sel=%b DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed=%0d channel=1 parity=%b",
                             sel, a, b, expected, DATA_OUT_1, PARITY_1);
                end else begin
                    errors = errors + 1;
                    $display("FAIL sel=%b DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed0=%0d observed1=%0d valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end
            end
            #5;
        end
    endtask

    initial begin
        $dumpfile("manual_final.vcd");
        $dumpvars(0, manual_final_tb);

        errors = 0;
        CLK = 1'b0;
        RES = 1'b0;
        STB = 1'b0;
        DATA_VALID_IN = 1'b0;
        SEL = 2'b00;
        DATA_IN_0 = 8'h00;
        DATA_IN_1 = 8'h00;
        DATA_IN_2 = 8'h00;
        #5;

        run_case(2'b00, 8'd3,  8'd10, 16'd30);
        run_case(2'b00, 8'd2,  8'd2,  16'd4);
        run_case(2'b01, 8'd7,  8'd7,  16'd0);
        run_case(2'b01, 8'd4,  8'd3,  16'd1);
        run_case(2'b10, 8'd10, 8'd5,  16'd2);
        run_case(2'b10, 8'd7,  8'd2,  16'd3);
        run_case(2'b11, 8'd10, 8'd2,  16'd0);

        if (errors == 0) $display("OVERALL PASS");
        else $display("OVERALL FAIL errors=%0d", errors);
        $finish;
    end
endmodule
