library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instructions.all;
use work.definitions.all;

entity tb_riscv_isa is
end tb_riscv_isa;

architecture sim of tb_riscv_isa is
    constant CLK_PERIOD : time := 10 ns;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';

begin
    dut : entity work.RISCV_System
        generic map (
            INIT_FILE => "test/memory_content/isa/simple.hex"
        )
        port map (rst => rst, clk => clk);

    clk <= not clk after CLK_PERIOD/2;

    stim : process
        alias instruction is
            << signal dut.u_core.u_dec_exe.dec_inst.instruction : instruction_t >>;
        alias registers is
            << signal dut.u_core.u_dec_exe.rf_inst.registers : registers_t(31 downto 0)>>;

        constant a7 : natural := 17;
        constant a0 : natural := 10;

        constant END_TEST_SYSCALL : word := std_logic_vector(to_unsigned(93, word'length));

        variable failed_test : integer;
    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        wait until instruction = ecall for 1000 * CLK_PERIOD;
        assert instruction = ecall report "Test timeout" severity failure;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert registers(a7) = END_TEST_SYSCALL report "Incorrect call of ecall" severity failure; 
        failed_test := to_integer(shift_right(unsigned(registers(a0)), 1));
        assert unsigned(registers(a0)) = 0
            report "Test finished with errors (Test " &
                to_string(failed_test) & ")"
            severity failure; 
        std.env.finish;
    end process;
end sim;
