LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Top_Reg IS PORT(
    CLK         : IN STD_LOGIC;
    CLR         : IN STD_LOGIC;
    LED         : OUT STD_LOGIC;
    DISPLAY     : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    LEDAPAGADO  : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE A_Top OF Top_Reg IS

    COMPONENT HOLA
    PORT 
    (
        CLK, CLR: IN STD_LOGIC;
        DISPLAY:  OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
    END COMPONENT;
    COMPONENT DIV PORT
    (
        CLK:    IN  STD_LOGIC;
        CLKOUT: OUT STD_LOGIC;
        LED    : OUT STD_LOGIC;
        LEDAPAGADO : OUT STD_LOGIC_VECTOR(5 downto 0)
    );
    END COMPONENT;



    SIGNAL CLK_DIV : STD_LOGIC;

BEGIN

    U_DIV: DIV PORT MAP(
        CLK        => CLK,
        CLKOUT     => CLK_DIV,
        LED        => LED,
        LEDAPAGADO => LEDAPAGADO  -- ahora sí conectado
    );

    U1: HOLA PORT MAP(
        CLK  => CLK_DIV,
        CLR  => CLR,
        DISPLAY => DISPLAY
    );

END A_Top;