module VGA_Sync_Porch #(
    parameter VIDEO_WIDTH = 3,  // Width of video data bus
    parameter TOTAL_COLS  = 800, // Total number of columns (including sync and blanking)
    parameter TOTAL_ROWS  = 525, // Total number of rows (including sync and blanking)
    parameter ACTIVE_COLS = 640, // Number of active columns (visible area)
    parameter ACTIVE_ROWS = 480  // Number of active rows (visible area)
)(
    input i_Clk,                    // Clock signal
    input i_HSync,                  // Input horizontal sync signal
    input i_VSync,                  // Input vertical sync signal
    input [VIDEO_WIDTH-1:0] i_Red_Video, // Input red video data
    input [VIDEO_WIDTH-1:0] i_Grn_Video, // Input green video data
    input [VIDEO_WIDTH-1:0] i_Blu_Video, // Input blue video data
    output reg o_HSync,             // Output horizontal sync signal
    output reg o_VSync,             // Output vertical sync signal
    output reg [VIDEO_WIDTH-1:0] o_Red_Video, // Output red video data
    output reg [VIDEO_WIDTH-1:0] o_Grn_Video, // Output green video data
    output reg [VIDEO_WIDTH-1:0] o_Blu_Video  // Output blue video data
);

  // Timing parameters for VGA sync signals
  parameter c_FRONT_PORCH_HORZ = 18;  // Front porch duration (horizontal)
  parameter c_BACK_PORCH_HORZ  = 50;  // Back porch duration (horizontal)
  parameter c_FRONT_PORCH_VERT = 10;  // Front porch duration (vertical)
  parameter c_BACK_PORCH_VERT  = 33;  // Back porch duration (vertical)
  
  wire w_HSync;                     // Internal wire for horizontal sync signal
  wire w_VSync;                     // Internal wire for vertical sync signal
  wire [9:0] w_Col_Count;          // Internal wire for column count
  wire [9:0] w_Row_Count;          // Internal wire for row count
  
  reg [VIDEO_WIDTH-1:0] r_Red_Video = 0; // Internal register for red video data
  reg [VIDEO_WIDTH-1:0] r_Grn_Video = 0; // Internal register for green video data
  reg [VIDEO_WIDTH-1:0] r_Blu_Video = 0; // Internal register for blue video data
  
  // Instantiate Sync_To_Count module to handle column and row counting
  Sync_To_Count #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS)
  ) UUT (
    .i_Clk(i_Clk),
    .i_HSync(i_HSync),
    .i_VSync(i_VSync),
    .o_HSync(w_HSync),
    .o_VSync(w_VSync),
    .o_Col_Count(w_Col_Count),
    .o_Row_Count(w_Row_Count)
  );
  
  // Generate sync signals based on column and row counts
  always @(posedge i_Clk) begin
    // Set horizontal sync signal
    if ((w_Col_Count < c_FRONT_PORCH_HORZ + ACTIVE_COLS) || 
        (w_Col_Count > TOTAL_COLS - c_BACK_PORCH_HORZ - 1))
      o_HSync <= 1'b1; // Set sync high during front and back porch
    else
      o_HSync <= w_HSync; // Use input sync signal otherwise
    
    // Set vertical sync signal
    if ((w_Row_Count < c_FRONT_PORCH_VERT + ACTIVE_ROWS) ||
        (w_Row_Count > TOTAL_ROWS - c_BACK_PORCH_VERT - 1))
      o_VSync <= 1'b1; // Set sync high during front and back porch
    else
      o_VSync <= w_VSync; // Use input sync signal otherwise
  end

  // Pass video data through
  always @(posedge i_Clk) begin
    r_Red_Video <= i_Red_Video; // Store red video data
    r_Grn_Video <= i_Grn_Video; // Store green video data
    r_Blu_Video <= i_Blu_Video; // Store blue video data

    // Output the stored video data
    o_Red_Video <= r_Red_Video;
    o_Grn_Video <= r_Grn_Video;
    o_Blu_Video <= r_Blu_Video;
  end
  
endmodule
