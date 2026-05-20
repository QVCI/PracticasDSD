LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Top_Reg IS PORT(
    CLK, CLR    : IN STD_LOGIC;
    SICD, SICI  : IN STD_LOGIC;
    CON         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    P           : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    Q           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    LED         : OUT STD_LOGIC;
    LEDAPAGADO  : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)  -- agregado aquí
);
END ENTITY;

ARCHITECTURE A_Top OF Top_Reg IS

    COMPONENT Reg IS PORT(
        CLK, CLR, SICD, SICI : IN STD_LOGIC;
        CON : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        P   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Q   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT DIV PORT(
        CLK        : IN  STD_LOGIC;
        CLKOUT     : OUT STD_LOGIC;
        LED        : OUT STD_LOGIC;
        LEDAPAGADO : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL Q_int   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL CLK_DIV : STD_LOGIC;

BEGIN

    U_DIV: DIV PORT MAP(
        CLK        => CLK,
        CLKOUT     => CLK_DIV,
        LED        => LED,
        LEDAPAGADO => LEDAPAGADO  -- ahora sí conectado
    );

    U1: Reg PORT MAP(
        CLK  => CLK_DIV,
        CLR  => CLR,
        SICD => SICD,
        SICI => SICI,
        CON  => CON,
        P    => P,
        Q    => Q_int
    );

    Q <= Q_int;

END A_Top;