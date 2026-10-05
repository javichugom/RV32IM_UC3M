library ieee;
use ieee.std_logic_1164.all;


entity riscv_core is
    port(
        clk : in std_logic;
        
        addr_inst : out std_logic_vector(31 downto 0);
        wdata_inst : out std_logic_vector(31 downto 0);  
        rdata_inst : in std_logic_vector(31 downto 0);
        we_inst : out std_logic;
        be_inst: out std_logic_vector(3 downto 0);

        addr_data : out std_logic_vector(31 downto 0);
        wdata_data : out std_logic_vector(31 downto 0);  
        rdata_data : in std_logic_vector(31 downto 0);
        we_data : out std_logic;
        be_data: out std_logic_vector(3 downto 0)
    );
end riscv_core;
