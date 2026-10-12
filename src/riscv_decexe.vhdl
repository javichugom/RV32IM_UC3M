library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;
use work.instructions.all;

entity riscv_decexe is
    port (
        clk : in std_logic;
        rst : in std_logic;
        pc : in word;

        wd : in word;
        rd : in  std_logic_vector(4 downto 0);
        reg_write : in std_logic;

        rd_addr: out std_logic_vector(4 downto 0);

        instruction : in word;       
        microinstruction : out microinstruction_t;

        alu_result : out word
    );
end riscv_decexe;


architecture rtl of riscv_decexe is
    signal rs1_addr      : std_logic_vector(4 downto 0);
    signal rs2_addr      : std_logic_vector(4 downto 0);
    signal rf_rd1        : std_logic_vector(31 downto 0);
    signal rf_rd2        : std_logic_vector(31 downto 0);
    signal illegal_instr : std_logic;
begin
    rf_inst : entity work.register_file
        generic map (
            NUM_REGISTERS => 32,
            WIDTH => WORD_LENGTH
        )
        port map (
            clk      => clk,
            rst      => rst,
            wd       => wd,
            rd       => rd,
            reg_write => reg_write,
            rs1      => rs1_addr,
            rd1      => rf_rd1,
            rs2      => rs2_addr,
            rd2      => rf_rd2
        );

    dec_inst : entity work.decoder
        port map (
            instr    => instruction,
            rs1      => rs1_addr,
            rs2      => rs2_addr,
            rd       => rd_addr,
            microinstruction => microinstruction,
            illegal_instr => illegal_instr
        );            
end rtl;
