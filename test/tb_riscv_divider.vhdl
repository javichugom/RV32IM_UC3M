library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.all;

entity tb_riscv_divider is
end tb_riscv_divider;

architecture sim of tb_riscv_divider is
    constant T_CLK : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';

    signal dividend  : word := (others => '0');
    signal divider   : word := (others => '0');
    signal operation_sign : operation_sign_t;

    signal ready  : std_logic;
    signal valid  : std_logic := '0';
    signal done   : std_logic;

    signal quotient  : word;
    signal remainder : word;

    procedure tick is
    begin
        wait until rising_edge(clk);
        wait for 1 ns;
    end procedure;
begin
    dut: entity work.riscv_divider
     port map(
        clk => clk,
        rst => rst,
        dividend => dividend,
        divider => divider,
        operation_sign => operation_sign,
        valid => valid,
        ready => ready,
        done => done,
        quotient => quotient,
        remainder => remainder
    );

    -- La arquitectura paralela debe funcionar sin reloj
    clk <= not clk after T_CLK / 2;

    p_test : process
        procedure test(
            constant dividend_value   : in integer;
            constant divider_value    : in integer;
            constant operation_sign_value : in operation_sign_t;
            constant expected_quotient : in word;
            constant expected_remainder : in word
        ) is
        begin          
            dividend <= std_logic_vector(to_signed(dividend_value, 32));
            divider  <= std_logic_vector(to_signed(divider_value, 32));
            operation_sign <= operation_sign_value;

            if not ready
            then
                wait until ready;
            end if;
            valid <= '1';
            tick;
            valid <= '0';
            if not done
            then
                wait until done;
                wait for 1 ns;
            end if;


            assert done report "Error: done a nivel bajo cuando el calculo ha finalizado";
            assert quotient = expected_quotient
                report "ERROR: Cociente incorrecto" & LF
                    & ht & "esperado: " & to_hstring(expected_quotient) & LF
                    & ht & "obtenido: " & to_hstring(quotient)
                severity error;

            assert remainder = expected_remainder
                report "ERROR: Resto incorrecto" & LF
                    & ht & "esperado: " & to_hstring(expected_remainder) & LF
                    & ht & "obtenido: " & to_hstring(remainder)
                severity error;
        end;
    begin
        -- RESET
        rst <= '1';
        wait for 2*T_CLK;
        rst <= '0';


        report "PRUEBA 1: 20 / 3 = 6 resto 2 (signed)";
        test(20, 3, s, word(to_signed(6, 32)), word(to_signed(2, 32)));

        report "PRUEBA 2: -20 / 3 = -6 resto -2 (signed)";
        test(-20, 3, s, word(to_signed(-6, 32)), word(to_signed(-2, 32)));

        report "PRUEBA 3: -20 / -3 = 6 resto -2 (signed)";
        test(-20, -3, s, word(to_signed(6, 32)), word(to_signed(-2, 32)));

        report "PRUEBA 4: 20 / -3 = -6 resto 2 (signed)";
        test(20, -3, s, word(to_signed(-6, 32)), word(to_signed(2, 32)));

        report "PRUEBA 5: 20 / 3 = 6 resto 2 (unsigned)";
        test(20, 3, s, word(to_unsigned(6, 32)), word(to_unsigned(2, 32)));

        report "PRUEBA 6: (-20 = 4294967276)  / 3 = 1431655758 resto 2 (unsigned)";
        test(-20, 3, u, word(to_unsigned(1431655758, 32)), word(to_unsigned(2, 32)));

        report "PRUEBA 7: -2^(31) / -1 = -2^(31) resto 0 (signed)";
        test(-(2**31), -1, s, word(to_signed(-(2**31), 32)), word(to_signed(0, 32)));

        report "PRUEBA 7: (-2^(31) = 2147483648) / (-1 = 4294967295) = " &
            "0 resto 1 (unsigned)";
        test(-(2**31), -1, u, word(to_unsigned(0, 32)), word(unsigned'(x"80000000")));

        report "PRUEBA 8: 20  / 0 = 2^(31)-1 resto 20 (signed)";
        test(20, 0, s, word(to_signed(-1, 32)), word(to_signed(20, 32)));

        report "PRUEBA 9: 20  / 0 = 2^(31)-1 resto 20 (unsigned)";
        test(20, 0, u, word(unsigned'(x"FFFFFFFF")), word(to_unsigned(20, 32)));

        ------------------------------------------------
        -- FIN DE SIMULACION
        ------------------------------------------------
        report "TODAS LAS PRUEBAS FINALIZADAS"
            severity note;

        std.env.finish;
    end process;
end sim;
