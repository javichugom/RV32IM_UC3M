library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instructions.all;

entity riscv_fetch is
    port(
        clk : in std_logic;
        rst : in std_logic;
        stall :  in std_logic;

        addr_inst : out std_logic_vector(31 downto 0);
        wdata_inst : out std_logic_vector(31 downto 0);  
        rdata_inst : in std_logic_vector(31 downto 0);
        we_inst : out std_logic;
        be_inst: out std_logic_vector(3 downto 0);

        instruction : out instruction_t
    );
end riscv_fetch;

architecture rtl of riscv_fetch is
    signal pc : std_logic_vector(31 downto 0);
begin
    addr_inst <= pc;
    we_inst <= '1';
    be_inst <= "1111";

    process(clk)
    begin
        if rising_edge(clk)
        then
            pc <= (others => '0') when rst
                  else pc when stall
                  else std_logic_vector(unsigned(pc) + 4);
        end if;
    end process;

    instruction <= decode_instruction(rdata_inst);
end rtl;
