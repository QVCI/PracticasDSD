library ieee;
use ieee.std_logic_1164.all;

entity CONTADORP5 is
    port (
        CLK : in  std_logic;
        CLR : in  std_logic;
        CON : in  std_logic;
        Q   : out std_logic_vector(7 downto 0);
        Y   : out std_logic
    );
end CONTADORP5;

architecture ACONTADORP5 of CONTADORP5 is
    component JKFF
        port (
            CLK, CLR, J, K : in std_logic;
            Q : out std_logic
        );
    end component;

    -- Divider component
    component DIV
        port (
            CLK  : in std_logic;
            CLR  : in std_logic;
            CLKOUT : out std_logic;
            LED    : out std_logic;
            LEDAPAGADO : out std_logic_vector(5 downto 0)
        );
    end component;

    signal q_int     : std_logic_vector(7 downto 0) := (others => '0');
    signal enable    : std_logic_vector(7 downto 0);
    signal clk_lento : std_logic;
    signal dummy_led : std_logic;
    signal dummy_leds: std_logic_vector(5 downto 0);
begin
    -- Divisor de frecuencia (27 MHz → velocidad visible)
    u_div: DIV port map (
        CLK  => CLK,
        CLR  => CLR,
        CLKOUT => clk_lento,
        LED    => dummy_led,
        LEDAPAGADO => dummy_leds
    );

    -- TU LÓGICA ORIGINAL (sin cambios)
    enable(0) <= not CON;
    enable(1) <= q_int(0) and enable(0);
    enable(2) <= q_int(1) and enable(1);
    enable(3) <= q_int(2) and enable(2);
    enable(4) <= q_int(3) and enable(3);
    enable(5) <= q_int(4) and enable(4);
    enable(6) <= q_int(5) and enable(5);
    enable(7) <= q_int(6) and enable(6);

    gen_ff: for i in 0 to 7 generate
        ff: JKFF port map (
            CLK => clk_lento,  -- <--- SOLO CAMBIA ESTO: usar clk_lento en lugar de CLK
            CLR => CLR,
            J   => enable(i),
            K   => enable(i),
            Q   => q_int(i)
        );
    end generate;

    Q <= q_int;
    Y <= '1' when (q_int = "11111111" and CON = '0') else '0';
end ACONTADORP5;