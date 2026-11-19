library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        dividend  : in  std_logic_vector(31 downto 0);
        divider   : in  std_logic_vector(31 downto 0);
        valid     : in  std_logic;
        ready     : out std_logic;
        done      : out std_logic;
        quotient  : out std_logic_vector(31 downto 0);
        remainder : out std_logic_vector(31 downto 0)
    );
end divider;

architecture serial of divider is
    signal register_rc      : unsigned(64 downto 0);
    signal register_rc_next : unsigned(64 downto 0);
    signal register_divider : unsigned(32 downto 0);
    signal counter          : integer range 0 to 32;
    signal remainder_aux    : unsigned(32 downto 0);
    signal ready_aux        : std_logic;
begin

    P_COMB: process(all)
        variable shifted : unsigned(64 downto 0);
        variable rem_v   : unsigned(32 downto 0);
    begin
        shifted := shift_left(register_rc, 1);
        rem_v   := shifted(64 downto 32);

        if register_rc(64) = '1' then
            rem_v := rem_v + register_divider;
        else
            rem_v := rem_v - register_divider;
        end if;

        shifted(64 downto 32) := rem_v;
        shifted(0)            := not rem_v(32);

        register_rc_next <= shifted;
    end process P_COMB;

    P_SECUENCIAL: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                register_rc <= (others => '0');
                register_divider <= (others => '0');
                counter    <= 32;                       
            elsif valid = '1' and ready_aux = '1' then
                register_rc <= to_unsigned(0, 33) & unsigned(dividend);
                register_divider <= '0' & unsigned(divider);
                counter    <= 0;
            elsif counter < 32 then
                register_rc <= register_rc_next;
                counter    <= counter + 1;
            end if;
        end if;
    end process P_SECUENCIAL;

    remainder_aux <= register_rc(64 downto 32) + register_divider when register_rc(64) = '1'
                     else register_rc(64 downto 32);

    remainder     <= std_logic_vector(remainder_aux(31 downto 0));
    quotient      <= std_logic_vector(register_rc(31 downto 0));
    ready_aux     <= '1' when counter = 32 else '0';
    ready         <= ready_aux;
    done          <= ready_aux;
end serial;

architecture parallel of divider is
begin

  P_DIV: process(all)
    variable remainder_aux    : unsigned(32 downto 0); 
    variable shifted      : unsigned(32 downto 0);
    variable d            : unsigned(32 downto 0);
    variable quotient_aux : std_logic_vector(31 downto 0);
    variable r_end        : unsigned(32 downto 0);
  begin
    d := '0' & unsigned(divider);
    remainder_aux := (others => '0');

    for i in 31 downto 0 loop
      shifted := remainder_aux(31 downto 0) & dividend(i);

      if remainder_aux(32) = '1' then
        remainder_aux := shifted + d;
      else
        remainder_aux := shifted - d;
      end if;

      quotient_aux(i) := not remainder_aux(32);
    end loop;

    if remainder_aux(32) = '1' then
      r_end := remainder_aux + D;
    else
      r_end := remainder_aux;
    end if;

    quotient  <= quotient_aux;
    remainder <= std_logic_vector(r_end(31 downto 0));
  end process P_DIV;

  -- Al ser combinacional puramente, está siempre disponible y emite done cuando valid está activo
  ready <= '1';
  done  <= valid;

end parallel;

architecture pipeline of divider is
    type stage_t is record
        rc    : unsigned(64 downto 0);  
        d     : unsigned(32 downto 0); 
        valid : std_logic;
    end record;

    subtype r is natural range 64 downto 32;
    subtype c is natural range 31 downto 0;

    type stage_array_t is array (0 to 32) of stage_t;
    signal stage_array : stage_array_t;

    signal remainder_aux : unsigned(32 downto 0);

    function step(x : stage_t) return stage_t is
        variable y  : stage_t;
        variable sh : unsigned(64 downto 0);
    begin
        sh := shift_left(x.rc, 1);

        if sh(r'left) = '1' then
            sh(r) := sh(r) + x.d;
        else
            sh(r) := sh(r) - x.d;
        end if;
        sh(c'right) := not sh(r'left);

        y.rc    := sh;
        y.d     := x.d;
        y.valid := x.valid;
        return y;
    end function;
begin
    process(clk)
    begin
        if rising_edge(clk)
        then
            stage_array(0).rc    <= (r => '0', c => unsigned(dividend));
            stage_array(0).d     <= '0' & unsigned(divider);
            stage_array(0).valid <= valid;

            for i in 1 to 32
            loop
                if rst
                then
                    stage_array(i).valid <= '0';
                else
                    stage_array(i) <= step(stage_array(i-1));
                end if;
            end loop;
        end if;
    end process;

    remainder_aux <= stage_array(32).rc(r) + stage_array(32).d when stage_array(32).rc(r'left) = '1' else stage_array(32).rc(r);

    quotient  <= std_logic_vector(stage_array(32).rc(c));
    remainder <= std_logic_vector(remainder_aux(31 downto 0));
    ready <= '1';
    done  <= stage_array(32).valid;
end pipeline;
