// Module definition for LED_Blink with parameterized blink rates
module LED_Blink 
  #(
    parameter g_COUNT_1HZ = 12500000,  // Count for 1 Hz blink rate
    parameter g_COUNT_2HZ = 6250000,   // Count for 2 Hz blink rate
	parameter g_COUNT_5HZ = 2500000,   // Count for 5 Hz blink rate
    parameter g_COUNT_10HZ = 1250000   // Count for 10 Hz blink rate
  )
  (
   input i_Clk,                        // Clock input
   output reg o_LED_1 = 1'b0,          // Output to LED1, initialized to 0
   output reg o_LED_2 = 1'b0,          // Output to LED2, initialized to 0
   output reg o_LED_3 = 1'b0,          // Output to LED3, initialized to 0
   output reg o_LED_4 = 1'b0           // Output to LED4, initialized to 0
  );

  // Counter registers for each LED
  reg [31:0] r_Count_1Hz  = 0;         // Counter for 1Hz blink rate
  reg [31:0] r_Count_2Hz  = 0;         // Counter for 2Hz blink rate
  reg [31:0] r_Count_5Hz  = 0;         // Counter for 5Hz blink rate
  reg [31:0] r_Count_10Hz = 0;         // Counter for 10Hz blink rate 

  // Process for 1Hz LED blinking
  always @(posedge i_Clk)
  begin
    if (r_Count_1Hz == g_COUNT_1HZ)
    begin
      o_LED_4     <= ~o_LED_4;         // Toggle LED4
      r_Count_1Hz <= 0;                // Reset counter
    end
    else
      r_Count_1Hz <= r_Count_1Hz + 1;  // Increment counter
  end
  
  // Process for 2Hz LED blinking
  always @(posedge i_Clk)
  begin
    if (r_Count_2Hz == g_COUNT_2HZ)
    begin
      o_LED_3     <= ~o_LED_3;         // Toggle LED3
      r_Count_2Hz <= 0;                // Reset counter
    end
    else
      r_Count_2Hz <= r_Count_2Hz + 1;  // Increment counter
  end
  
  // Process for 5Hz LED blinking
  always @(posedge i_Clk)
  begin
    if (r_Count_5Hz == g_COUNT_5HZ)
    begin
      o_LED_2     <= ~o_LED_2;         // Toggle LED2
      r_Count_5Hz <= 0;                // Reset counter
    end
    else
      r_Count_5Hz <= r_Count_5Hz + 1;  // Increment counter
  end
  
  // Process for 10Hz LED blinking
  always @(posedge i_Clk)
  begin
    if (r_Count_10Hz == g_COUNT_10HZ)
    begin
      o_LED_1      <= ~o_LED_1;        // Toggle LED1
      r_Count_10Hz <= 0;               // Reset counter
    end
    else
      r_Count_10Hz <= r_Count_10Hz + 1; // Increment counter
  end
endmodule
