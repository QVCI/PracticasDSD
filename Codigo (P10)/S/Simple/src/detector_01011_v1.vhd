library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity detector_01011_v1 is
    Port (
        CLK      : in  STD_LOGIC;
        CLR      : in  STD_LOGIC;
        E        : in  STD_LOGIC;
        S        : out STD_LOGIC;
        LED      : out STD_LOGIC;
        ESTADO   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end detector_01011_v1;

architecture Behavioral of detector_01011_v1 is
    constant DIVISOR : integer := 4;
    signal CONTADOR : integer range 0 to DIVISOR - 1 := 0;
    signal CLK_DIV : STD_LOGIC := '0';

    
    type state_type is (S0, S1, S2, S3, S4, S5);
    signal state, next_state : state_type;
    signal S_int : STD_LOGIC;

begin
    PROCESS(CLK, CLR)
    BEGIN
        IF CLR = '1' THEN
            CONTADOR <= 0;
            CLK_DIV <= '0';
        ELSIF RISING_EDGE(CLK) THEN
            IF CONTADOR = DIVISOR - 1 THEN
                CONTADOR <= 0;
                CLK_DIV <= NOT CLK_DIV;
            ELSE
                CONTADOR <= CONTADOR + 1;
            END IF;
        END IF;
    END PROCESS;

    PROCESS(CLK_DIV, CLR)
    BEGIN
        IF CLR = '1' THEN
            state <= S0;
        ELSIF RISING_EDGE(CLK_DIV) THEN
            state <= next_state;
        END IF;
    END PROCESS;

    --                         0  1  0  1  1
    --                     S0->S1->S2->S3->S4->S5
    PROCESS(state, E)
    BEGIN
        next_state <= state;
        S_int <= '0';

        CASE state IS
            WHEN S0 =>  -- sin nada
                IF E = '0' THEN
                    next_state <= S1;   -- "0"
                ELSE
                    next_state <= S0;   -- "1" no sirve de inicio
                END IF;

            WHEN S1 =>  -- con "0"
                IF E = '1' THEN
                    next_state <= S2;   -- "01"
                ELSE
                    next_state <= S1;   -- "00"
                END IF;

            WHEN S2 =>  -- con "01"
                IF E = '0' THEN
                    next_state <= S3;   -- "010"
                ELSE
                    next_state <= S0;   -- "011"!=
                END IF;

            WHEN S3 =>  -- con "010"
                IF E = '1' THEN
                    next_state <= S4;   -- "0101"
                ELSE
                    next_state <= S1;   -- "0100"
                END IF;

            WHEN S4 =>  -- con "0101"
                IF E = '1' THEN
                    next_state <= S5;   -- "01011" COMPLETO
                ELSE
                    next_state <= S3;   -- "01010"
                END IF;

            WHEN S5 =>  
                S_int <= '1';
                next_state <= S0;

        END CASE;
    END PROCESS;

    S   <= S_int;
    LED <= S_int;

    WITH state SELECT
        ESTADO <= "000" WHEN S0,
                  "001" WHEN S1,
                  "010" WHEN S2,
                  "011" WHEN S3,
                  "100" WHEN S4,
                  "101" WHEN S5;
end Behavioral;