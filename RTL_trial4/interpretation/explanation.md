# Interpretation: alu_selective_io

- **Image type:** other_hardware_visual
- **Design scope:** single_module
- **Overall confidence:** 0.95

## Description

User-confirmed RTL task specification.

## Detected blocks

- alu_selective_io

## Interface

**Inputs:**

| name | width | signed |
|---|---|---|
| CLK | 1 | no |
| RES | 1 | no |
| STB | 1 | no |
| DATA_VALID_IN | 1 | no |
| SEL | 2 | no |
| DATA_IN_0 | 8 | no |
| DATA_IN_1 | 8 | no |
| DATA_IN_2 | 8 | no |

**Outputs:**

| name | width | signed |
|---|---|---|
| VALID_0 | 1 | no |
| VALID_1 | 1 | no |
| DATA_OUT_0 | 16 | no |
| DATA_OUT_1 | 16 | no |
| PARITY_0 | 1 | no |
| PARITY_1 | 1 | no |

## Behaviour

- **Kind:** combinational
- **Equations:** VALID_0 = (!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b0)); VALID_1 = (!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b1)); DATA_OUT_0 = ((!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b0)) ? ((SEL == 2'b00) ? (DATA_IN_0 * DATA_IN_1) : (SEL == 2'b01) ? (DATA_IN_0 - DATA_IN_1) : (SEL == 2'b10) ? ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 / DATA_IN_1)) : ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 % DATA_IN_1))) : 16'h0000); DATA_OUT_1 = ((!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b1)) ? ((SEL == 2'b00) ? (DATA_IN_0 * DATA_IN_1) : (SEL == 2'b01) ? (DATA_IN_0 - DATA_IN_1) : (SEL == 2'b10) ? ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 / DATA_IN_1)) : ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 % DATA_IN_1))) : 16'h0000); PARITY_0 = ((!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b0)) ? ^((SEL == 2'b00) ? (DATA_IN_0 * DATA_IN_1) : (SEL == 2'b01) ? (DATA_IN_0 - DATA_IN_1) : (SEL == 2'b10) ? ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 / DATA_IN_1)) : ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 % DATA_IN_1))) : 1'b0); PARITY_1 = ((!RES && STB && DATA_VALID_IN && (SEL[0] == 1'b1)) ? ^((SEL == 2'b00) ? (DATA_IN_0 * DATA_IN_1) : (SEL == 2'b01) ? (DATA_IN_0 - DATA_IN_1) : (SEL == 2'b10) ? ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 / DATA_IN_1)) : ((DATA_IN_1 == 8'd0) ? 16'h0000 : (DATA_IN_0 % DATA_IN_1))) : 1'b0)

## Assumptions

- Interface and behaviour were supplied by the user after reviewing the model interpretation checkpoint.

## Ambiguities

- the image could not be reliably interpreted: unbalanced JSON object in model response

## Sufficiency

**Verdict:** SUFFICIENT

Understood:

- image type is other_hardware_visual
- design name 'alu_selective_io'
- an intended-behaviour description
- 8 input(s) and 6 output(s)
- combinational behaviour

## Retrieval references used

- [image] freecores_openmsp430: images/dbg_uart_cmd_frame.png (score 0.51)
- [image] freecores_openmsp430: images/gdbproxy_flow.png (score 0.51)
- [image] klyone_processor_openmsp430: images/dbg_uart_cmd_frame.png (score 0.51)
- [hdl] freecores_ao68000: hdl/ao68000.v (score 0.03)
- [hdl] freecores_m65c02: hdl/M65C02_ALU.v (score 0.03)
- [hdl] freecores_openmsp430: hdl/omsp_alu.v (score 0.03)
- [document] klyone_system_on_chip_minsoc: docs/openrisc1200_spec.txt (score 1.00) (code-only, not a visual example)
- [document] klyone_system_on_chip_minsoc: docs/openrisc1200_spec.txt (score 0.93) (code-only, not a visual example)
- [testbench] freecores_m65c02: testbenches/tb_M65C02_ALU.v (score 0.03)
