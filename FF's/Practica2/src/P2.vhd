    LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY P2 IS
	PORT (CLKOUT,PRE,CLR,S,R,T,D,J,K : IN STD_LOGIC;
		SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Q,NQ : INOUT STD_LOGIC
	);
END ENTITY;
ARCHITECTURE A_P2 OF P2 IS
BEGIN
	PROCESS (CLKOUT,PRE,CLR,S,R,T,D,J,K,SEL)
	BEGIN
		IF (CLR = '0') THEN
			Q <= '0';
			NQ <= '1';
		ELSIF RISING_EDGE (CLKOUT) THEN
			IF (PRE = '1') THEN
			Q <= '1';
			NQ <= '0';
			ELSE
				CASE SEL IS
					WHEN "00" => Q <= D;
						NQ <= NOT D;
					WHEN "01" => Q <= ((NOT K) AND Q)OR(J AND (NOT Q));
						NQ <= NOT(((NOT K) AND Q)OR(J AND (NOT Q)));
					WHEN "10" =>
                        IF(S = '1' AND R = '1') THEN
                        Q <= '1';
                        NQ <= '1';
                        ELSE
                        Q<= (S OR ((NOT R) AND Q));
						NQ <= NOT(S OR ((NOT R) AND Q));
                        END IF;
					WHEN OTHERS => Q <= T XOR Q;
						NQ <= NOT(T XOR Q);
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END A_P2;