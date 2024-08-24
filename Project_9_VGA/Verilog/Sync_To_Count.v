module Sync_To_Count 
 #(parameter TOTAL_COLS = 800, // Total number of columns per frame
   parameter TOTAL_ROWS = 525) // Total number of rows per frame
  (input            i_Clk,      // Input clock
   input            i_HSync,    // Horizontal sync input
   input            i_VSync,    // Vertical sync input
   output reg       o_HSync = 0, // Buffered horizontal sync output
   output reg       o_VSync = 0, // Buffered vertical sync output
   output reg [9:0] o_Col_Count = 0, // Column counter
   output reg [9:0] o_Row_Count = 0); // Row counter
   
   wire w_Frame_Start; // Wire to detect the start of a new frame
   
  // Register syncs to align with output data
  always @(posedge i_Clk) // Triggered on the rising edge of the input clock
  begin
    o_VSync <= i_VSync; // Buffer vertical sync
    o_HSync <= i_HSync; // Buffer horizontal sync
  end

  // Keep track of Row/Column counters
  always @(posedge i_Clk) // Triggered on the rising edge of the input clock
  begin
    if (w_Frame_Start == 1'b1) // If it's the start of a new frame
    begin
      o_Col_Count <= 0; // Reset column count
      o_Row_Count <= 0; // Reset row count
    end
    else // Otherwise, continue counting
    begin
      if (o_Col_Count == TOTAL_COLS-1) // If the last column is reached
      begin
        if (o_Row_Count == TOTAL_ROWS-1) // If the last row is reached
        begin
          o_Row_Count <= 0; // Reset row count to start a new frame
        end
        else
        begin
          o_Row_Count <= o_Row_Count + 1; // Increment row count
        end
        o_Col_Count <= 0; // Reset column count at the end of each row
      end
      else
      begin
        o_Col_Count <= o_Col_Count + 1; // Increment column count
      end
    end
  end
  
    
  // Look for rising edge on Vertical Sync to reset the counters
  assign w_Frame_Start = (~o_VSync & i_VSync); // Detects rising edge of vertical sync signal

endmodule
