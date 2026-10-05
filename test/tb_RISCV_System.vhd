library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_riscv_system is
end tb_riscv_system;

architecture sim of tb_riscv_system is

  constant CLK_PERIOD : time := 10 ns;
  constant NOP        : std_logic_vector(31 downto 0) := x"00000013";

  signal clk  : std_logic := '0';
  signal rst  : std_logic := '1';
  signal done : boolean   := false;

  -- Palabra i de main.mem: addi x(i+1), x0, i+1  (i = 0..30), i=31: jal x0,0
  function rom_word(i : integer) return std_logic_vector is
    variable v : unsigned(31 downto 0);
  begin
    if i >= 0 and i <= 30 then
      v := shift_left(to_unsigned(i + 1, 32), 20) or
           shift_left(to_unsigned(i + 1, 32), 7)  or
           unsigned(NOP);
      return std_logic_vector(v);
    elsif i = 31 then
      return x"0000006f";
    else
      return x"00000000";
    end if;
  end function;

begin

  dut : entity work.RISCV_System
    port map (rst => rst, clk => clk);

  clk_proc : process
  begin
    while not done loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  stim : process
    alias addr_inst_s is <<signal .tb_riscv_system.dut.addr_inst : std_logic_vector(31 downto 0)>>;
    alias rdata_inst_s is <<signal .tb_riscv_system.dut.rdata_inst : std_logic_vector(31 downto 0)>>;
    variable err : integer := 0;
  begin
    wait for 3 * CLK_PERIOD;
    wait until rising_edge(clk);
    wait for 1 ns;
    if addr_inst_s /= x"00000000" then
      err := err + 1;
      report "FALLO reset: addr_inst /= 0" severity error;
    end if;

    wait until falling_edge(clk);
    rst <= '0';

    for n in 1 to 40 loop
      wait until rising_edge(clk);
      wait for 1 ns;
      if addr_inst_s /= std_logic_vector(to_unsigned(4 * (n + 1), 32)) then
        err := err + 1;
        report "FALLO ciclo " & integer'image(n) & ": addr_inst no avanza +4" severity error;
      end if;
      if rdata_inst_s /= rom_word(n) then
        err := err + 1;
        report "FALLO ciclo " & integer'image(n) & ": rdata_inst incorrecta" severity error;
      end if;
    end loop;

    if err = 0 then
      report "SIMULACION COMPLETADA: TODOS LOS TESTS OK" severity note;
    else
      report "SIMULACION COMPLETADA: " & integer'image(err) & " ERRORES" severity error;
    end if;
    done <= true;
    wait;
  end process;

end sim;