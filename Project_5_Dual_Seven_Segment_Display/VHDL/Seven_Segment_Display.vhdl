library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Seven_Segment_Display is
    port (
        i_Clk       : in  std_logic;
        i_Switch_1  : in  std_logic;
        i_Switch_2  : in  std_logic;
        o_Segment2_A : out std_logic;
        o_Segment2_B : out std_logic;
        o_Segment2_C : out std_logic;
        o_Segment2_D : out std_logic;
        o_Segment2_E : out std_logic;
        o_Segment2_F : out std_logic;
        o_Segment2_G : out std_logic;
        o_Segment1_A : out std_logic;
        o_Segment1_B : out std_logic;
        o_Segment1_C : out std_logic;
        o_Segment1_D : out std_logic;
        o_Segment1_E : out std_logic;
        o_Segment1_F : out std_logic;
        o_Segment1_G : out std_logic
    );
end entity Seven_Segment_Display;

architecture RTL of Seven_Segment_Display is
    signal w_Switch_1       : std_logic;
    signal w_Switch_2       : std_logic;
    signal r_Switch_1       : std_logic := '0';
    signal r_Binary_Count   : std_logic_vector(3 downto 0) := (others => '0');
    signal r_Binary_Count2  : std_logic_vector(3 downto 0) := (others => '0');

    signal w_Segment2_A : std_logic;
    signal w_Segment2_B : std_logic;
    signal w_Segment2_C : std_logic;
    signal w_Segment2_D : std_logic;
    signal w_Segment2_E : std_logic;
    signal w_Segment2_F : std_logic;
    signal w_Segment2_G : std_logic;
    
    signal w_Segment1_A : std_logic;
    signal w_Segment1_B : std_logic;
    signal w_Segment1_C : std_logic;
    signal w_Segment1_D : std_logic;
    signal w_Segment1_E : std_logic;
    signal w_Segment1_F : std_logic;
    signal w_Segment1_G : std_logic;

begin

    Debounce_Switch: entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk,
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );

    p_Switch_Count : process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            if i_Switch_2 = '1' then
                r_Binary_Count <= (others => '0');
                r_Binary_Count2 <= (others => '0');
            else
                r_Switch_1 <= w_Switch_1;
                if w_Switch_1 = '1' and r_Switch_1 = '0' then
                    if r_Binary_Count = "1001" then
                        r_Binary_Count <= (others => '0');
                        if r_Binary_Count2 = "1001" then
                            r_Binary_Count2 <= (others => '0');
                        else
                            r_Binary_Count2 <= std_logic_vector(unsigned(r_Binary_Count2) + 1);
                        end if;
                    else
                        r_Binary_Count <= std_logic_vector(unsigned(r_Binary_Count) + 1);
                    end if;
                end if;
            end if;
        end if;
    end process p_Switch_Count;

    -- Instantiate the 7-segment display encoder for the first digit
    Binary_To_7Segment_1: entity work.Binary_To_7Segment
    port map (
        i_Binary_Num => r_Binary_Count2,
        o_Segment_A  => w_Segment1_A,
        o_Segment_B  => w_Segment1_B,
        o_Segment_C  => w_Segment1_C,
        o_Segment_D  => w_Segment1_D,
        o_Segment_E  => w_Segment1_E,
        o_Segment_F  => w_Segment1_F,
        o_Segment_G  => w_Segment1_G
    );

    -- Instantiate the 7-segment display encoder for the second digit
    Binary_To_7Segment_2: entity work.Binary_To_7Segment
    port map (
        i_Binary_Num => r_Binary_Count,
        o_Segment_A  => w_Segment2_A,
        o_Segment_B  => w_Segment2_B,
        o_Segment_C  => w_Segment2_C,
        o_Segment_D  => w_Segment2_D,
        o_Segment_E  => w_Segment2_E,
        o_Segment_F  => w_Segment2_F,
        o_Segment_G  => w_Segment2_G
    );

    o_Segment1_A <= not w_Segment1_A;
    o_Segment1_B <= not w_Segment1_B;
    o_Segment1_C <= not w_Segment1_C;
    o_Segment1_D <= not w_Segment1_D;
    o_Segment1_E <= not w_Segment1_E;
    o_Segment1_F <= not w_Segment1_F;
    o_Segment1_G <= not w_Segment1_G;
    
    o_Segment2_A <= not w_Segment2_A;
    o_Segment2_B <= not w_Segment2_B;
    o_Segment2_C <= not w_Segment2_C;
    o_Segment2_D <= not w_Segment2_D;
    o_Segment2_E <= not w_Segment2_E;
    o_Segment2_F <= not w_Segment2_F;
    o_Segment2_G <= not w_Segment2_G;

end architecture RTL;
