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
    signal instruction : word;
    signal stage1_output : stage1_output_t;

    signal microinstruction : microinstruction_t;
    signal alu_result : word;
    signal flag_eq : std_logic;
    signal flag_lt : std_logic;
    signal flag_lt_u : std_logic;
    signal pc : word;
    signal rd_addr_o : std_logic_vector(4 downto 0);
    signal rs1 : word;
    signal rs2 : word;
    signal immediate : word;
    signal flag_illegal_instruction : std_logic;

    signal branch_next_cycle : std_logic;
    signal branch_operand1 : word;
    signal branch_operand2 : word;

    signal stage2_output : stage2_output_t;

    signal wb_value : word;
    signal unaligned_memory_waddress : std_logic;
    signal unaligned_memory_raddress : std_logic;
begin
    -- Stage 1
    u_fetch : entity work.riscv_fetch(rtl)
        port map (
            clk         => clk,
            rst         => rst,
            stall       => '0',

            addr_inst   => addr_inst,
            wdata_inst  => wdata_inst,
            rdata_inst  => rdata_inst,
            we_inst     => we_inst,
            be_inst     => be_inst,

            pc => pc,

            operand1 => branch_operand1,
            operand2 => branch_operand2,
            branch => branch_next_cycle,

            instruction => instruction
        );

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
            rst => rst or branch_next_cycle,
            stall => '0',
            stage_output_i => (
                instruction => instruction,
                pc => pc
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

            instruction => stage1_output.instruction,
            microinstruction => microinstruction,
            flag_illegal_instruction => flag_illegal_instruction,

            alu_result => alu_result,
            flag_eq => flag_eq,
            flag_lt => flag_lt,
            flag_lt_u => flag_lt_u,

            branch_next_cycle => branch_next_cycle,
            branch_operand1 => branch_operand1,
            branch_operand2 => branch_operand2,

            addr_data => addr_data,
            we_data => we_data,
            be_data => be_data,
            wdata_data => wdata_data,
            unaligned_memory_waddress=> unaligned_memory_waddress
        );    


    stage_2_reg: entity work.stage_register(rtl)
        generic map(
            stage_output_t => stage2_output_t,
            reset_value => (
                alu_result => x"--------",
                rd_address => "-----",
                reg_write => '0',
                mux_wb => alu_res,
                memory_data_len => full_word,
                operation_sign => s
            )
        )
        port map(
            clk => clk,
            rst => rst,
            stall => '0',
            stage_output_i => (
                alu_result => alu_result,
                rd_address => rd_addr_o,
                reg_write => microinstruction.w_reg_en,
                mux_wb => microinstruction.mux_wb,
                memory_data_len => microinstruction.memory_data_len,
                operation_sign => microinstruction.operation_sign
            ),
            stage_output_o => stage2_output
        );

    -- Stage 3
    u_wb : entity work.riscv_wb(rtl)
     port map(
        memory_address => stage2_output.alu_result,
        memory_rdata => rdata_data,
        memory_data_len => stage2_output.memory_data_len,
        operation_sign => stage2_output.operation_sign,
        mux_wb => stage2_output.mux_wb,
        alu_result => stage2_output.alu_result,
        unaligned_memory_raddress => unaligned_memory_raddress,
        wb_value => wb_value
    );
end rtl;
