LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Main IS
  PORT(
    D_in, J, K, S, R, T_in : IN STD_LOGIC;
    
    CLK, PRE, CLR : IN STD_LOGIC; 
    
    SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    
    LEDs: OUT STD_LOGIC_VECTOR(13 downto 0);

    
    Q_out,NotQ : OUT STD_LOGIC
  );
END ENTITY Main;

ARCHITECTURE Comportamiento OF Main IS

  SIGNAL CONTADOR : STD_LOGIC_VECTOR(24 DOWNTO 0) := (OTHERS => '0');
  CONSTANT DIVISOR: INTEGER := 13500000;
  SIGNAL clk_lento: STD_LOGIC := '0';

  SIGNAL q_d_int  : STD_LOGIC := '0';
  SIGNAL q_jk_int : STD_LOGIC := '0';
  SIGNAL q_sr_int : STD_LOGIC := '0';
  SIGNAL q_t_int  : STD_LOGIC := '0';

BEGIN

  LEDs <=(OTHERS => '0');
  PROCESS(CLK)
  BEGIN
    IF RISING_EDGE(CLK) THEN 
      IF (CONTADOR = DIVISOR) THEN
        CONTADOR <= (OTHERS => '0');
        clk_lento <= NOT clk_lento;
      ELSE
        CONTADOR <= CONTADOR + 1;
      END IF;
    END IF;
  END PROCESS;

  -- Flip-Flop D
  PROCESS(clk_lento, PRE, CLR)
  BEGIN
    IF (CLR = '1') THEN
      q_d_int <= '0';
    ELSIF (PRE = '1') THEN
      q_d_int <= '1';
    ELSIF RISING_EDGE(clk_lento) THEN
      q_d_int <= D_in;
    END IF;
  END PROCESS;

  -- Flip-Flop JK
  PROCESS(clk_lento, PRE, CLR)
  BEGIN
    IF (CLR = '1') THEN
      q_jk_int <= '0';
    ELSIF (PRE = '1') THEN
      q_jk_int <= '1';
    ELSIF RISING_EDGE(clk_lento) THEN
      q_jk_int <= (q_jk_int AND NOT K) OR (J AND NOT q_jk_int);
    END IF;
  END PROCESS;

  -- Flip-Flop SR
  PROCESS(clk_lento, PRE, CLR)
  BEGIN
    IF (CLR = '1') THEN
      q_sr_int <= '0';
    ELSIF (PRE = '1') THEN
      q_sr_int <= '1';
    ELSIF RISING_EDGE(clk_lento) THEN
      q_sr_int <= S OR (q_sr_int AND NOT R); 
    END IF;
  END PROCESS;

  -- Flip-Flop T
  PROCESS(clk_lento, PRE, CLR)
  BEGIN
    IF (CLR = '1') THEN
      q_t_int <= '0';

    ELSIF (PRE = '1') THEN
      q_t_int <= '1';
    ELSIF RISING_EDGE(clk_lento) THEN
      q_t_int <= (q_t_int AND NOT T_in) OR (T_in AND NOT q_t_int);
    END IF;
  END PROCESS;

  -- Multiplexor 4 a 1
  PROCESS(SEL, q_d_int, q_jk_int, q_sr_int, q_t_int, S, R)
  BEGIN
   CASE SEL IS
      WHEN "00" => 
        Q_out <= q_d_int;
        NotQ  <= NOT q_d_int;
        
      WHEN "01" => 
        Q_out <= q_jk_int;
        NotQ  <= NOT q_jk_int;
        
      WHEN "10" => 
        Q_out <= q_sr_int;
        IF (S = '1' AND R = '1') THEN
          NotQ <= q_sr_int;
        ELSE
          NotQ <= NOT q_sr_int;
        END IF;
        
      WHEN OTHERS => 
        Q_out <= q_t_int;
        NotQ  <= NOT q_t_int;
  END CASE;
  END PROCESS;

END ARCHITECTURE Comportamiento;