library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;

entity riscv_system is
    generic(
        INIT_FILE: string := "main.mem"
    );
    port (
        rst : in std_logic;
        clk : in std_logic
    );
end riscv_system;

architecture rtl of riscv_system is
    constant MEM_WIDTH      : integer := WORD_LENGTH;
    constant NUM_BYTES      : integer := MEM_WIDTH / 8;
    constant RAM_ADDR_WIDTH : integer := 17;

    -- Bus de instrucciones (puerto A)
    signal addr_inst  : std_logic_vector(31 downto 0);
    signal wdata_inst : std_logic_vector(31 downto 0);
    signal rdata_inst : std_logic_vector(31 downto 0);
    signal we_inst    : std_logic;
    signal be_inst    : std_logic_vector(3 downto 0);

    -- Bus de datos (puerto B)
    signal addr_data  : std_logic_vector(31 downto 0);
    signal wdata_data : std_logic_vector(31 downto 0);
    signal rdata_data : std_logic_vector(31 downto 0);
    signal we_data    : std_logic;
    signal be_data    : std_logic_vector(3 downto 0);
begin

    u_core : entity work.riscv_core(rtl)
        port map (
            rst        => rst,
            clk        => clk,

            addr_inst  => addr_inst,
            wdata_inst => wdata_inst,
            rdata_inst => rdata_inst,
            we_inst    => we_inst,
            be_inst    => be_inst,

            addr_data  => addr_data,
            wdata_data => wdata_data,
            rdata_data => rdata_data,
            we_data    => we_data,
            be_data    => be_data
        );

    u_mem : entity work.memory(rtl)
        generic map (
            MEM_WIDTH      => MEM_WIDTH,
            NUM_BYTES      => NUM_BYTES,
            RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
            INIT_FILE      => INIT_FILE
        )
        port map (
            clk     => clk,

            -- Puerto A: instrucciones
            addr_a  => addr_inst(RAM_ADDR_WIDTH+1 downto 2),
            wdata_a => wdata_inst,
            rdata_a => rdata_inst,
            we_a    => we_inst,
            be_a    => be_inst,

            -- Puerto B: datos
            addr_b  => addr_data(RAM_ADDR_WIDTH+1 downto 2),
            wdata_b => wdata_data,
            rdata_b => rdata_data,
            we_b    => we_data,
            be_b    => be_data
        );

end rtl;
