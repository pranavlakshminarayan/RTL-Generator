module alu_selective_io_logic_rel (
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
wire output_channel;
wire [2:0] alu_op;
reg [15:0] alu_result;

assign gated_valid = (!RES) && STB && DATA_VALID_IN;
assign output_channel = SEL[0];
assign alu_op = DATA_IN_2[2:0];

always @* begin
    case (alu_op)
        3'b000: alu_result = {8'h00, (DATA_IN_0 & DATA_IN_1)};
        3'b001: alu_result = {8'h00, (DATA_IN_0 | DATA_IN_1)};
        3'b010: alu_result = (DATA_IN_0 >= DATA_IN_1) ? 16'h0001 : 16'h0000;
        3'b011: alu_result = (DATA_IN_0 <= DATA_IN_1) ? 16'h0001 : 16'h0000;
        3'b100: alu_result = (DATA_IN_0 == DATA_IN_1) ? 16'h0001 : 16'h0000;
        3'b101: alu_result = (DATA_IN_0 != DATA_IN_1) ? 16'h0001 : 16'h0000;
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
