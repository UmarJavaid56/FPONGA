module Binary_To_7Segment
(
    input i_Clk,
    input [3:0] i_Binary_Num,   // values from 0 to 15 in binary
    output o_Segment_A,
    output o_Segment_B,
    output o_Segment_C,
    output o_Segment_D,
    output o_Segment_E,
    output o_Segment_F,
    output o_Segment_G
);
    reg [6:0] r_Hex_Num; // values from 0 to 127

    always @(posedge i_Clk)
        case (i_Binary_Num)
        4'b0000: r_Hex_Num = 7'b1111110; // 0: A, B, C, D, E, F are on, G is off
        4'b0001: r_Hex_Num = 7'b0110000; // 1: B, C are on
        4'b0010: r_Hex_Num = 7'b1101101; // 2: A, B, D, E, G are on
        4'b0011: r_Hex_Num = 7'b1111001; // 3: A, B, C, D, G are on
        4'b0100: r_Hex_Num = 7'b0110011; // 4: B, C, F, G are on
        4'b0101: r_Hex_Num = 7'b1011011; // 5: A, C, D, F, G are on
        4'b0110: r_Hex_Num = 7'b1011111; // 6: A, C, D, E, F, G are on
        4'b0111: r_Hex_Num = 7'b1110000; // 7: A, B, C are on
        4'b1000: r_Hex_Num = 7'b1111111; // 8: A, B, C, D, E, F, G are on
        4'b1001: r_Hex_Num = 7'b1111011; // 9: A, B, C, D, F, G are on
        4'b1010: r_Hex_Num = 7'b1110111; // A: A, B, C, E, F, G are on
        4'b1011: r_Hex_Num = 7'b0011111; // B: C, D, E, F, G are on
        4'b1100: r_Hex_Num = 7'b1001110; // C: A, D, E, F are on
        4'b1101: r_Hex_Num = 7'b0111101; // D: B, C, D, E, G are on
        4'b1110: r_Hex_Num = 7'b1001111; // E: A, D, E, F, G are on
        4'b1111: r_Hex_Num = 7'b1000111; // F: A, E, F, G are on
        default: r_Hex_Num = 7'b0000000; // Default case to handle any unexpected input
        endcase

    assign o_Segment_A = r_Hex_Num[6];
    assign o_Segment_B = r_Hex_Num[5];
    assign o_Segment_C = r_Hex_Num[4];
    assign o_Segment_D = r_Hex_Num[3];
    assign o_Segment_E = r_Hex_Num[2];
    assign o_Segment_F = r_Hex_Num[1];
    assign o_Segment_G = r_Hex_Num[0];

endmodule
