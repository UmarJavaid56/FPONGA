module UART_Loopback
(
    input i_Clk,
    input i_UART_RX,

	output o_UART_TX,
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
   
    wire w_UART_Bit;
    wire [7:0] w_UART_Byte;
	wire w_TX_Serial;
	wire w_TX_Active;

    // 25,000,000 / 115,200 = 217
    UART_RX #(.CLKS_PER_BIT(217)) UART_RX_Instance(
        .i_Clock(i_Clk),
        .i_RX_Input(i_UART_RX),
        .o_RX_Bit(w_UART_Bit),
        .o_RX_Byte(w_UART_Byte)
    );
	
    UART_TX #(.CLKS_PER_BIT(217)) UART_TX_Instance(
        .i_Clock(i_Clk),
	    .i_Reset(1'b1), 
        .i_TX_DV(w_UART_Bit),
        .i_TX_Byte(w_UART_Byte),
		.o_TX_Active(w_TX_Active),
		.o_TX_Serial(w_TX_Serial),
		.o_TX_Done()
    );

	// if Serial Line is Active, assign Serial data. Otherwise, keep Serial line High (IDLE).
	assign o_UART_TX = w_TX_Active ? w_TX_Serial : 1'b1;
	
    Binary_To_7Segment Instance1
    (
        .i_Clk(i_Clk),
        .i_Binary_Num(w_UART_Byte[7:4]),
        .o_Segment_A(w_Segment1_A),
        .o_Segment_B(w_Segment1_B),
        .o_Segment_C(w_Segment1_C),
        .o_Segment_D(w_Segment1_D),
        .o_Segment_E(w_Segment1_E),
        .o_Segment_F(w_Segment1_F),
        .o_Segment_G(w_Segment1_G)
    );

    assign o_Segment1_A = ~w_Segment1_A;
    assign o_Segment1_B = ~w_Segment1_B;
    assign o_Segment1_C = ~w_Segment1_C;
    assign o_Segment1_D = ~w_Segment1_D;
    assign o_Segment1_E = ~w_Segment1_E;
    assign o_Segment1_F = ~w_Segment1_F;
    assign o_Segment1_G = ~w_Segment1_G;
	
    Binary_To_7Segment Instance2
    (
        .i_Clk(i_Clk),
        .i_Binary_Num(w_UART_Byte[3:0]),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G)
    );
    
    assign o_Segment2_A = ~w_Segment2_A;
    assign o_Segment2_B = ~w_Segment2_B;
    assign o_Segment2_C = ~w_Segment2_C;
    assign o_Segment2_D = ~w_Segment2_D;
    assign o_Segment2_E = ~w_Segment2_E;
    assign o_Segment2_F = ~w_Segment2_F;
    assign o_Segment2_G = ~w_Segment2_G;
    
endmodule
