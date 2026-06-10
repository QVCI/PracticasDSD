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

    CONSTANT DIVISOR : INTEGER := 1350000;
    SIGNAL CONT : INTEGER := 0;
    SIGNAL CLK_DIV : STD_LOGIC := '0';

    SIGNAL Q : INTEGER RANGE 1 TO 6 := 1;

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
        Q <= 1;

    ELSIF RISING_EDGE(CLK_DIV) THEN
    
        IF PARO = '1' THEN      -- contando
            IF Q = 6 THEN
                Q <= 1;
            ELSE
                Q <= Q + 1;
            END IF;
        END IF;                 -- si PARO='1', conserva Q

    END IF;
END PROCESS;

    
    -- Codificador para el display
    WITH Q SELECT
        DISPLAY <=

        "01100000" WHEN 1, -- 1
        "11011010" WHEN 2, -- 2
        "11110010" WHEN 3, -- 3
        "01100110" WHEN 4, -- 4
        "10110110" WHEN 5, -- 5
        "10111110" WHEN 6, -- 6
        "00000000" WHEN OTHERS;
END ARCHITECTURE;
