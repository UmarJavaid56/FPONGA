library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration for LED_Blink
entity LED_Blink is
  generic (
    g_COUNT_10HZ : integer;  -- Maximum count for 10Hz blinking rate
    g_COUNT_5HZ  : integer;  -- Maximum count for 5Hz blinking rate
    g_COUNT_2HZ  : integer;  -- Maximum count for 2Hz blinking rate
    g_COUNT_1HZ  : integer); -- Maximum count for 1Hz blinking rate
  port (
    i_Clk   : in  std_logic;  -- Clock input
    o_LED_1 : out std_logic;  -- Output to control LED for 10Hz blink
    o_LED_2 : out std_logic;  -- Output to control LED for 5Hz blink
    o_LED_3 : out std_logic;  -- Output to control LED for 2Hz blink
    o_LED_4 : out std_logic   -- Output to control LED for 1Hz blink
    );                        -- This semicolon is crucial
end LED_Blink;

-- Architecture definition for the LED_Blink
architecture RTL of LED_Blink is
  -- Count signals for each frequency
  signal r_Count_10Hz : integer range 0 to g_COUNT_10HZ;
  signal r_Count_5Hz  : integer range 0 to g_COUNT_5HZ;
  signal r_Count_2Hz  : integer range 0 to g_COUNT_2HZ;
  signal r_Count_1Hz  : integer range 0 to g_COUNT_1HZ;
  
  -- Toggle signals for each LED
  signal r_Toggle_10Hz : std_logic := '0';
  signal r_Toggle_5Hz  : std_logic := '0';
  signal r_Toggle_2Hz  : std_logic := '0';
  signal r_Toggle_1Hz  : std_logic := '0';

begin
  -- Connect toggle signals to LED outputs
  o_LED_1 <= r_Toggle_10Hz;
  o_LED_2 <= r_Toggle_5Hz;
  o_LED_3 <= r_Toggle_2Hz;
  o_LED_4 <= r_Toggle_1Hz;
  
  -- Process for controlling the 10 Hz blinking
  p_10_Hz : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_10Hz = g_COUNT_10HZ then
        r_Toggle_10Hz <= not r_Toggle_10Hz; -- Toggle the LED state
        r_Count_10Hz  <= 0;                 -- Reset the count
      else
        r_Count_10Hz <= r_Count_10Hz + 1;   -- Increment the count
      end if;
    end if;
  end process p_10_Hz;

  -- Process for controlling the 5 Hz blinking
  p_5_Hz : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_5Hz = g_COUNT_5HZ then
        r_Toggle_5Hz <= not r_Toggle_5Hz;
        r_Count_5Hz  <= 0;
      else
        r_Count_5Hz <= r_Count_5Hz + 1;
      end if;
    end if;
  end process p_5_Hz;

  -- Process for controlling the 2 Hz blinking
  p_2_Hz : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_2Hz = g_COUNT_2HZ then
        r_Toggle_2Hz <= not r_Toggle_2Hz;
        r_Count_2Hz  <= 0;
      else
        r_Count_2Hz <= r_Count_2Hz + 1;
      end if;
    end if;
  end process p_2_Hz;

  -- Process for controlling the 1 Hz blinking
  p_1_Hz : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_1Hz = g_COUNT_1HZ then
        r_Toggle_1Hz <= not r_Toggle_1Hz;
        r_Count_1Hz  <= 0;
      else
        r_Count_1Hz <= r_Count_1Hz + 1;
      end if;
    end if;
  end process p_1_Hz;

end RTL; 
