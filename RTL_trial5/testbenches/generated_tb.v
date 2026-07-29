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

    alu_selective_io_logic_rel dut (
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
        input [2:0] op;
        input [7:0] a;
        input [7:0] b;
        input [15:0] expected;
        reg expected_parity;
        begin
            SEL = sel;
            DATA_IN_0 = a;
            DATA_IN_1 = b;
            DATA_IN_2 = {5'b10101, op};
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
                    $display("FAIL_PRIMARY sel=%b op=%b a=%h b=%h expected_ch0=%h got0=%h got1=%h valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, op, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end else begin
                    $display("PASS_PRIMARY sel=%b op=%b a=%h b=%h result=%h channel=0", sel, op, a, b, expected);
                end
            end else begin
                if (VALID_0 !== 1'b0 || VALID_1 !== 1'b1 ||
                    DATA_OUT_0 !== 16'h0000 || DATA_OUT_1 !== expected ||
                    PARITY_0 !== 1'b0 || PARITY_1 !== expected_parity) begin
                    errors = errors + 1;
                    $display("FAIL_PRIMARY sel=%b op=%b a=%h b=%h expected_ch1=%h got0=%h got1=%h valid0=%b valid1=%b parity0=%b parity1=%b",
                             sel, op, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                             VALID_0, VALID_1, PARITY_0, PARITY_1);
                end else begin
                    $display("PASS_PRIMARY sel=%b op=%b a=%h b=%h result=%h channel=1", sel, op, a, b, expected);
                end
            end
        end
    endtask

    task expect_cleared_by_reset;
        begin
            RES = 1'b1;
            STB = 1'b1;
            DATA_VALID_IN = 1'b1;
            SEL = 2'b01;
            DATA_IN_0 = 8'hFF;
            DATA_IN_1 = 8'h0F;
            DATA_IN_2 = 8'h5A;
            #1;
            if (VALID_0 !== 1'b0 || VALID_1 !== 1'b0 ||
                DATA_OUT_0 !== 16'h0000 || DATA_OUT_1 !== 16'h0000 ||
                PARITY_0 !== 1'b0 || PARITY_1 !== 1'b0) begin
                errors = errors + 1;
                $display("FAIL_PRIMARY reset did not clear outputs");
            end else begin
                $display("PASS_PRIMARY reset clears outputs");
            end
        end
    endtask

    task expect_inactive_without_strobe;
        begin
            RES = 1'b0;
            STB = 1'b0;
            DATA_VALID_IN = 1'b1;
            SEL = 2'b00;
            DATA_IN_0 = 8'hF0;
            DATA_IN_1 = 8'h0F;
            DATA_IN_2 = 8'h5A;
            #1;
            if (VALID_0 !== 1'b0 || VALID_1 !== 1'b0 ||
                DATA_OUT_0 !== 16'h0000 || DATA_OUT_1 !== 16'h0000 ||
                PARITY_0 !== 1'b0 || PARITY_1 !== 1'b0) begin
                errors = errors + 1;
                $display("FAIL_PRIMARY inactive strobe did not clear outputs");
            end else begin
                $display("PASS_PRIMARY inactive strobe clears outputs");
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

        expect_channel(2'b00, 3'b000, 8'hC3, 8'h3C, 16'h0000);
        expect_channel(2'b01, 3'b001, 8'h80, 8'h0F, 16'h008F);
        expect_channel(2'b10, 3'b010, 8'd14, 8'd6,  16'h0001);
        expect_channel(2'b11, 3'b010, 8'd5,  8'd8,  16'h0000);
        expect_channel(2'b10, 3'b011, 8'd2,  8'd9,  16'h0001);
        expect_channel(2'b11, 3'b011, 8'd12, 8'd4,  16'h0000);
        expect_channel(2'b10, 3'b100, 8'h44, 8'h44, 16'h0001);
        expect_channel(2'b11, 3'b100, 8'h24, 8'h42, 16'h0000);
        expect_channel(2'b10, 3'b101, 8'h66, 8'h77, 16'h0001);
        expect_channel(2'b11, 3'b101, 8'h99, 8'h99, 16'h0000);
        expect_cleared_by_reset();
        expect_inactive_without_strobe();

        if (errors == 0) $display("PASS");
        else $display("FAIL: %0d primary testbench error(s)", errors);
        $finish;
    end
endmodule
