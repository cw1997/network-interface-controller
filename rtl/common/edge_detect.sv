module edge_detect (
    // ports
    input  logic        signal,
    output logic        pos_edge,
    output logic        neg_edge,
    output logic        pos_level,
    output logic        neg_level,
    input  logic        clock,
    input  logic        reset
);

logic signal_prev;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        pos_edge  <= 0;
        neg_edge  <= 0;
        pos_level <=  signal;
        neg_level <= ~signal;
        signal_prev <= 0;
    end else begin
        pos_edge  <= ~signal_prev &  signal;
        neg_edge  <=  signal_prev & ~signal;
        pos_level <=  signal_prev &  signal;
        neg_level <= ~signal_prev & ~signal;
        signal_prev <= signal;
    end
end

endmodule