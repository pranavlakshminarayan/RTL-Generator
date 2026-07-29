# Diagnostics

## Attempt 1

The first attempt failed for two separate reasons:

- an unrelated retrieved reference testbench instantiated `M65C02_ALU`, which
  did not match the requested `alu_selective_io` module;
- the generated RTL lost the confirmed bus widths and treated `SEL`,
  `DATA_IN_0`, `DATA_IN_1`, `DATA_IN_2`, `DATA_OUT_0`, and `DATA_OUT_1` as
  scalar 1-bit signals.

That attempt was not accepted as the final result.

## Attempt 2

The second published version was legible, but it still reused the user's manual
final validation values in the primary testbench. That was incorrect because
manual vectors must remain a separate final validation stage.

## Attempt 3

The corrected revision keeps the primary/generated testbench separate from the
manual final validation. The ALU RTL compiles standalone first, the generated
primary testbench passes with separate cases, and the user's values pass only in
manual final validation.

## Feedback Rules Added

Retrieved references are not automatically authoritative. A reference must match
the user's module/interface and behaviour before it can be used as an active
verification source.

Manual final validation values supplied by the user must not be reused as the
primary/generated testbench cases.
