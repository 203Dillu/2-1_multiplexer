# 2-1_multiplexer
Verification a 2:1 Multiplexer Using SystemVerilog Testbench Objective
# 2:1 Multiplexer — SystemVerilog Verification Project

## Project Description
This project implements a simple **2:1 Multiplexer (MUX)** in SystemVerilog and
verifies it with a self-checking testbench. It is intended as an introductory
Design Verification (DV) exercise covering the core DV workflow: DUT design,
stimulus generation, output monitoring, and pass/fail scorekeeping.

## DUT Functionality (`mux.sv`)
Module: `mux2to1`

| Port | Direction | Width | Description        |
|------|-----------|-------|---------------------|
| a    | input     | 1-bit | Data input 0         |
| b    | input     | 1-bit | Data input 1         |
| sel  | input     | 1-bit | Select line          |
| y    | output    | 1-bit | Muxed output         |

Behavior (combinational, `always_comb`):
- `sel = 0` → `y = a`
- `sel = 1` → `y = b`

## Verification Approach (`mux_tb.sv`)
- **DUT instantiation**: `mux2to1 dut (...)` connected to testbench signals.
- **Stimulus generation**: a reusable `run_test(a, b, sel)` task drives each
  input combination and waits 10 ns for the combinational output to settle.
- **Self-checking**: the same mux logic (`sel ? b : a`) is computed in the
  testbench as `expected_y` and compared against the DUT's `y` using `===`.
- **Output monitoring**: each call to `run_test` prints the applied inputs,
  select value, DUT output, and PASS/FAIL status via `$display`.
- **Result summary**: a final block reports total/passed/failed test counts
  and an overall PASS/FAIL verdict.
- **Waveform**: `$dumpfile`/`$dumpvars` write a VCD (`dump.vcd`) so the
  signals can be inspected in EPWave.
- No clock/reset is required — the DUT is purely combinational.

## Test Scenarios
| Test Case | a | b | sel | Expected y |
|-----------|---|---|-----|------------|
| 1         | 0 | 0 | 0   | 0          |
| 2         | 1 | 0 | 0   | 1          |
| 3         | 0 | 1 | 1   | 1          |
| 4         | 1 | 1 | 1   | 1          |

## Running on EDA Playground
1. Go to https://www.edaplayground.com/
2. Language/Tool: **SystemVerilog**, simulator e.g. **Icarus Verilog** (or any
   SV-capable simulator).
3. Paste `mux.sv` contents into the "Design" pane.
4. Paste `mux_tb.sv` contents into the "Testbench" pane.
5. Check **"Open EPWave after run"** to view the waveform.
6. Click **Run**.

## Expected Simulation Output
```
---------------------------------------------------
 2:1 MUX Verification Start
---------------------------------------------------
Time: 10 a=0 b=0 sel=0 y=0 PASS
Time: 20 a=1 b=0 sel=0 y=1 PASS
Time: 30 a=0 b=1 sel=1 y=1 PASS
Time: 40 a=1 b=1 sel=1 y=1 PASS
---------------------------------------------------
 Verification Summary: 4 total, 4 passed, 0 failed
 RESULT: ALL TESTS PASSED
---------------------------------------------------
```

## Waveform
`dump.vcd` (opened via EPWave) shows `a`, `b`, `sel`, and `y` over time,
confirming `y` tracks `a` when `sel=0` and tracks `b` when `sel=1`.
