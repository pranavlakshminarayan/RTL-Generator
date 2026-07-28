# Diagnostics

# Repair diagnostic (attempt 1)

- **Failing stage:** syntax
- **Status:** FAIL_COMPILE
- **Tool:** iverilog
- **Location:** iverilog compile

## Error excerpt

```
C:\Users\prana\Documents\Claude Code\CHIPFORGE\Code Generator Model\runs_workdir\RTL_trial1\generation\attempt_01.v:10: error: Unable to bind wire/reg/memory `rst' in `generated_tb.dut'
C:\Users\prana\Documents\Claude Code\CHIPFORGE\Code Generator Model\runs_workdir\RTL_trial1\generation\attempt_01.v:10: error: Unable to elaborate condition expression.
2 error(s) during elaboration.

```

## Likely causes

- syntax error or unsupported construct
- undeclared signal or mismatched module/port name
- missing semicolon, begin/end, or endmodule

## Compared against

- structured specification
- interface authority (confirmed module/port names)
- the active testbench
- retrieved reference Verilog

## Suggested corrections

- keep the confirmed module name and port names unchanged
- fix the logic so the failing stage passes
- do not introduce new ports or rename existing ports
