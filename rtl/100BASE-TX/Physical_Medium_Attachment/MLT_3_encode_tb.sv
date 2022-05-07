`timescale 1ns/1ns

module MLT_3_encode_tb (
);

logic NRZ;
logic MLT_3_P;
logic MLT_3_N;
logic clock, reset;

localparam NRZ_input = 14'b0001_0010_1110_10;

wire MLT_3_result_N = {MLT_3_P, MLT_3_N} == 2'b01;
wire MLT_3_result_0 = {MLT_3_P, MLT_3_N} == 2'b00;
wire MLT_3_result_P = {MLT_3_P, MLT_3_N} == 2'b10;
string MLT_3_result = "0";
always_comb begin
    unique case (1'b1)
        MLT_3_result_N: MLT_3_result = "-";
        MLT_3_result_0: MLT_3_result = "0";
        MLT_3_result_P: MLT_3_result = "+";
        default       : MLT_3_result = "X";
    endcase
end

initial begin
    $dumpfile("./MLT_3_encode_tb.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars

    reset = 1;
    clock = 1;
    NRZ = 0;
    #4;
    reset = 0;
    for (int i=13; i>=0; --i) begin
        NRZ = NRZ_input[i];
        #2;
        $display("%t: NRZ = %b, MLT_3_result = %s", $realtime, NRZ, MLT_3_result);
    end

    #4;
    $stop();
end

always #1 clock = ~clock;

MLT_3_encode tb_MLT_3_encode (
    .NRZ ( NRZ ),
    .MLT_3_P ( MLT_3_P ),
    .MLT_3_N ( MLT_3_N ),
    .clock ( clock ),
    .reset ( reset )
);

endmodule
