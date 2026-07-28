module full_adder (
  input wire x_i,
  input wire y_i,
  input wire z_i,
  output wire s_i,
  output wire c_i_prime
);

assign s_i = x_i ^ y_i ^ z_i;
assign c_i_prime = (x_i & y_i) | (y_i & z_i) | (x_i & z_i);

endmodule
