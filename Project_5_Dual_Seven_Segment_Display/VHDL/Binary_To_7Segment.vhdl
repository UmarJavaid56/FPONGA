library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Binary_To_7Segment is
    port (
        i_Binary_Num : in  std_logic_vector(3 downto 0);
        o_Segment_A  : out std_logic;
        o_Segment_B  : out std_logic;
        o_Segment_C  : out std_logic;
        o_Segment_D  : out std_logic;
        o_Segment_E  : out std_logic;
        o_Segment_F  : out std_logic;
        o_Segment_G  : out std_logic
    );
end entity Binary_To_7Segment;

architecture RTL of Binary_To_7Segment is
    signal r_Hex_Encoding : std_logic_vector(7 downto 0) := (others => '0');
begin
    process (i_Binary_Num)
    begin
        case i_Binary_Num is
            when "0000" =>
                r_Hex_Encoding <= X"7E";  -- 8'b01111110
            when "0001" =>
                r_Hex_Encoding <= X"30";  -- 8'b00110000
            when "0010" =>
                r_Hex_Encoding <= X"6D";  -- 8'b01101101
            when "0011" =>
                r_Hex_Encoding <= X"79";  -- 8'b01111001
            when "0100" =>
                r_Hex_Encoding <= X"33";  -- 8'b00110011
            when "0101" =>
                r_Hex_Encoding <= X"5B";  -- 8'b01011011
            when "0110" =>
                r_Hex_Encoding <= X"5F";  -- 8'b01011111
            when "0111" =>
                r_Hex_Encoding <= X"70";  -- 8'b01110000
            when "1000" =>
                r_Hex_Encoding <= X"7F";  -- 8'b01111111
            when "1001" =>
                r_Hex_Encoding <= X"7B";  -- 8'b01111011
            when "1010" =>
                r_Hex_Encoding <= X"77";  -- 8'b01110111
            when "1011" =>
                r_Hex_Encoding <= X"1F";  -- 8'b00011111
            when "1100" =>
                r_Hex_Encoding <= X"4E";  -- 8'b01001110
            when "1101" =>
                r_Hex_Encoding <= X"3D";  -- 8'b00111101
            when "1110" =>
                r_Hex_Encoding <= X"4F";  -- 8'b01001111
            when "1111" =>
                r_Hex_Encoding <= X"47";  -- 8'b01000111
            when others =>
                r_Hex_Encoding <= X"00";  -- Default case to handle any unexpected input
        end case;
    end process;

    o_Segment_G <= r_Hex_Encoding(0);
    o_Segment_F <= r_Hex_Encoding(1);
    o_Segment_E <= r_Hex_Encoding(2);
    o_Segment_D <= r_Hex_Encoding(3);
    o_Segment_C <= r_Hex_Encoding(4);
    o_Segment_B <= r_Hex_Encoding(5);
    o_Segment_A <= r_Hex_Encoding(6);

end architecture RTL;
