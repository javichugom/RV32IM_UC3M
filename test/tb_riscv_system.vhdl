library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_riscv_system is
end tb_riscv_system;

architecture sim of tb_riscv_system is
    constant CLK_PERIOD : time := 10 ns;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';
begin
    dut : entity work.RISCV_System
        generic map (INIT_FILE => "test/memory_content/main.mem")
        port map (rst => rst, clk => clk);

    clk <= not clk after CLK_PERIOD/2;

    stim : process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';
        
        for i in 0 to 100
        loop
            wait until rising_edge(clk);
        end loop;

        std.env.finish;
    end process;
end sim;
