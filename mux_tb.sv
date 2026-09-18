// -----------------------------------------------------------------------------
// mux_tb.sv
// Testbench for 2:1 Multiplexer (mux2to1)
//
// Verification approach:
//   - Directed stimulus covering all 4 required test cases (Table in spec)
//   - Self-checking: expected value computed with the same combinational
//     logic as the DUT and compared against the DUT output
//   - Result printed per test vector with PASS/FAIL status
//   - Summary printed at the end (total / passed / failed)
//   - Waveform dumped to VCD for viewing in EPWave (EDA Playground)
// -----------------------------------------------------------------------------

`timescale 1ns/1ns

module mux_tb;

    // DUT signals
    logic a, b, sel;
    logic y;

    // Bookkeeping
    int pass_count = 0;
    int fail_count = 0;

    // Instantiate DUT
    mux2to1 dut (
        .a   (a),
        .b   (b),
        .sel (sel),
        .y   (y)
    );

    // Task: apply stimulus, wait, check, and report
    task automatic run_test(input logic ta, input logic tb, input logic tsel);
        logic expected_y;
        begin
            a   = ta;
            b   = tb;
            sel = tsel;

            #10; // allow combinational settling / advance time for the wave & log

            expected_y = tsel ? tb : ta;

            if (y === expected_y) begin
                pass_count++;
                $display("Time: %0t a=%0b b=%0b sel=%0b y=%0b PASS",
                          $time, a, b, sel, y);
            end else begin
                fail_count++;
                $display("Time: %0t a=%0b b=%0b sel=%0b y=%0b FAIL (expected y=%0b)",
                          $time, a, b, sel, y, expected_y);
            end
        end
    endtask

    initial begin
        // Waveform dump
        $dumpfile("dump.vcd");
        $dumpvars(0, mux_tb);

        $display("---------------------------------------------------");
        $display(" 2:1 MUX Verification Start");
        $display("---------------------------------------------------");

        // Test Case 1: a=0 b=0 sel=0 -> y=0
        run_test(1'b0, 1'b0, 1'b0);

        // Test Case 2: a=1 b=0 sel=0 -> y=1
        run_test(1'b1, 1'b0, 1'b0);

        // Test Case 3: a=0 b=1 sel=1 -> y=1
        run_test(1'b0, 1'b1, 1'b1);

        // Test Case 4: a=1 b=1 sel=1 -> y=1
        run_test(1'b1, 1'b1, 1'b1);

        $display("---------------------------------------------------");
        $display(" Verification Summary: %0d total, %0d passed, %0d failed",
                   pass_count + fail_count, pass_count, fail_count);
        if (fail_count == 0)
            $display(" RESULT: ALL TESTS PASSED");
        else
            $display(" RESULT: %0d TEST(S) FAILED", fail_count);
        $display("---------------------------------------------------");

        $finish;
    end

endmodule
