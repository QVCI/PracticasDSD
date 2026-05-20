LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HOLA IS PORT
(
    CLK: IN STD_LOGIC;
    CLR: IN STD_LOGIC;
    DISPLAY:  OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE A_HOLA OF HOLA IS TYPE ESTADOS IS (S0, S1, S2, S3);
    SIGNAL EDO_PRE, EDO_FUT:ESTADOS;
    
    CONSTANT H: STD_LOGIC_VECTOR(6 DOWNTO 0):="0110111";
    CONSTANT O: STD_LOGIC_VECTOR(6 DOWNTO 0):="1111110";
    CONSTANT L: STD_LOGIC_VECTOR(6 DOWNTO 0):="0001110";
    CONSTANT A: STD_LOGIC_VECTOR(6 DOWNTO 0):="1110111";

    BEGIN DE: PROCESS(EDO_PRE)
        BEGIN
            CASE EDO_PRE IS
                WHEN S0 => DISPLAY <= H;
                           EDO_FUT <= S1; 

                WHEN S1 => DISPLAY <= O;
                           EDO_FUT <= S2; 

                WHEN S2 => DISPLAY <= L;
                           EDO_FUT <= S3; 

                WHEN S3 => DISPLAY <= A;
                           EDO_FUT <= S0;
            END CASE;
    END PROCESS DE;

    PROCESS (CLK, CLR)
        BEGIN
            IF (CLR = '0') THEN
                EDO_PRE<= S0;
            ELSIF RISING_EDGE(CLK) THEN
                EDO_PRE<= EDO_FUT;
            END IF;
      
    END PROCESS;
END A_HOLA;

