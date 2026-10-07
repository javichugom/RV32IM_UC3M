library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;

entity riscv_core is
    port(
        rst : in std_logic;
        clk : in std_logic;

        addr_inst  : out word;
        wdata_inst : out word;
        rdata_inst : in  word;
        we_inst    : out std_logic;
        be_inst    : out std_logic_vector(3 downto 0);

        addr_data  : out word;
        wdata_data : out word;
        rdata_data : in  word;
        we_data    : out std_logic;
        be_data    : out std_logic_vector(3 downto 0)
    );
end riscv_core;

architecture rtl of riscv_core is
    signal stall       : std_logic;

    signal branch_e    : std_logic;
    signal branch_addr : word;

    signal instruction : word;
begin

    u_fetch : entity work.riscv_fetch(rtl)
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
end rtl;
