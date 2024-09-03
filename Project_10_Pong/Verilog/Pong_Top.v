module Pong_Top
  #(parameter c_TOTAL_COLS=800,
    parameter c_TOTAL_ROWS=525,
    parameter c_ACTIVE_COLS=640,
    parameter c_ACTIVE_ROWS=480)
  (input            i_Clk,
   input            i_HSync,
   input            i_VSync,
   // Start Game Button   
   input            i_Game_Start,
   // Player 1 and Player 2 Controls 
   input            i_Paddle_Up_P1,
   input            i_Paddle_Dn_P1,
   input            i_Paddle_Up_P2,
   input            i_Paddle_Dn_P2,
   // Output Video
   output reg       o_HSync,
   output reg       o_VSync,
   output [3:0] o_Red_Video,
   output [3:0] o_Grn_Video,
   output [3:0] o_Blu_Video,
   output [3:0] o_Score_P1,
   output [3:0] o_Score_P2
   );
   
   parameter c_GAME_WIDTH  = 40;
   parameter c_GAME_HEIGHT = 30;
   parameter c_SCORE_LIMIT = 9;
   parameter c_PADDLE_HEIGHT = 5;
   parameter c_PADDLE_COL_P1 = 0;  // Paddle Placement for P1
   parameter c_PADDLE_COL_P2 = c_GAME_WIDTH-1; // Paddle Placement for P2
   
   // State Machine 
   parameter IDLE    = 3'b000;
   parameter RUNNING = 3'b001;
   parameter P1_WINS = 3'b010;
   parameter P2_WINS = 3'b011;
   parameter CLEANUP = 3'b100;
   
   reg [2:0] r_State_Machine = IDLE;
 
   wire       w_HSync, w_VSync;
   wire [9:0] w_Col_Count, w_Row_Count;
   
   wire       w_Draw_Paddle_P1, w_Draw_Paddle_P2;
   wire [5:0] w_Paddle_Y_P1, w_Paddle_Y_P2;
   wire       w_Draw_Ball, w_Draw_Any;
   wire [5:0] w_Ball_X, w_Ball_Y;
 
   reg [3:0] r_P1_Score = 0;
   reg [3:0] r_P2_Score = 0;
 
  // Divided version of the Row/Col Counters
  // Allows us to make the board 40x30
   wire [5:0] w_Col_Count_Div, w_Row_Count_Div;
   
    Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS),
                  .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
    (.i_Clk(i_Clk),
     .i_HSync(i_HSync),
     .i_VSync(i_VSync),
     .o_HSync(w_HSync),
     .o_VSync(w_VSync),
     .o_Col_Count(w_Col_Count),
     .o_Row_Count(w_Row_Count));
   
   always @(posedge i_Clk)
		begin
		o_HSync <= w_HSync;
		o_VSync <= w_VSync;
		end
		
   // By removing the 4 Least Significant Bits we can divide by 16
   // Original Height = 480, New Height = 480/16 = 30;
   // Original Width = 640, New Width = 640/16 = 40;
   assign w_Col_Count_Div = w_Col_Count[9:4];
   assign w_Row_Count_Div = w_Row_Count[9:4];
   
   Pong_Paddles#(.c_GAME_HEIGHT(c_GAME_HEIGHT), .c_PADDLE_HEIGHT(c_PADDLE_HEIGHT), .c_PADDLE_X(c_PADDLE_COL_P1)) P1_Instance
   (
	.i_Clk(i_Clk),
	.i_Col_Count(w_Col_Count_Div),
	.i_Row_Count(w_Row_Count_Div),
	.i_Paddle_Up(i_Paddle_Up_P1),
	.i_Paddle_Dn(i_Paddle_Dn_P1),
	.o_Draw_Paddle(w_Draw_Paddle_P1),
	.o_Paddle_Y(w_Paddle_Y_P1)
   );
   
    Pong_Paddles#(.c_GAME_HEIGHT(c_GAME_HEIGHT), .c_PADDLE_HEIGHT(c_PADDLE_HEIGHT), .c_PADDLE_X(c_PADDLE_COL_P2)) P2_Instance
   (
	.i_Clk(i_Clk),
	.i_Col_Count(w_Col_Count_Div),
	.i_Row_Count(w_Row_Count_Div),
	.i_Paddle_Up(i_Paddle_Up_P2),
	.i_Paddle_Dn(i_Paddle_Dn_P2),
	.o_Draw_Paddle(w_Draw_Paddle_P2),
	.o_Paddle_Y(w_Paddle_Y_P2)
   );
   
   Pong_Ball #(.c_GAME_HEIGHT(c_GAME_HEIGHT), .c_GAME_WIDTH(c_GAME_WIDTH)) Ball_Instance
   (
	.i_Clk(i_Clk),
	.i_Game_On(w_Game_On),
	.i_Col_Counter(w_Col_Count_Div),
	.i_Row_Counter(w_Row_Count_Div),
	.o_Ball_X(w_Ball_X),
	.o_Ball_Y(w_Ball_Y),
	.o_Draw_Ball(w_Draw_Ball)
   );
   
   always @(posedge i_Clk)
		begin
			case(r_State_Machine)

		// IDLE: Stay in this mode until Game_Start is set to HIGH.
		IDLE:
		begin
			if(i_Game_Start == 1'b1)
				r_State_Machine <= RUNNING;
		end
		
		// RUNNING: Stay in this mode until P1 or P2 scores.
		RUNNING:
		begin
			if(w_Ball_X == 0 && (w_Ball_Y < w_Paddle_Y_P1 || w_Ball_Y > w_Paddle_Y_P1 + c_PADDLE_HEIGHT)) // P2 scores
				r_State_Machine <= P2_WINS;
			
			else if(w_Ball_X == c_GAME_WIDTH-1 && (w_Ball_Y < w_Paddle_Y_P2 || w_Ball_Y > w_Paddle_Y_P2 + c_PADDLE_HEIGHT)) // P1 scores
				r_State_Machine <= P1_WINS;
		end
	
		
		// P1_WINS: Update Score 
		P1_WINS:
		begin
			if(r_P1_Score == c_SCORE_LIMIT)
				r_P1_Score <= 0;
			else
				begin
				r_P1_Score <= r_P1_Score + 1;
				r_State_Machine <= CLEANUP;
				end
		end
		
		// P2_WINS: Update Score
		P2_WINS:
		begin
			if(r_P2_Score == c_SCORE_LIMIT)
				r_P2_Score <= 0;
			else
				begin
				r_P2_Score <= r_P2_Score + 1;
				r_State_Machine <= CLEANUP;
				end
		end
		
		// CLEANUP: Prepare next round 
		CLEANUP:
			r_State_Machine <= IDLE;
		
		endcase
		
		end
		
		// if Game is still running, keep Game_On signal HI
	assign w_Game_On = (r_State_Machine == RUNNING) ? 1'b1 : 1'b0;
		
		// Draw Paddles and Ball.
	assign w_Draw_Any = w_Draw_Ball | w_Draw_Paddle_P1 | w_Draw_Paddle_P2;
	
		// If Object is ready to be drawn, draw it in white. 
	assign o_Red_Video = w_Draw_Any ? 4'b1111 : 4'b0000;
	assign o_Grn_Video = w_Draw_Any ? 4'b0000 : 4'b0000;
	assign o_Blu_Video = w_Draw_Any ? 4'b1111 : 4'b0000;
	
	assign o_Score_P1 = r_P1_Score;
	assign o_Score_P2 = r_P2_Score;
endmodule