library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.all;

entity riscv_decexe is
    port (
        clk : in std_logic;
        rst : in std_logic;
        ready : out std_logic;
        done : out std_logic;

        pc_value : in word;

        wd : in word;
        rd : in  std_logic_vector(4 downto 0);
        reg_write : in std_logic;

        rd_addr_o: out std_logic_vector(4 downto 0);
        rs1 : out word;
        rs2 : out word;
        immediate : out word;

        instruction : in word;       
        microinstruction : out microinstruction_t;
        flag_illegal_instruction : out std_logic;

        execute_result : out word;
        flag_eq : out std_logic;
        flag_lt : out std_logic;
        flag_lt_u : out std_logic;

        branch_next_cycle : out std_logic;
        branch_operand1 : out word;
        branch_operand2 : out word;

        addr_data : out word;
        we_data : out std_logic;
        be_data : out std_logic_vector(3 downto 0);
        wdata_data : out word;
        unaligned_memory_waddress: out std_logic
    );
end riscv_decexe;


architecture rtl of riscv_decexe is
    signal rs1_addr      : std_logic_vector(4 downto 0);
    signal rs2_addr      : std_logic_vector(4 downto 0);
    signal rf_rs1        : word;
    signal rf_rs2        : word;

    signal rs1_aux : word;
    signal rs2_aux : word;

    signal immediate_aux : word;

    signal alu_operand_1 : word;
    signal alu_operand_2 : word;

    signal alu_result : word;

    signal div_result : word;
    signal quotient : word;
    signal remainder : word;

    function select_register_value(
        current_value : word;
        register_source : std_logic_vector(4 downto 0);
        write_enable : std_logic;
        write_register : std_logic_vector(4 downto 0);
        new_value : word
    ) return word is
    begin
        if write_enable = '1' and register_source = write_register
            and write_register /= "00000" then
            return new_value;
        else
            return current_value;
        end if;

    end function select_register_value;
begin
    rf_inst : entity work.register_file(rtl)
        generic map (
            NUM_REGISTERS => 32
        )
        port map (
            clk      => clk,
            rst      => rst,
            wd       => wd,
            rd       => rd,
            reg_write => reg_write,
            rs1      => rs1_addr,
            rd1      => rf_rs1,
            rs2      => rs2_addr,
            rd2      => rf_rs2
        );

    rs1_aux <= select_register_value(rf_rs1, rs1_addr, reg_write, rd, wd);
    rs2_aux <= select_register_value(rf_rs2, rs2_addr, reg_write, rd, wd);

    rs1 <= rs1_aux;
    rs2 <= rs2_aux;

    dec_inst : entity work.decoder(rtl)
        port map (
            instr    => instruction,
            rs1      => rs1_addr,
            rs2      => rs2_addr,
            rd       => rd_addr_o,
            microinstruction => microinstruction,
            illegal_instr => flag_illegal_instruction
        );            

    ext_immediate_inst: entity work.ext_immediate(rtl)
     port map(
        instr => instruction,
        imm_ext => immediate_aux
    );
    immediate <= immediate_aux;

    with microinstruction.mux_1 select
    alu_operand_1 <= rs1_aux when reg,
                     pc_value when pc;
    with microinstruction.mux_2 select
    alu_operand_2 <= rs2_aux when reg,
                     immediate when imm,
                     std_logic_vector(to_unsigned(
                         PC_INCREMENT_VALUE, WORD_LENGTH)) when pc_increment;

    alu_inst: entity work.alu(rtl)
     port map(
        a => alu_operand_1,
        b => alu_operand_2,
        alu_operation => microinstruction.alu_op,
        operation_sign => microinstruction.operation_sign,
        result => alu_result,
        f_eq => flag_eq,
        f_lt => flag_lt,
        f_lt_u => flag_lt_u
    );

    div_inst: entity work.riscv_divider
     port map(
        clk => clk,
        rst => rst,
        dividend => rs1_aux,
        divider => rs2_aux,
        operation_sign => microinstruction.operation_sign,
        valid => '1',
        ready => open, -- Using parallel implementation
        done => open, -- Using parallel implementation
        quotient => quotient,
        remainder => remainder
    );

    with microinstruction.divider_op select
    div_result <= quotient when ddiv,
                  remainder when drem;

    with microinstruction.mux_execute_res select
    execute_result <= alu_result when alu,
                      div_result when div;

    with microinstruction.branch select
    branch_next_cycle <=
        '0' when none,
        flag_lt_u when less_u,
        flag_lt when less_s,
        flag_eq when equal,
        not flag_eq when not_equal,
        not flag_lt_u when ge_u,
        not flag_lt when ge_s,
        '1' when jal | jalr;

    with microinstruction.branch select
    branch_operand1 <=
        rs1 when jalr,
        pc_value when none | less_u | less_s | equal |
                              not_equal | ge_u | ge_s | jal;

    branch_operand2 <= immediate;

    with microinstruction.branch select
    branch_next_cycle <=
        '0' when none,
        flag_lt_u when less_u,
        flag_lt when less_s,
        flag_eq when equal,
        not flag_eq when not_equal,
        not flag_lt_u when ge_u,
        not flag_lt when ge_s,
        '1' when jal | jalr;

    addr_data <= alu_result;
    we_data <= microinstruction.r_w_mem;

    bytes_organiser_write_inst: entity work.bytes_organiser_write(rtl)
        port map(
            memory_address => addr_data,
            memory_wdata => rs2,

            memory_data_len => microinstruction.memory_data_len,
            be_write => be_data,

            memory_wdata_organised => wdata_data,
            unaligned_memory_waddress => unaligned_memory_waddress
        );
end rtl;
