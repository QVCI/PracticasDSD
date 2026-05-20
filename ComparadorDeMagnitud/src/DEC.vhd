LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DEC IS PORT
(
    ENT:     STD_LOGIC_VECTOR (1 DOWNTO 0);
    DIS: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE A_DEC OF DEC IS
    BEGIN
    PROCESS(ENT)
        BEGIN
            CASE ENT IS
                WHEN "00" => DIS <= "1111110";
                WHEN "01" => DIS <= "0110000";
                WHEN "10" => DIS <= "1101101";
                WHEN OTHERS => DIS <= "1111001";
            END CASE;    
   END PROCESS;
END A_DEC;     

