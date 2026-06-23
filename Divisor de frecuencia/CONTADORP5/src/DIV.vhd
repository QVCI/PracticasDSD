library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DIV is
    port (
        CLK  : in  std_logic;
        CLR  : in  std_logic;
        CLKOUT : out std_logic;
        LED    : out std_logic;
        LEDAPAGADO : out std_logic_vector(5 downto 0)
    );
end DIV;

architecture A_DIV of DIV is
    signal CONTADOR: std_logic_vector(24 downto 0) := (others => '0');
    constant DIVISOR: integer := 27000000;
    signal RELOJ: std_logic := '0';
begin
    LEDAPAGADO <= (others => '0');

    process(CLK, CLR)
    begin
        if CLR = '1' then
            CONTADOR <= (others => '0');
            RELOJ <= '0';
        elsif rising_edge(CLK) then
            if (CONTADOR = DIVISOR - 1) then
                CONTADOR <= (others => '0');
                RELOJ <= not RELOJ;
            else
                CONTADOR <= CONTADOR + 1;
            end if;
        end if;
    end process;

    CLKOUT <= RELOJ;
    LED    <= RELOJ;
end A_DIV;