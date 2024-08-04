library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debounce_Switch is
    port (
        i_Clk    : in  std_logic;
        i_Switch : in  std_logic;
        o_Switch : out std_logic
    );
end entity Debounce_Switch;

architecture RTL of Debounce_Switch is
    constant c_TIME_LIMIT: integer := 250000;
    signal r_State : std_logic := '0';
    signal r_Count : integer range 0 to c_TIME_LIMIT := 0;
begin
    d_Flipflop : process(i_Clk)
    begin
        if rising_edge(i_Clk) then
            if i_Switch /= r_State then
                if r_Count < c_TIME_LIMIT then
                    r_Count <= r_Count + 1;
                else
                    r_State <= i_Switch;
                    r_Count <= 0;  -- Reset the count after the state change
                end if;
            else
                r_Count <= 0;  -- Reset the count if the input matches the state
            end if;
        end if;
    end process d_Flipflop;

    o_Switch <= r_State;  -- Output the debounced state
end architecture RTL;
