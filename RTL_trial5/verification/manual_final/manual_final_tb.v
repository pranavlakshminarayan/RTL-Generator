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

    task run_case;
        input [127:0] label;
        input [1:0] sel;
        input [2:0] op;
        input [7:0] a;
        input [7:0] b;
        input [15:0] expected;
        reg expected_parity;
        reg [15:0] observed;
        begin
            SEL = sel;
            DATA_IN_0 = a;
            DATA_IN_1 = b;
            DATA_IN_2 = {5'b00000, op};
            STB = 1'b1;
            DATA_VALID_IN = 1'b1;
            RES = 1'b0;
            #5;
            expected_parity = ^expected;
            observed = sel[0] ? DATA_OUT_1 : DATA_OUT_0;
            if (((sel[0] == 1'b0) && VALID_0 && !VALID_1 &&
                 DATA_OUT_0 === expected && DATA_OUT_1 === 16'h0000 &&
                 PARITY_0 === expected_parity && PARITY_1 === 1'b0) ||
                ((sel[0] == 1'b1) && !VALID_0 && VALID_1 &&
                 DATA_OUT_0 === 16'h0000 && DATA_OUT_1 === expected &&
                 PARITY_0 === 1'b0 && PARITY_1 === expected_parity)) begin
                $display("PASS %0s DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed=%0d channel=%0d parity=%b",
                         label, a, b, expected, observed, sel[0], expected_parity);
            end else begin
                errors = errors + 1;
                $display("FAIL %0s DATA_IN_0=%0d DATA_IN_1=%0d expected=%0d observed0=%0d observed1=%0d valid0=%b valid1=%b parity0=%b parity1=%b",
                         label, a, b, expected, DATA_OUT_0, DATA_OUT_1,
                         VALID_0, VALID_1, PARITY_0, PARITY_1);
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

        run_case("AND", 2'b00, 3'b000, 8'd12, 8'd10, 16'd8);
        run_case("OR",  2'b01, 3'b001, 8'd12, 8'd10, 16'd14);
        run_case("GE",  2'b10, 3'b010, 8'd15, 8'd7,  16'd1);
        run_case("LE",  2'b11, 3'b011, 8'd15, 8'd7,  16'd0);
        run_case("EQ",  2'b10, 3'b100, 8'd4,  8'd9,  16'd0);
        run_case("NE",  2'b11, 3'b101, 8'd4,  8'd9,  16'd1);

        if (errors == 0) $display("OVERALL PASS");
        else $display("OVERALL FAIL errors=%0d", errors);
        $finish;
    end
endmodule
