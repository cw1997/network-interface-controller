module MLT_3_encode (
    input  logic NRZ,
    output logic MLT_3_P,
    output logic MLT_3_N,
    input  logic clock, reset
);

logic NRZ_edge_positive, NRZ_edge_negative, NRZ_level_high, NRZ_level_low;
signal_detect signal_detect_NRZ (
    .signal ( NRZ ),
    .edge_positive ( NRZ_edge_positive ),
    .edge_negative ( NRZ_edge_negative ),
    .level_high ( NRZ_level_high ),
    .level_low ( NRZ_level_low ),
    .clock ( clock ),
    .reset ( reset )
);

wire NRZ_pos = NRZ_edge_positive | NRZ_level_high;

enum logic [1:0] {
    state_1_0 = 2'h0,
    state_P_1 = 2'h1,
    state_2_0 = 2'h2,
    state_N_1 = 2'h3
} state;
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        state <= state_1_0;
    end else begin
        unique case (state)
            state_1_0: state <= NRZ_pos ? state_P_1 : state_1_0;
            state_P_1: state <= NRZ_pos ? state_2_0 : state_P_1;
            state_2_0: state <= NRZ_pos ? state_N_1 : state_2_0;
            state_N_1: state <= NRZ_pos ? state_1_0 : state_N_1;
        endcase
    end
end

localparam
MLT_3_PN_N = 2'b01,
MLT_3_PN_0 = 2'b00,
MLT_3_PN_P = 2'b10;
always_comb begin
    unique case (state)
        state_1_0: {MLT_3_P, MLT_3_N} = NRZ_pos ? MLT_3_PN_P : MLT_3_PN_0;
        state_P_1: {MLT_3_P, MLT_3_N} = NRZ_pos ? MLT_3_PN_0 : MLT_3_PN_P;
        state_2_0: {MLT_3_P, MLT_3_N} = NRZ_pos ? MLT_3_PN_N : MLT_3_PN_0;
        state_N_1: {MLT_3_P, MLT_3_N} = NRZ_pos ? MLT_3_PN_0 : MLT_3_PN_N;
    endcase
end

endmodule
