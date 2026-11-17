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
        
        branch : in std_logic;
        operand1 : in word;
        operand2 : in word;

        pc : out word;
        instruction : out word
    );
end riscv_fetch;

architecture rtl of riscv_fetch is
    subtype pc_t is word;
    signal pc_current : pc_t;
    signal pc_next : pc_t;

    constant RESET_ADDR : pc_t := x"00000000";
begin
    addr_inst <= pc_next;
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
        stage_output_o => pc_current
    );
    pc <= pc_current;

    process(all)
        variable branch_address : pc_t;
    begin
        branch_address := std_logic_vector(unsigned(operand1) + unsigned(operand2));
        pc_next <=
            RESET_ADDR when rst else
            std_logic_vector(unsigned(pc_current) + PC_INCREMENT_VALUE) when not branch else
            (31 downto 1 => branch_address(31 downto 1), 0 => '0');
    end process;

    instruction <= rdata_inst;
end rtl;
