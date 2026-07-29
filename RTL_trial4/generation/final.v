module alu_selective_io (
    input wire CLK,
    input wire RES,
    input wire STB,
    input wire DATA_VALID_IN,
    input wire [1:0] SEL,
    input wire [7:0] DATA_IN_0,
    input wire [7:0] DATA_IN_1,
    input wire [7:0] DATA_IN_2,
    output wire VALID_0,
    output wire VALID_1,
    output wire [15:0] DATA_OUT_0,
    output wire [15:0] DATA_OUT_1,
    output wire PARITY_0,
    output wire PARITY_1
);

wire gated_valid;
reg [15:0] alu_result;
wire output_channel;

assign gated_valid = (!RES) && STB && DATA_VALID_IN;
assign output_channel = SEL[0];

always @* begin
    case (SEL)
        2'b00: alu_result = DATA_IN_0 * DATA_IN_1;
        2'b01: alu_result = DATA_IN_0 - DATA_IN_1;
        2'b10: alu_result = (DATA_IN_1 == 8'd0) ? 16'h0000 : DATA_IN_0 / DATA_IN_1;
        2'b11: alu_result = (DATA_IN_1 == 8'd0) ? 16'h0000 : DATA_IN_0 % DATA_IN_1;
        default: alu_result = 16'h0000;
    endcase
end

assign VALID_0 = gated_valid && (output_channel == 1'b0);
assign VALID_1 = gated_valid && (output_channel == 1'b1);

assign DATA_OUT_0 = VALID_0 ? alu_result : 16'h0000;
assign DATA_OUT_1 = VALID_1 ? alu_result : 16'h0000;

assign PARITY_0 = VALID_0 ? ^alu_result : 1'b0;
assign PARITY_1 = VALID_1 ? ^alu_result : 1'b0;

endmodule
