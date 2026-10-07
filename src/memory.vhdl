library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity memory is
    generic(
        MEM_WIDTH: integer := 32;
        NUM_BYTES: integer := 4;
        RAM_ADDR_WIDTH: integer := 17;
        INIT_FILE: string := "main.mem"
    );
    port(
        clk:    in std_logic;

        addr_a: in std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
        wdata_a: in std_logic_vector(MEM_WIDTH -1 downto 0);
        rdata_a: out std_logic_vector(MEM_WIDTH -1 downto 0);
        we_a: in std_logic;
        be_a: in std_logic_vector(NUM_BYTES-1 downto 0);

        addr_b: in std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
        wdata_b: in std_logic_vector(MEM_WIDTH-1 downto 0);
        rdata_b: out std_logic_vector(MEM_WIDTH-1 downto 0);
        we_b: in std_logic;
        be_b: in std_logic_vector(NUM_BYTES-1 downto 0)
    );
end memory;

architecture rtl of memory is
    constant DEPTH : integer := 2**(RAM_ADDR_WIDTH);
    constant BYTE_W : integer := MEM_WIDTH/NUM_BYTES;

    type mem_t is array (0 to DEPTH-1) of std_logic_vector(MEM_WIDTH - 1 downto 0);

    attribute ram_style          : string;
    attribute ram_style of mem_t : type is "block";

    impure function init_mem_from_file(file_name : string) return mem_t is
        file mem_file      : text open read_mode is file_name;
        variable mem_line  : line;
        variable temp_mem  : mem_t := (others => (others => '0'));
        variable temp_word : std_logic_vector(MEM_WIDTH-1 downto 0);
        variable i         : integer := 0;
    begin
        while not endfile(mem_file) and i < DEPTH loop
            readline(mem_file, mem_line);
            hread(mem_line, temp_word);
            temp_mem(i) := temp_word;
            i := i + 1;
        end loop;

        return temp_mem;
    end function;

    shared variable mem : mem_t := init_mem_from_file(INIT_FILE);
begin
    P_PORT_A:
    process(clk)
        variable idx : integer;
    begin
        if rising_edge(clk) then
            idx := to_integer(unsigned(addr_a));
            rdata_a <= mem(idx);                       -- read-first
            if we_a = '1' then
                for index in be_a'range loop
                    if be_a(index) = '1' then
                        mem(idx)(BYTE_W*(index + 1) - 1 downto BYTE_W*index) :=
                        wdata_a(BYTE_W*(index + 1) - 1 downto BYTE_W*index);
                    end if;
                end loop;
            end if;
        end if;
    end process;

    P_PORT_B:
    process(clk)
        variable idx : integer;
    begin
    if rising_edge(clk) then
        idx := to_integer(unsigned(addr_b));
        rdata_b <= mem(idx);                       -- read-first
        if we_b = '1' then
            for index in be_b'range loop
                if be_b(index) = '1' then
                    mem(idx)(BYTE_W*(index + 1) - 1 downto BYTE_W*index) :=
                    wdata_b(BYTE_W*(index + 1) - 1 downto BYTE_W*index);
                end if;
            end loop;
        end if;
    end if;
    end process;

end rtl;
