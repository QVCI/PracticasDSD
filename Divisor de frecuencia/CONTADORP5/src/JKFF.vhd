library ieee;
use ieee.std_logic_1164.all;

entity JKFF is
    port (
        CLK : in  std_logic;
        CLR : in  std_logic;
        J   : in  std_logic;
        K   : in  std_logic;
        Q   : out std_logic
    );
end JKFF;

architecture AJKFF of JKFF is
    signal q_int : std_logic := '0';
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            q_int <= '0';
        elsif rising_edge(CLK) then
            q_int <= (J and not q_int) or (not K and q_int);
        end if;
    end process;
    Q <= q_int;
end AJKFF;