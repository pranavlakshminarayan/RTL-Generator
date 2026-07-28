module ternary_adder #(
    parameter N = 3
) (
  input wire [N-1:0] x,
  input wire [N-1:0] y,
  input wire [N-1:0] z,
  output wire [N-1:0] s,
  output wire [N-1:0] c_prime
);

assign s = x ^ y ^ z;
assign c_prime = (x & y) | (x & z) | (y & z);

endmodule
