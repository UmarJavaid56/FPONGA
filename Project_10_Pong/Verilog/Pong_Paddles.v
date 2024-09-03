module Pong_Paddles#(
    parameter c_GAME_HEIGHT = 30,
    parameter c_PADDLE_HEIGHT = 5,
    parameter c_PADDLE_X = 0
)
(
    input i_Clk,
    input [5:0] i_Col_Count,
    input [5:0] i_Row_Count,
    input i_Paddle_Up,
    input i_Paddle_Dn,
    output reg o_Draw_Paddle,
    output reg [5:0] o_Paddle_Y
);

    // Speed of paddle movement, controlled by a counter.
    parameter c_PADDLE_SPEED = 1250000; 
    reg [31:0] r_Counter;
    wire w_Paddle_Count_Enable;
    
    // Enable paddle movement only if one of the movement buttons is pressed.
    assign w_Paddle_Count_Enable = i_Paddle_Up ^ i_Paddle_Dn;
    
    always @(posedge i_Clk) 
    begin
        // Handle paddle movement speed.
        if(w_Paddle_Count_Enable == 1'b1)
        begin
            if(r_Counter == c_PADDLE_SPEED)
                r_Counter <= 0;
            else
                r_Counter <= r_Counter + 1;
        end      
        
        // Update paddle position, ensuring it does not go out of game bounds.
        if(i_Paddle_Up == 1'b1 && r_Counter == c_PADDLE_SPEED && o_Paddle_Y !== 0)
            o_Paddle_Y <= o_Paddle_Y - 1;
        else if(i_Paddle_Dn == 1'b1 && r_Counter == c_PADDLE_SPEED && o_Paddle_Y !== c_GAME_HEIGHT - c_PADDLE_HEIGHT - 1)
            o_Paddle_Y <= o_Paddle_Y + 1;
    end
    
    always @(posedge i_Clk)
    begin 
        // Determine if the paddle should be drawn in the current column and row.
        if(i_Col_Count == c_PADDLE_X && i_Row_Count >= o_Paddle_Y && i_Row_Count <= o_Paddle_Y + c_PADDLE_HEIGHT)
            o_Draw_Paddle <= 1'b1;
        else
            o_Draw_Paddle <= 1'b0;
    end
    
endmodule
