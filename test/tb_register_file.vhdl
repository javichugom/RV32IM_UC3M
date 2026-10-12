library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_register_file is
end tb_register_file;

architecture sim of tb_register_file is
    constant N : integer := 32;
    constant NUM_REGISTERS : integer := 32;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wd       : std_logic_vector(N-1 downto 0) := (others => '0');
    signal rd       : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_write : std_logic := '0';
    signal rs1      : std_logic_vector(4 downto 0) := (others => '0');
    signal rs2      : std_logic_vector(4 downto 0) := (others => '0');
    signal rd1      : std_logic_vector(N-1 downto 0);
    signal rd2      : std_logic_vector(N-1 downto 0);
begin

    dut: entity work.register_file
        generic map (
            NUM_REGISTERS => NUM_REGISTERS,
            WIDTH => N
        )
        port map (
            clk      => clk,
            rst      => rst,
            wd       => wd,
            rd       => rd,
            reg_write => reg_write,
            rs1      => rs1,
            rd1      => rd1,
            rs2      => rs2,
            rd2      => rd2
        );

    clk <= not clk after 5 ns;

    registro_32_tb : process
        variable esperado : STD_LOGIC_vector (N-1 downto 0);
    begin
        rst <= '1';
        reg_write <= '0';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        rs1 <= "00000";
        wait for 1 ns;

        assert rd1 = x"00000000"
            report "ERROR: x0 no es 0 tras reset"
            severity error;

        reg_write <= '1';

        for i in 1 to 31 loop
            rd <= std_logic_vector(to_unsigned(i,5));
            wd <= std_logic_vector(to_unsigned(i + 16#100#, N));
            wait for 1 ns;
            wait until rising_edge(clk);
        end loop;

        reg_write <= '0';

        for i in 1 to 31 loop
            rs1 <= std_logic_vector(to_unsigned(i,5));
            esperado := std_logic_vector(to_unsigned(i + 16#100#, N));
            wait for 1 ns;

            assert rd1 = esperado
            report "ERROR: Lectura rs1 incorrecta en registro " & integer'image(i)
            severity error;

            wait for 10 ns;
        end loop;

        for i in 1 to 31 loop
            rs2 <= std_logic_vector(to_unsigned(i,5));
            esperado := std_logic_vector(to_unsigned(i + 16#100#, N));
            wait for 1 ns;

            assert rd2 = esperado
                report "ERROR: Lectura rs2 incorrecta en registro " & integer'image(i)
                severity error;

            wait for 10 ns;
        end loop;

        reg_write <= '1';
        rd <= "00000";
        wd <= x"FFFFFFFF";

        wait until rising_edge(clk);
        reg_write <= '0';

        rs1 <= "00000";
        wait for 1 ns;

        assert rd1 = x"00000000"
            report "ERROR: x0 ha sido modificado"
            severity error;

        rs1 <= std_logic_vector(to_unsigned(5,5));
        wait for 1 ns;
        esperado := rd1;

        rd <= std_logic_vector(to_unsigned(5,5));
        wd <= x"AAAAAAAA";
        reg_write <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd1 = esperado
            report "ERROR: Se ha escrito cuando regWrite = 0"
            severity error;

        report "TEST OK";
        std.env.finish;
    end process;

end sim;
