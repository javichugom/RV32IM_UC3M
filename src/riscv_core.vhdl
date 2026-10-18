library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;
use work.instructions.all;

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

    signal stage1_output : stage1_output_t;

    signal microinstruction : microinstruction_t;
    signal alu_result : word;
    signal flag_eq : std_logic;
    signal flag_lt : std_logic;
    signal flag_lt_u : std_logic;
    signal addr_inst_aux : word;
    signal rd_addr_o : std_logic_vector(4 downto 0);
    signal rs1 : word;
    signal rs2 : word;
    signal immediate : word;
    signal flag_illegal_instruction : std_logic;

    signal stage2_output : stage2_output_t;

    signal wb_value : word;
begin
    -- Stage 1
    u_fetch : entity work.riscv_fetch(rtl)
        port map (
            clk         => clk,
            rst         => rst,
            stall       => stall,

            addr_inst   => addr_inst_aux,
            wdata_inst  => wdata_inst,
            rdata_inst  => rdata_inst,
            we_inst     => we_inst,
            be_inst     => be_inst,

            branch_e    => branch_e,
            branch_addr => branch_addr,

            instruction => instruction
        );

    addr_inst <= addr_inst_aux;

    stage_1_reg: entity work.stage_register(rtl)
     generic map(
        stage_output_t => stage1_output_t,
        reset_value => (
            instruction => NOP,
            pc => x"00000004"
        )
    )
     port map(
        clk => clk,
        rst => rst,
        stall => stall,
        stage_output_i => (
            instruction => instruction,
            pc => addr_inst_aux
        ),
        stage_output_o => stage1_output
    );

    -- Stage 2
    u_dec_exe : entity work.riscv_decexe
        port map (
            clk => clk,
            rst => rst,
            pc_value => stage1_output.pc,

            wd => wb_value,
            rd => stage2_output.rd_address,
            reg_write => stage2_output.reg_write,

            rd_addr_o => rd_addr_o,
            rs1 => rs1,
            rs2 => rs2,
            immediate => immediate,

            instruction => instruction,
            microinstruction => microinstruction,
            flag_illegal_instruction => flag_illegal_instruction,

            alu_result => alu_result,
            flag_eq => flag_eq,
            flag_lt => flag_lt,
            flag_lt_u => flag_lt_u
        );    

    stage_2_reg: entity work.stage_register(rtl)
     generic map(
        stage_output_t => stage2_output_t,
        reset_value => (
            alu_result => x"--------",
            rs2 => x"--------",
            rd_address => "-----",
            memory_write => '0',
            reg_write => '0',
            mux_wb => alu_res
        )
    )
     port map(
        clk => clk,
        rst => rst,
        stall => stall,
        stage_output_i => (
            alu_result => alu_result,
            rs2 => rs2,
            rd_address => rd_addr_o,
            memory_write => microinstruction.r_w_mem,
            reg_write => microinstruction.w_reg_en,
            mux_wb => microinstruction.mux_wb
        ),
        stage_output_o => stage2_output
    );

    with stage2_output.mux_wb select
    wb_value <= stage2_output.alu_result when alu_res,
                rdata_data when mem;
    addr_data <= stage2_output.alu_result;
    wdata_data <= stage2_output.rs2;
    we_data <= stage2_output.memory_write;
    be_data <= "1111"; -- TODO
end rtl;
