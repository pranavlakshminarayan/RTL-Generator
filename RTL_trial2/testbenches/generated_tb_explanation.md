# Generated testbench (requires your approval)

- **Circuit class:** combinational
- **Differential vs reference:** no
- **Expected-output source:** structured specification equations/transitions

## Strategy

Drive inputs (exhaustive for small spaces, else zero/max/boundary plus randomized cases) and check outputs.

## Test cases

- exhaustive over all input combinations
- zero and maximum values (covered by sweep)
- 6 manual user final-validation vector(s)
- equation-derived output checks

## Limitations

- a pass here is PASS_GENERATED_TB_ONLY and is not independent verification

## Approval required

This testbench will NOT be run until you approve it. A pass against it alone is reported as PASS_GENERATED_TB_ONLY and is not equivalent to independent verification.
