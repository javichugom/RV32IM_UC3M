library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_riscv_fetch is
end tb_riscv_fetch;

architecture sim of tb_riscv_fetch is

  constant CLK_PERIOD : time := 10 ns;
  constant NOP        : std_logic_vector(31 downto 0) := x"00000013";

  signal clk         : std_logic := '0';
  signal rst         : std_logic := '0';
  signal stall       : std_logic := '0';
  signal addr_inst   : std_logic_vector(31 downto 0);
  signal wdata_inst  : std_logic_vector(31 downto 0);
  signal rdata_inst  : std_logic_vector(31 downto 0);
  signal we_inst     : std_logic;
  signal be_inst     : std_logic_vector(3 downto 0);
  signal branch_e    : std_logic := '0';
  signal branch_addr : std_logic_vector(31 downto 0) := (others => '0');
  signal instruction : std_logic_vector(31 downto 0);

  signal done : boolean := false;

  -- Palabra i de la ROM: addi x(i+1), x0, i+1  (igual que main.mem)
  -- El inmediato identifica la posicion: idx = imm - 1. El NOP da idx = -1.
  function rom_word(i : integer) return std_logic_vector is
    variable v : unsigned(31 downto 0);
  begin
    if i >= 0 and i <= 30 then
      v := shift_left(to_unsigned(i + 1, 32), 20) or
           shift_left(to_unsigned(i + 1, 32), 7)  or
           unsigned(NOP);
      return std_logic_vector(v);
    else
      return NOP;
    end if;
  end function;

  function idx_of(w : std_logic_vector(31 downto 0)) return integer is
  begin
    if is_x(w) then
      return -2;
    end if;
    return to_integer(unsigned(w(31 downto 20))) - 1;
  end function;

  function to_hex(v : std_logic_vector) return string is
    constant HEXCH : string(1 to 16) := "0123456789abcdef";
    constant N     : integer := v'length;
    variable vn    : std_logic_vector(N-1 downto 0);
    variable r     : string(1 to N/4);
    variable nib   : std_logic_vector(3 downto 0);
  begin
    vn := v;
    for k in r'range loop
      nib := vn(N - (k-1)*4 - 1 downto N - k*4);
      if is_x(nib) then
        r(k) := 'X';
      else
        r(k) := HEXCH(to_integer(unsigned(nib)) + 1);
      end if;
    end loop;
    return r;
  end function;

begin

  ---------------------------------------------------------------------------
  -- DUT
  ---------------------------------------------------------------------------
  dut : entity work.riscv_fetch
    port map (
      clk         => clk,
      rst         => rst,
      stall       => stall,
      addr_inst   => addr_inst,
      wdata_inst  => wdata_inst,
      rdata_inst  => rdata_inst,
      we_inst     => we_inst,
      be_inst     => be_inst,
      branch_e    => branch_e,
      branch_addr => branch_addr,
      instruction => instruction);

  ---------------------------------------------------------------------------
  -- Reloj
  ---------------------------------------------------------------------------
  clk_proc : process
  begin
    while not done loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  ---------------------------------------------------------------------------
  -- Modelo de memoria de instrucciones: lectura sincrona, latencia 1 ciclo
  -- (mismo comportamiento que el puerto de lectura de "memory")
  ---------------------------------------------------------------------------
  rom_proc : process(clk)
  begin
    if rising_edge(clk) then
      if is_x(addr_inst(9 downto 2)) then
        rdata_inst <= (others => 'X');
      else
        rdata_inst <= rom_word(to_integer(unsigned(addr_inst(9 downto 2))));
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Estimulos y comprobaciones
  ---------------------------------------------------------------------------
  stim : process
    variable err       : integer := 0;
    variable last      : integer := -1;  -- ultimo idx de instruccion valida vista
    variable prev_pc   : std_logic_vector(31 downto 0);
    variable prev_inst : std_logic_vector(31 downto 0);

    procedure fail(msg : string) is
    begin
      err := err + 1;
      report "FALLO " & msg severity error;
    end procedure;

    -- Un ciclo: se aplican entradas en el flanco de bajada y se espera
    -- al flanco de subida (+1 ns) para ver las salidas ya actualizadas.
    procedure tick(r, s, b : std_logic;
                   ba      : std_logic_vector(31 downto 0) := x"00000000") is
    begin
      wait until falling_edge(clk);
      rst <= r; stall <= s; branch_e <= b; branch_addr <= ba;
      wait until rising_edge(clk);
      wait for 1 ns;
    end procedure;

    procedure check_pc(name : string; exp : integer) is
      constant e : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(exp, 32));
    begin
      if addr_inst /= e then
        fail(name & ": pc=" & to_hex(addr_inst) & " esperado=" & to_hex(e));
      end if;
    end procedure;

    procedure check_inst(name : string; exp : std_logic_vector(31 downto 0)) is
    begin
      if instruction /= exp then
        fail(name & ": instruction=" & to_hex(instruction) & " esperado=" & to_hex(exp));
      end if;
    end procedure;

    -- Comprueba que las instrucciones validas salen en orden, sin repetir ni saltarse ninguna.
    procedure observe(name : string) is
      variable i : integer;
    begin
      i := idx_of(instruction);
      if i = -2 then
        fail(name & ": instruction con X");
      elsif i = -1 then
        null;  -- NOP
      else
        if i /= last + 1 then
          fail(name & ": sale la instruccion " & integer'image(i) &
               ", esperada " & integer'image(last + 1));
        end if;
        if i > last then
          last := i;  -- resincroniza solo hacia delante
        end if;
      end if;
    end procedure;

  begin
    wait for 2 * CLK_PERIOD;

    -------------------------------------------------------------------------
    report "TEST 1: reset" severity note;
    -------------------------------------------------------------------------
    tick('1', '0', '0');
    tick('1', '0', '0');
    tick('1', '0', '0');
    check_pc("reset", 0);
    check_inst("reset", NOP);
    if we_inst /= '0' then fail("we_inst deberia ser 0"); end if;
    if be_inst /= "1111" then fail("be_inst deberia ser 1111"); end if;

    -------------------------------------------------------------------------
    report "TEST 2: fetch secuencial (pc += 4, instrucciones en orden)" severity note;
    -------------------------------------------------------------------------
    last := -1;
    for n in 1 to 10 loop
      tick('0', '0', '0');
      check_pc("seq", 4 * n);
      observe("seq");
    end loop;

    -------------------------------------------------------------------------
    report "TEST 3: stall (pc e instruction congelados, sin perder instrucciones)" severity note;
    -------------------------------------------------------------------------
    prev_pc := addr_inst; prev_inst := instruction;
    for n in 1 to 3 loop
      tick('0', '1', '0');
      if addr_inst /= prev_pc then
        fail("stall: el pc cambia (" & to_hex(addr_inst) & ")");
      end if;
      if instruction /= prev_inst then
        fail("stall: instruction cambia (" & to_hex(instruction) & ")");
      end if;
    end loop;
    for n in 1 to 6 loop
      tick('0', '0', '0');
      observe("tras stall");
    end loop;

    -------------------------------------------------------------------------
    report "TEST 4: salto (pc = destino, NOP, sin instruccion de camino erroneo)" severity note;
    -------------------------------------------------------------------------
    tick('0', '0', '1', x"00000050");          -- destino: palabra 20
    check_pc("branch", 16#50#);
    check_inst("branch (flush)", NOP);
    last := 19;                                -- siguiente valida esperada: idx 20
    for n in 1 to 6 loop
      tick('0', '0', '0');
      check_pc("tras branch", 16#50# + 4 * n);
      observe("tras branch");
    end loop;

    -------------------------------------------------------------------------
    report "TEST 5: reset en mitad de la ejecucion" severity note;
    -------------------------------------------------------------------------
    tick('1', '0', '0');
    check_pc("reset 2", 0);
    check_inst("reset 2", NOP);
    last := -1;
    for n in 1 to 6 loop
      tick('0', '0', '0');
      check_pc("tras reset 2", 4 * n);
      observe("tras reset 2");
    end loop;

    -------------------------------------------------------------------------
    wait for 5 * CLK_PERIOD;
    if err = 0 then
      report "SIMULACION COMPLETADA: TODOS LOS TESTS OK" severity note;
    else
      report "SIMULACION COMPLETADA: " & integer'image(err) & " ERRORES" severity error;
    end if;
    done <= true;
    wait;
  end process;

end sim;