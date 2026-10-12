library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
use work.definitions.all;

entity register_file is
    generic(
        NUM_REGISTERS : natural := 32;
        WIDTH : natural := 32
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        wd : in std_logic_vector (WIDTH-1 downto 0);
        rd : in std_logic_vector (address_width(NUM_REGISTERS)-1 downto 0);
        reg_write : in std_logic;
        rs1 : in std_logic_vector (address_width(NUM_REGISTERS)-1 downto 0);
        rd1 : out std_logic_vector (WIDTH - 1 downto 0);
        rs2 : in std_logic_vector (address_width(NUM_REGISTERS)-1 downto 0);
        rd2 : out std_logic_vector (WIDTH - 1 downto 0)
    );
end register_file;

architecture rtl of register_file is
    type registers_t is array (NUM_REGISTERS-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
    signal registers : registers_t;
    signal enable_register : std_logic_vector(NUM_REGISTERS-1 downto 1); 
begin
    generate_registers: for i in 0 to NUM_REGISTERS-1 generate
        reg_x0 : if i = 0 generate
            register_0 : registers(0) <= (others => '0');
        end generate;

        reg_xi : if i > 0 generate
            enable_register(i) <= reg_write when unsigned(rd) = i else '0';
            register_i : entity work.registern_bits
            generic map (
                N => 32
            )
            port map (
                d     => wd,
                clk   => clk,
                load  => enable_register(i),
                reset => rst,
                q     => registers(i)
            );
        end generate;
    end generate;

    rd1 <= registers(to_integer(unsigned(rs1)));  
    rd2 <= registers(to_integer(unsigned(rs2)));  

end rtl;
