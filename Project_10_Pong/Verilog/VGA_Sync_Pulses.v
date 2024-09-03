module VGA_Sync_Pulses 
#(
   parameter TOTAL_COLS  = 800,  // Total number of columns (including sync and blanking)
   parameter TOTAL_ROWS  = 525,  // Total number of rows (including sync and blanking)
   parameter ACTIVE_COLS = 640,  // Number of active columns (visible area)
   parameter ACTIVE_ROWS = 480   // Number of active rows (visible area)
)
(
   input            i_Clk,            // Clock signal
   output           o_HSync,          // Horizontal sync signal
   output           o_VSync,          // Vertical sync signal
   output reg [9:0] o_Col_Count = 0,  // Current column count
   output reg [9:0] o_Row_Count = 0   // Current row count
);

  // Update column and row counts on each clock edge
  always @(posedge i_Clk) begin
    if (o_Col_Count == TOTAL_COLS - 1) begin
      o_Col_Count <= 0; // Reset column count at the end of the line
      if (o_Row_Count == TOTAL_ROWS - 1)
        o_Row_Count <= 0; // Reset row count at the end of the frame
      else
        o_Row_Count <= o_Row_Count + 1; // Increment row count
    end
    else
      o_Col_Count <= o_Col_Count + 1; // Increment column count
  end
  
  // Generate horizontal sync pulse
  assign o_HSync = o_Col_Count < ACTIVE_COLS ? 1'b1 : 1'b0;
  
  // Generate vertical sync pulse
  assign o_VSync = o_Row_Count < ACTIVE_ROWS ? 1'b1 : 1'b0;

endmodule
