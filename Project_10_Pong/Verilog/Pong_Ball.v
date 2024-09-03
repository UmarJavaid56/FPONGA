module Pong_Ball #(
    parameter c_GAME_HEIGHT = 30,  // Height of the game area
    parameter c_GAME_WIDTH = 40    // Width of the game area
)(
    input i_Clk,                    // Clock signal
    input i_Game_On,                // Game on signal
    input [5:0] i_Col_Counter,      // Current column counter (VGA)
    input [5:0] i_Row_Counter,      // Current row counter (VGA)
    output reg [5:0] o_Ball_X = 0,  // Current X position of the ball
    output reg [5:0] o_Ball_Y = 0,  // Current Y position of the ball
    output reg o_Draw_Ball          // Signal to draw the ball
);

    // Parameter for ball speed control
    parameter c_BALL_SPD = 1250000;

    // Registers for previous ball position and counter
    reg [5:0] r_Prev_Ball_X = 0;
    reg [5:0] r_Prev_Ball_Y = 0;
    reg [31:0] r_Ball_Counter = 0;

    // Always block to update ball position and handle game state
    always @(posedge i_Clk) begin 
        if (i_Game_On == 1'b1) begin 
            if (r_Ball_Counter < c_BALL_SPD) begin
                r_Ball_Counter <= r_Ball_Counter + 1;
            end else begin
                r_Ball_Counter <= 0;

                // Store previous position
                r_Prev_Ball_X <= o_Ball_X;
                r_Prev_Ball_Y <= o_Ball_Y;

                // Update ball X position
                if ((r_Prev_Ball_X < o_Ball_X && (o_Ball_X == c_GAME_WIDTH-1)) ||
                    (r_Prev_Ball_X > o_Ball_X && o_Ball_X != 0)) begin
                    o_Ball_X <= o_Ball_X - 1;  // Move left
                end else begin
                    o_Ball_X <= o_Ball_X + 1;  // Move right
                end

                // Update ball Y position
                if ((r_Prev_Ball_Y < o_Ball_Y && (o_Ball_Y == c_GAME_HEIGHT-1)) ||
                    (r_Prev_Ball_Y > o_Ball_Y && o_Ball_Y != 0)) begin
                    o_Ball_Y <= o_Ball_Y - 1;  // Move up
                end else begin
                    o_Ball_Y <= o_Ball_Y + 1;  // Move down
                end
            end 
        end else begin 
            // Reset ball to the center when the game is off
            o_Ball_X <= c_GAME_WIDTH / 2;
            o_Ball_Y <= c_GAME_HEIGHT / 2;
            r_Prev_Ball_X <= c_GAME_WIDTH / 2 + 1;
            r_Prev_Ball_Y <= c_GAME_HEIGHT / 2 - 1;
        end
    end

    // Always block to set the draw ball signal based on current position
    always @(posedge i_Clk) begin 
        if (i_Col_Counter == o_Ball_X && i_Row_Counter == o_Ball_Y) begin
            o_Draw_Ball <= 1'b1;  // Draw ball at the current position
        end else begin
            o_Draw_Ball <= 1'b0;  // Do not draw ball
        end
    end

endmodule
