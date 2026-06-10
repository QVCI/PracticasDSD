LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CA IS PORT
(
    CLKOUT : IN  STD_LOGIC;
    TRAN   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE A_CA OF CA IS

    SIGNAL AUX : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";

BEGIN

    PROCESS(CLKOUT)
    BEGIN

        IF RISING_EDGE(CLKOUT) THEN

            CASE AUX IS

                WHEN "0001" =>
                    AUX <= "0010";

                WHEN "0010" =>
                    AUX <= "0100";

                WHEN "0100" =>
                    AUX <= "1000";

                WHEN OTHERS =>
                    AUX <= "0001";

            END CASE;

        END IF;

    END PROCESS;

    TRAN <= AUX;

END A_CA;