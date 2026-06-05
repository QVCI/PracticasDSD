LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DADO IS
    PORT(
        CLK     : IN  STD_LOGIC;
        CLR     : IN  STD_LOGIC;
        Paro    : IN  STD_LOGIC;
        DISPLAY : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   
    );
END ENTITY;

ARCHITECTURE A_DADO OF DADO IS

    CONSTANT DIVISOR : INTEGER := 6750000;
    SIGNAL CONT : INTEGER := 0;
    SIGNAL CLK_DIV : STD_LOGIC := '0';

    SIGNAL Q : INTEGER RANGE 0 TO 9 := 0;

    SIGNAL NUM : INTEGER RANGE 0 TO 9 := 0;

BEGIN
    -- Divisor
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF CONT = DIVISOR - 1 THEN
                CONT <= 0;
                CLK_DIV <= NOT CLK_DIV;
            ELSE
                CONT <= CONT + 1;
            END IF;
        END IF;
    END PROCESS;


    PROCESS(CLK_DIV, CLR)
        BEGIN
            IF CLR = '0' THEN
                Q <= 0;
            ELSIF RISING_EDGE(CLK_DIV) THEN
                IF Q = 9 THEN
                        Q <= 0;
                   ELSE
                        Q <= Q + 1;
                        END IF;
              
            END IF;
        END PROCESS;

    
    -- Codificador para el display
    WITH Q SELECT
        DISPLAY <=
        "11111100" WHEN 0, -- 0
        "01100000" WHEN 1, -- 1
        "11011010" WHEN 2, -- 2
        "11110010" WHEN 3, -- 3
        "01100110" WHEN 4, -- 4
        "10110110" WHEN 5, -- 5
        "10111110" WHEN 6, -- 6
        "11100000" WHEN 7, -- 7
        "11111110" WHEN 8, -- 8
        "11110110" WHEN 9, -- 9
        "00000000" WHEN OTHERS;
END ARCHITECTURE;
