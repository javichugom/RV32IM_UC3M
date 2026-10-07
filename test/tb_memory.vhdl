library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_memory is
end tb_memory;

architecture sim of tb_memory is

  constant MEM_WIDTH      : integer := 32;
  constant NUM_BYTES      : integer := 4;
  constant RAM_ADDR_WIDTH : integer := 10;
  constant CLK_PERIOD     : time    := 10 ns;

  signal clk     : std_logic := '0';
  signal addr_a  : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal wdata_a : std_logic_vector(MEM_WIDTH-1 downto 0)      := (others => '0');
  signal rdata_a : std_logic_vector(MEM_WIDTH-1 downto 0);
  signal we_a    : std_logic := '0';
  signal be_a    : std_logic_vector(3 downto 0) := (others => '0');

  signal addr_b  : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal wdata_b : std_logic_vector(MEM_WIDTH-1 downto 0)      := (others => '0');
  signal rdata_b : std_logic_vector(MEM_WIDTH-1 downto 0);
  signal we_b    : std_logic := '0';
  signal be_b    : std_logic_vector(NUM_BYTES-1 downto 0) := (others => '0');

  signal errors  : integer := 0;
  signal done    : boolean := false;

  function expected_init(i : integer) return std_logic_vector is
    variable v : unsigned(31 downto 0);
  begin
    if i <= 30 then
      v := to_unsigned(i + 1, 32) sll 20;
      v := v or (to_unsigned(i + 1, 32) sll 7);
      v := v or x"00000013";
      return std_logic_vector(v);
    elsif i = 31 then
      return x"0000006f";
    else
      return x"00000000";
    end if;
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


  dut : entity work.memory(rtl)
    generic map (
      MEM_WIDTH      => MEM_WIDTH,
      NUM_BYTES      => NUM_BYTES,
      RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
      INIT_FILE      => "test/memory_content/main.mem")
    port map (
      clk => clk,
      addr_a => addr_a, wdata_a => wdata_a, rdata_a => rdata_a,
      we_a => we_a, be_a => be_a,
      addr_b => addr_b, wdata_b => wdata_b, rdata_b => rdata_b,
      we_b => we_b, be_b => be_b);


  clk_proc : process
  begin
    while not done loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;


  stim : process

    procedure check(name : string;
                    got  : std_logic_vector;
                    exp  : std_logic_vector) is
    begin
      if got /= exp then
        errors <= errors + 1;
        report "FALLO " & name & ": obtenido=" & to_hex(got) &
               " esperado=" & to_hex(exp) severity error;
      else
        report "OK    " & name & " = " & to_hex(got) severity note;
      end if;
    end procedure;

    function a(i : integer) return std_logic_vector is
    begin
      return std_logic_vector(to_unsigned(i, RAM_ADDR_WIDTH));
    end function;

    procedure read_ab(ia, ib : integer) is
    begin
      wait until falling_edge(clk);
      addr_a <= a(ia); we_a <= '0';
      addr_b <= a(ib); we_b <= '0';
      wait until rising_edge(clk);
      wait for 1 ns;
    end procedure;

    procedure write_a(ia : integer; d : std_logic_vector; be : std_logic_vector(3 downto 0)) is
    begin
      wait until falling_edge(clk);
      addr_a <= a(ia); wdata_a <= d; be_a <= be; we_a <= '1';
      wait until rising_edge(clk);
      wait for 1 ns;
      we_a <= '0';
    end procedure;

    procedure write_b(ib : integer; d : std_logic_vector; be : std_logic_vector(3 downto 0)) is
    begin
      wait until falling_edge(clk);
      addr_b <= a(ib); wdata_b <= d; be_b <= be; we_b <= '1';
      wait until rising_edge(clk);
      wait for 1 ns;
      we_b <= '0';
    end procedure;

  begin
    wait for 5 * CLK_PERIOD;

    report "TEST 1: contenido inicial (main.mem) por ambos puertos" severity note;
    for i in 0 to 33 loop
      read_ab(i, 33 - i);
      check("init A[" & integer'image(i) & "]",      rdata_a, expected_init(i));
      check("init B[" & integer'image(33 - i) & "]", rdata_b, expected_init(33 - i));
    end loop;

    report "TEST 2: escritura palabra completa en A, lectura por B" severity note;
    write_a(100, x"DEADBEEF", "1111");
    read_ab(0, 100);
    check("B[100] tras write A", rdata_b, x"DEADBEEF");

    -------------------------------------------------------------------------
    report "TEST 3: escritura palabra completa en B, lectura por A" severity note;
    -------------------------------------------------------------------------
    write_b(101, x"CAFEBABE", "1111");
    read_ab(101, 0);
    check("A[101] tras write B", rdata_a, x"CAFEBABE");

    -------------------------------------------------------------------------
    report "TEST 4: byte enables (puerto A)" severity note;
    -------------------------------------------------------------------------
    write_a(102, x"00000000", "1111");
    write_a(102, x"AABBCCDD", "0101");  -- bytes 0 y 2
    read_ab(102, 102);
    check("A[102] be=0101", rdata_a, x"00BB00DD");
    write_a(102, x"11223344", "1010");  -- bytes 1 y 3
    read_ab(102, 102);
    check("A[102] be=1010", rdata_a, x"11BB33DD");
    write_a(102, x"FFFFFFFF", "0000");  -- sin bytes: no cambia
    read_ab(102, 102);
    check("A[102] be=0000", rdata_a, x"11BB33DD");

    -------------------------------------------------------------------------
    report "TEST 5: byte enables (puerto B)" severity note;
    -------------------------------------------------------------------------
    write_b(103, x"00000000", "1111");
    write_b(103, x"AABBCCDD", "0001");
    read_ab(103, 103);
    check("B[103] be=0001", rdata_b, x"000000DD");
    write_b(103, x"AABBCCDD", "1000");
    read_ab(103, 103);
    check("B[103] be=1000", rdata_b, x"AA0000DD");

    -------------------------------------------------------------------------
    report "TEST 6: escritura simultánea en direcciones distintas" severity note;
    -------------------------------------------------------------------------
    wait until falling_edge(clk);
    addr_a <= a(110); wdata_a <= x"11111111"; be_a <= "1111"; we_a <= '1';
    addr_b <= a(111); wdata_b <= x"22222222"; be_b <= "1111"; we_b <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    we_a <= '0'; we_b <= '0';
    read_ab(110, 111);
    check("A[110] simultánea", rdata_a, x"11111111");
    check("B[111] simultánea", rdata_b, x"22222222");

    -------------------------------------------------------------------------
    report "TEST 7: read-first (lectura devuelve dato anterior en escritura)" severity note;
    -------------------------------------------------------------------------
    write_a(120, x"12345678", "1111");
    wait until falling_edge(clk);
    addr_a <= a(120); wdata_a <= x"87654321"; be_a <= "1111"; we_a <= '1';
    wait until rising_edge(clk);
    wait for 1 ns;
    we_a <= '0';
    check("A[120] read-first (dato viejo)", rdata_a, x"12345678");
    read_ab(120, 120);
    check("A[120] dato nuevo", rdata_a, x"87654321");

    -------------------------------------------------------------------------
    report "TEST 8: el programa original no se ha corrompido" severity note;
    -------------------------------------------------------------------------
    for i in 0 to 31 loop
      read_ab(i, i);
      check("final A[" & integer'image(i) & "]", rdata_a, expected_init(i));
    end loop;

    -------------------------------------------------------------------------
    wait for 5 * CLK_PERIOD;
    if errors = 0 then
      report "SIMULACION COMPLETADA: TODOS LOS TESTS OK" severity note;
    else
      report "SIMULACION COMPLETADA: " & integer'image(errors) & " ERRORES" severity error;
    end if;
    done <= true;
    wait;
  end process;

end sim;
