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

    -- Divisor de frecuencia (27 MHz -> velocidad visible)
    component DIV
        port (
            CLK        : in  std_logic;
            CLR        : in  std_logic;
            CLKOUT     : out std_logic;
            LED        : out std_logic;
            LEDAPAGADO : out std_logic_vector(5 downto 0)
        );
    end component;

    signal clk_lento  : std_logic;
    signal dummy_led  : std_logic;
    signal dummy_leds : std_logic_vector(5 downto 0);

    -- Estado del gusano
    -- filled : cuantos bits ya estan pegados en el MSB (0..8)
    -- pos    : posicion del bit que se esta desplazando (0..7)
    -- started: '0' = en reposo (Q=00000000), '1' = gusano activo
    signal filled  : integer range 0 to 8 := 0;
    signal pos     : integer range 0 to 7 := 0;
    signal started : std_logic := '0';

    signal q_int : std_logic_vector(7 downto 0);

begin

    u_div: DIV port map (
        CLK        => CLK,
        CLR        => CLR,
        CLKOUT     => clk_lento,
        LED        => dummy_led,
        LEDAPAGADO => dummy_leds
    );

    -- -------------------------------------------------------
    -- Maquina de estados del gusano
    --
    -- Patron (8 bits, igual que el ejemplo de 3 bits):
    --   00000001 -> 00000010 -> ... -> 10000000 ->
    --   10000001 -> 10000010 -> ... -> 11000000 ->
    --   ...
    --   11111110 -> 11111111  (Y='1')
    --
    -- Regla: el bit de desplazamiento avanza de LSB hacia MSB.
    -- Al llegar al limite de la zona "pegada" queda fijo ahi
    -- y un nuevo bit entra por LSB.
    -- -------------------------------------------------------
    process(clk_lento, CLR)
    begin
        if CLR = '1' then
            filled  <= 0;
            pos     <= 0;
            started <= '0';
        elsif rising_edge(clk_lento) then
            if CON = '0' then                      -- habilitado (activo bajo)
                if started = '0' then
                    -- Primera habilitacion: arrancar el gusano
                    started <= '1';
                    pos     <= 0;
                    filled  <= 0;
                elsif filled = 8 then
                    -- Todos los bits llenos -> reiniciar
                    started <= '0';
                    filled  <= 0;
                    pos     <= 0;
                elsif pos = (7 - filled) then
                    -- El bit llegó al borde de la zona pegada -> pegarlo
                    filled <= filled + 1;
                    pos    <= 0;
                else
                    -- Desplazar el bit un lugar hacia el MSB
                    pos <= pos + 1;
                end if;
            end if;
        end if;
    end process;

    -- -------------------------------------------------------
    -- Generacion de la salida Q
    -- -------------------------------------------------------
    process(started, filled, pos)
        variable tmp : std_logic_vector(7 downto 0);
    begin
        tmp := (others => '0');
        if started = '1' then
            if filled = 8 then
                -- Todos los bits llenos
                tmp := (others => '1');
            else
                -- Bits pegados en el lado MSB
                for i in 0 to 7 loop
                    if i >= (8 - filled) then
                        tmp(i) := '1';
                    end if;
                end loop;
                -- Bit en desplazamiento
                tmp(pos) := '1';
            end if;
        end if;
        q_int <= tmp;
    end process;

    Q <= q_int;
    Y <= '1' when (q_int = "11111111" and CON = '0') else '0';

end ACONTADORP5;