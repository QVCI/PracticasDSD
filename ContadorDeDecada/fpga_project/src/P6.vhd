-- PRÁCTICA 6
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY P6 IS
    PORT(
        CLK     : IN  STD_LOGIC;
        CLR     : IN  STD_LOGIC;
        CON     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        E       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        DISPLAY : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        TRAN      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE A_P6 OF P6 IS

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

    -- Codificador
    PROCESS(E)
    BEGIN
        IF E(9) = '1' THEN
            NUM <= 9;
        ELSIF E(8) = '1' THEN
            NUM <= 8;
        ELSIF E(7) = '1' THEN
            NUM <= 7;
        ELSIF E(6) = '1' THEN
            NUM <= 6;
        ELSIF E(5) = '1' THEN
            NUM <= 5;
        ELSIF E(4) = '1' THEN
            NUM <= 4;
        ELSIF E(3) = '1' THEN
            NUM <= 3;
        ELSIF E(2) = '1' THEN
            NUM <= 2;
        ELSIF E(1) = '1' THEN
            NUM <= 1;
        ELSE
            NUM <= 0;
        END IF;
    END PROCESS;

    -- CONTADOR
    PROCESS(CLK_DIV, CLR)
    BEGIN
        IF CLR = '0' THEN
            Q <= 0;
        ELSIF RISING_EDGE(CLK_DIV) THEN
            CASE CON IS
                -- Mantener
                WHEN "00" =>
                    Q <= Q;
                -- Ascendente
                WHEN "01" =>
                    IF Q = 9 THEN
                        Q <= 0;
                    ELSE
                        Q <= Q + 1;
                    END IF;
                -- Descendente
                WHEN "10" =>
                    IF Q = 0 THEN
                        Q <= 9;
                    ELSE
                        Q <= Q - 1;
                    END IF;
                -- Carga manual
                WHEN OTHERS =>
                    Q <= NUM;
            END CASE;
        END IF;
    END PROCESS;

    TRAN <= "0001";
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