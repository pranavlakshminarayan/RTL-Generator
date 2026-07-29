# Diagnostics

## Attempt 1

The initial run incorrectly allowed a weak retrieved reference testbench (`tb_M65C02_ALU.v`) to participate in verification. That testbench instantiated `M65C02_ALU`, which is unrelated to the confirmed module `alu_selective_io`. The generated attempt also lost the confirmed bus widths and treated `SEL`, `DATA_IN_0`, `DATA_IN_1`, `DATA_IN_2`, `DATA_OUT_0`, and `DATA_OUT_1` as scalars.

## Attempt 2

The rerun used the image plus user task as the authority. Retrieved references were not treated as authoritative because their module/interface did not match the requested ALU. The corrected RTL preserves the diagram notation in Verilog-safe form and compiles before testbench execution.
