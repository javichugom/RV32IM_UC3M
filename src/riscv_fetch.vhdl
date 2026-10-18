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
    subtype pc_t is word;
    signal pc : pc_t;
    signal pc_next : pc_t;
begin
    addr_inst <= pc;
    we_inst <= '0';
    be_inst <= "1111";

    pc_reg: entity work.stage_register(rtl)
     generic map(
        stage_output_t => pc_t,
        reset_value => x"00000000"
    )
     port map(
        clk => clk,
        rst => rst,
        stall => stall,
        stage_output_i => pc_next,
        stage_output_o => pc
    );

    pc_next <= branch_addr when branch_e else
               std_logic_vector(unsigned(pc) + PC_INCREMENT_VALUE);

    instruction <= rdata_inst;
end rtl;
