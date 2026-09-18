// -----------------------------------------------------------------------------
// mux.sv
// 2:1 Multiplexer (Design Under Test)
//
// Functionality:
//   sel = 0 -> y = a
//   sel = 1 -> y = b
// -----------------------------------------------------------------------------

module mux2to1 (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic y
);

    always_comb begin
        y = sel ? b : a;
    end

endmodule
