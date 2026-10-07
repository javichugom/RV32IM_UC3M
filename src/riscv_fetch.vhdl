library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;

entity riscv_fetch is
    port(
        clk : in std_logic;
        rst : in std_logic;
        stall :  in std_logic;

        addr_inst : out word;
        wdata_inst : out word;  
        rdata_inst : in word;
        we_inst : out std_logic;
        be_inst: out std_logic_vector(3 downto 0);

        branch_e : in std_logic;
        branch_addr : in word; 

        instruction : out word
    );
end riscv_fetch;

architecture rtl of riscv_fetch is
    signal pc : word;
begin
    addr_inst <= pc;
    we_inst <= '0';
    be_inst <= "1111";

    process(clk)
    begin
        if rising_edge(clk)
        then
            pc <= (others => '0') when rst
                  else pc when stall
                  else branch_addr when branch_e
                  else std_logic_vector(unsigned(pc) + 4);
        end if;
    end process;

    instruction <= rdata_inst;
end rtl;
