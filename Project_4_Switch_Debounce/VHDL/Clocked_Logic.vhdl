library ieee;
use ieee.std_logic_1164.all;

entity Clocked_Logic is
    port
    (
        i_Clk: in std_logic;
        i_Switch_1: in std_logic;
        o_LED_1: out std_logic
    );
end entity Clocked_Logic;

architecture RTL of Clocked_Logic is
    signal r_Switch_1: std_logic := '0';
    signal r_LED_1: std_logic := '0';
    signal w_Switch_1: std_logic;
begin
    Debounce_Inst : entity work.Debounce_Switch
    port map (
        i_Clk => i_Clk,
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );

    d_Flipflop : process(i_Clk) is
    begin 
        if rising_edge(i_Clk) then
            r_Switch_1 <= w_Switch_1;
            if (r_Switch_1 = '1' and w_Switch_1 = '0') then
                r_LED_1 <= not r_LED_1;
            end if;
        end if;
    end process d_Flipflop;

    o_LED_1 <= r_LED_1;
end architecture RTL;
