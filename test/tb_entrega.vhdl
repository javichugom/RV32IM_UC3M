library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instructions.all;
use work.definitions.all;

entity tb_entrega is
end tb_entrega;

architecture sim of tb_entrega is
    constant CLK_PERIOD : time := 10 ns;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';

begin
    dut : entity work.RISCV_System
        generic map (
            INIT_FILE => "test/memory_content/entrega.hex"
        )
        port map (rst => rst, clk => clk);

    clk <= not clk after CLK_PERIOD/2;

    stim : process
        alias instruction is
            << signal dut.u_core.u_dec_exe.instruction : word>>;
        alias registers is
            << signal dut.u_core.u_dec_exe.rf_inst.registers : registers_t(31 downto 0)>>;

    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        wait until instruction = x"0000006F" for 1000 * CLK_PERIOD;

        -- Al utilizar la fase de writeback para escribir cualquier resultado al banco de registros
        -- es necesario un ciclo de reloj para que se guarde el resultado en su posición
        wait until rising_edge(clk);
        -- La espera es necesaria para que las señales adquiran los datos actualizados
        wait for 5 ns;

        for i in 21 to 28
        loop
            report "x" & to_string(i) & " = " & to_hstring(registers(i));
        end loop;
        std.env.finish;
    end process;
end sim;
