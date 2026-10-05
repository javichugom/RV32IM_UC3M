library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_core is
    port(
        rst : in std_logic;
        clk : in std_logic;

        addr_inst  : out std_logic_vector(31 downto 0);
        wdata_inst : out std_logic_vector(31 downto 0);
        rdata_inst : in  std_logic_vector(31 downto 0);
        we_inst    : out std_logic;
        be_inst    : out std_logic_vector(3 downto 0);

        addr_data  : out std_logic_vector(31 downto 0);
        wdata_data : out std_logic_vector(31 downto 0);
        rdata_data : in  std_logic_vector(31 downto 0);
        we_data    : out std_logic;
        be_data    : out std_logic_vector(3 downto 0)
    );
end riscv_core;

architecture rtl of riscv_core is

    signal stall       : std_logic := '0';
    signal branch_e    : std_logic := '0';
    signal branch_addr : std_logic_vector(31 downto 0) := (others => '0');

    signal instruction : std_logic_vector(31 downto 0);

begin

    u_fetch : entity work.riscv_fetch
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
            instruction => instruction
        );

    addr_data  <= (others => '0');
    wdata_data <= (others => '0');
    we_data    <= '0';
    be_data    <= "0000";

end rtl;