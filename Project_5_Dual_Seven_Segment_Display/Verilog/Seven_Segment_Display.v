module Seven_Segment_Display
(
    input i_Clk,
    input i_Switch_1,
    input i_Switch_2,
    
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,
    
    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G
);

    reg r_Switch_1 = 1'b0;
    reg [3:0] r_Binary_Count = 4'b0000;
    reg [3:0] r_Binary_Count2 = 4'b0000;
    
    wire w_Switch_1;
    wire w_Switch_2;
    
    wire w_Segment2_A;
    wire w_Segment2_B;
    wire w_Segment2_C;
    wire w_Segment2_D;
    wire w_Segment2_E;
    wire w_Segment2_F;
    wire w_Segment2_G;
    
    wire w_Segment1_A;
    wire w_Segment1_B;
    wire w_Segment1_C;
    wire w_Segment1_D;
    wire w_Segment1_E;
    wire w_Segment1_F;
    wire w_Segment1_G;
    
    Debounce_Switch Instance1
    (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1)
    );
    
    Debounce_Switch Instance2
    (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_2),
        .o_Switch(w_Switch_2)
    );
    
    always @(posedge i_Clk)
    begin 
        if (w_Switch_2 == 1'b1) // Reset when switch 2 is pressed
        begin
            r_Binary_Count <= 4'b0000;
            r_Binary_Count2 <= 4'b0000;
        end
        else 
        begin 
            r_Switch_1 <= w_Switch_1;
            if (r_Switch_1 == 1'b0 && w_Switch_1 == 1'b1) 
            begin
                if (r_Binary_Count == 9) 
                begin
                    r_Binary_Count <= 0;
                    r_Binary_Count2 <= r_Binary_Count2 + 1;
                    if(r_Binary_Count2 == 9)
                        r_Binary_Count2 <=0;
                end
                else
                    r_Binary_Count <= r_Binary_Count + 1;
            end
        end
    end

    Binary_To_7Segment Instance3
    (
        .i_Binary_Num(r_Binary_Count),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G)
    );

    Binary_To_7Segment Instance4
    (
        .i_Binary_Num(r_Binary_Count2),
        .o_Segment_A(w_Segment1_A),
        .o_Segment_B(w_Segment1_B),
        .o_Segment_C(w_Segment1_C),
        .o_Segment_D(w_Segment1_D),
        .o_Segment_E(w_Segment1_E),
        .o_Segment_F(w_Segment1_F),
        .o_Segment_G(w_Segment1_G)
    );

    assign o_Segment2_A = ~w_Segment2_A;
    assign o_Segment2_B = ~w_Segment2_B;
    assign o_Segment2_C = ~w_Segment2_C;
    assign o_Segment2_D = ~w_Segment2_D;
    assign o_Segment2_E = ~w_Segment2_E;
    assign o_Segment2_F = ~w_Segment2_F;
    assign o_Segment2_G = ~w_Segment2_G;
    
    assign o_Segment1_A = ~w_Segment1_A;
    assign o_Segment1_B = ~w_Segment1_B;
    assign o_Segment1_C = ~w_Segment1_C;
    assign o_Segment1_D = ~w_Segment1_D;
    assign o_Segment1_E = ~w_Segment1_E;
    assign o_Segment1_F = ~w_Segment1_F;
    assign o_Segment1_G = ~w_Segment1_G;
    
endmodule
