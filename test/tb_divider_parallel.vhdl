library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_divider_parallel is
end tb_divider_parallel;

architecture sim of tb_divider_parallel is
    constant T_CLK : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';

    signal dividend : std_logic_vector(31 downto 0) := (others => '0');
    signal divider   : std_logic_vector(31 downto 0) := (others => '0');

    signal ready  : std_logic;
    signal valid  : std_logic := '0';
    signal done   : std_logic;

    signal quotient : std_logic_vector(31 downto 0);
    signal remainder : std_logic_vector(31 downto 0);

    procedure tick is
    begin
        wait for 1 ns;
    end procedure;
begin
    -- Instancia del divisor
    dut: entity work.divider(parallel)
        port map (
            clk        => clk,
            rst        => rst,
            dividend   => dividend,
            divider    => divider,
            valid      => valid,
            ready      => ready,
            done       => done,
            quotient   => quotient,
            remainder  => remainder
        );

    -- La arquitectura paralela debe funcionar sin reloj
    clk <= '0';

    process
    begin
        tick;
        assert ready report "Error: ready nivel bajo en arquitectura paralela." &
            "Siempre debe estar a nivel alto";
    end process;

    p_test : process
    begin
        -- RESET
        rst <= '1';
        wait for 2*T_CLK;
        rst <= '0';


        ------------------------------------------------
        -- PRUEBA 1: 20 / 3 = 6 resto 2
        ------------------------------------------------
        report "PRUEBA 1: 20 / 3 = 6 resto 2";
        dividend <= std_logic_vector(to_unsigned(20, 32));
        divider  <= std_logic_vector(to_unsigned(3, 32));

        valid <= '1';
        tick;

        assert done report "Error: done a nivel bajo cuando el calculo ha finalizado";

        assert unsigned(quotient) = 6
            report "ERROR: Cociente incorrecto en prueba 1"
            severity error;

        assert unsigned(remainder) = 2
            report "ERROR: Resto incorrecto en prueba 1"
            severity error;

        report "PRUEBA 1 FINALIZADA" severity note;


        ------------------------------------------------
        -- PRUEBA 2: 100 / 7 = 14 resto 2
        ------------------------------------------------
        tick;
        report "PRUEBA 2: 100 / 7 = 14 resto 2";

        dividend <= std_logic_vector(to_unsigned(100, 32));
        divider  <= std_logic_vector(to_unsigned(7, 32));

        valid <= '1';
        tick;

        assert done report "Error: done a nivel bajo cuando el calculo ha finalizado";

        assert unsigned(quotient) = 14
            report "ERROR: Cociente incorrecto en prueba 2"
            severity error;

        assert unsigned(remainder) = 2
            report "ERROR: Resto incorrecto en prueba 2"
            severity error;

        report "PRUEBA 2 FINALIZADA" severity note;


        tick;
        valid <= '0';
        tick;
        assert not done report "Error: done a nivel alto sin calculo realizado";
        ------------------------------------------------
        -- PRUEBA 3: 255 / 10 = 25 resto 5
        ------------------------------------------------
        tick;
        report "PRUEBA 3: 255 / 10 = 25 resto 5";

        dividend <= std_logic_vector(to_unsigned(255, 32));
        divider  <= std_logic_vector(to_unsigned(10, 32));

        valid <= '1';
        tick;

        assert done report "Error: done a nivel bajo cuando el calculo ha finalizado";

        assert unsigned(quotient) = 25
            report "ERROR: Cociente incorrecto en prueba 3"
            severity error;

        assert unsigned(remainder) = 5
            report "ERROR: Resto incorrecto en prueba 3"
            severity error;

        report "PRUEBA 3 FINALIZADA" severity note;


        ------------------------------------------------
        -- FIN DE SIMULACION
        ------------------------------------------------

        report "TODAS LAS PRUEBAS FINALIZADAS"
            severity note;

        std.env.finish;
    end process;
end sim;
