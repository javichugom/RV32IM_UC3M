library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_divider_serial is
end tb_divider_serial;

architecture sim of tb_divider_serial is
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
        wait until rising_edge(clk);
        wait for 1 ns;
    end procedure;
begin
    -- Instancia del divisor
    dut: entity work.divider(serial)
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

    clk <= not clk after T_CLK / 2;

    p_test : process
    begin
        -- RESET
        rst <= '1';
        tick;
        tick;
        rst <= '0';

        tick;

        ------------------------------------------------
        -- PRUEBA 1: 20 / 3 = 6 resto 2
        ------------------------------------------------
        report "PRUEBA 1: 20 / 3 = 6 resto 2";
        dividend <= std_logic_vector(to_unsigned(20, 32));
        divider  <= std_logic_vector(to_unsigned(3, 32));

        if not ready
        then
            wait until ready;
        end if;
        valid <= '1';
        tick;

        for i in 0 to 31
        loop
            assert not ready report "ERROR: ready a nivel alto mientras realiza operacion";
            assert not done report "ERROR: done a nivel alto sin ejecucion finalizada";
            tick;
        end loop;

        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";
        assert done report "Error: done a nivel bajo cuando la operacion debe haber terminado";
        assert unsigned(quotient) = 6
            report "ERROR: Cociente incorrecto en prueba 1"
            severity error;

        assert unsigned(remainder) = 2
            report "ERROR: Resto incorrecto en prueba 1"
            severity error;

        report "PRUEBA 1 Finalizada" severity note;

        ------------------------------------------------
        -- PRUEBA 2: 100 / 7 = 14 resto 2
        ------------------------------------------------
        report "PRUEBA 2: 100 / 7 = 14 resto 2.";

        dividend <= std_logic_vector(to_unsigned(100, 32));
        divider  <= std_logic_vector(to_unsigned(7, 32));

        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";

        tick;
        valid <= '0';

        for i in 0 to 31
        loop
            assert not ready report "ERROR: ready a nivel alto mientras realiza operacion";
            assert not done report "ERROR: done a nivel alto sin ejecucion finalizada";
            tick;
        end loop;

        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";
        assert done report "Error: done a nivel bajo cuando la operacion debe haber terminado";
        assert unsigned(quotient) = 14
            report "ERROR: Cociente incorrecto en prueba 2"
            severity error;

        assert unsigned(remainder) = 2
            report "ERROR: Resto incorrecto en prueba 2"
            severity error;

        tick;
        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";
        assert done report "Error: done a nivel bajo cuando la operacion debe haber terminado." &
            " No mantiene valor cuando no se realiza una operacion";
        assert unsigned(quotient) = 14
            report "ERROR: Cociente incorrecto en prueba 2." &
                " No mantiene valor cuando no se realiza una operacion"
            severity error;

        assert unsigned(remainder) = 2
            report "ERROR: Resto incorrecto en prueba 2" &
                " No mantiene valor cuando no se realiza una operacion"
            severity error;
        

        report "PRUEBA 2 Finalizada" severity note;


        ------------------------------------------------
        -- PRUEBA 3: 255 / 10 = 25 resto 5
        ------------------------------------------------
        report "PRUEBA 3: 255 / 10 = 25 resto 5. Pipeline vacio";

        dividend <= std_logic_vector(to_unsigned(255, 32));
        divider  <= std_logic_vector(to_unsigned(10, 32));

        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";
        valid <= '1';
        tick;
        valid <= '0';

        for i in 0 to 31
        loop
            assert not ready report "ERROR: ready a nivel alto mientras realiza operacion";
            assert not done report "ERROR: done a nivel alto sin ejecucion finalizada";
            tick;
        end loop;


        assert ready report "ERROR: ready a nivel bajo bajo cuando no realiza operación";
        assert done report "Error: done a nivel bajo cuando la operacion debe haber terminado";
        assert unsigned(quotient) = 25
            report "ERROR: Cociente incorrecto en prueba 3"
            severity error;

        assert unsigned(remainder) = 5
            report "ERROR: Resto incorrecto en prueba 3"
            severity error;

        report "PRUEBA 3 Finalizada" severity note;


        ------------------------------------------------
        -- FIN DE SIMULACION
        ------------------------------------------------

        report "TODAS LAS PRUEBAS FINALIZADAS"
            severity note;

        std.env.finish;
    end process;

end sim;
