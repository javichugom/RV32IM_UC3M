library ieee;
use ieee.std_logic_1164.all;

package instructions is
    type instruction_t is (
        -- Integer computational instructions
        add, sub, bxor, bor, band, bsll, bsrl,
        bsra, slt, sltu, addi, xori, ori, andi,
        slli, srli, srai, slti, sltiu, lui, auipc, 

        -- Loads and stores instructions
        lb, lh, lw, lbu, lhu, sb, sh, sw,

        -- Control transfer instructions
        beq, bne, blt, bge, bltu, bgeu, jal, jalr,

        -- Memory ordering instructions
        fence,

        -- Environment call and breakpoints instructions
        ecall, ebreak,

        illegal
    );
    
    type alu_operation_t is (
        add,
        sub,
        alu_xor,
        alu_and,
        alu_or,
        s_left,
        s_right_a,
        s_right_l,
        slt,
        lui
    );
    
    type branch_fault_t is (
        none,
        less_u,
        less_s,
        equal,
        not_equal,
        ge_u,
        ge_s,
        jal,
        jalr
    );
    
    type mux_ual_1_t is (
        reg,
        pc
    );
    
    type mux_ual_2_t is (
        reg,
        imm,
        pc_increment
    );          
    
    type mux_wb_t is (
        mem,
        alu_res
    );
    
    type memory_data_len_t is (
        byte,
        half_word,
        full_word
    );

    type operation_sign_t is (
        u,
        s
    );

    type microinstruction_t is record
        alu_op : alu_operation_t;
        branch : branch_fault_t;
        mux_1 : mux_ual_1_t;
        mux_2 : mux_ual_2_t;
        r_w_mem   : std_logic;
        w_reg_en : std_logic;
        mux_wb : mux_wb_t;
        operation_sign : operation_sign_t;
        memory_data_len: memory_data_len_t;
    end record;

    function decode_instruction(instruction_encoded : std_logic_vector(31 downto 0)) return instruction_t;
    function decode_microinstruction(instruction : instruction_t) return microinstruction_t;
end package instructions;

package body instructions is
    function decode_instruction(instruction_encoded : std_logic_vector(31 downto 0)) return instruction_t is
        variable result : instruction_t;
        variable opcode : std_logic_vector(6 downto 0);
        variable func3 : std_logic_vector(2 downto 0);
        variable func7 : std_logic_vector(6 downto 0);
    begin
        opcode := instruction_encoded(6 downto 0);
        func3 := instruction_encoded(14 downto 12);
        func7:= instruction_encoded(31 downto 25);

        result :=      add    when opcode = "0110011" and func3 = "000" and func7 = "0000000"
                  else sub    when opcode = "0110011" and func3 = "000" and func7 = "0100000"
                  else bxor   when opcode = "0110011" and func3 = "100" and func7 = "0000000"
                  else bor    when opcode = "0110011" and func3 = "110" and func7 = "0000000"
                  else band   when opcode = "0110011" and func3 = "111" and func7 = "0000000"
                  else bsll   when opcode = "0110011" and func3 = "001" and func7 = "0000000"
                  else bsrl   when opcode = "0110011" and func3 = "101" and func7 = "0000000"
                  else bsra   when opcode = "0110011" and func3 = "101" and func7 = "0100000"
                  else slt    when opcode = "0110011" and func3 = "010" and func7 = "0000000"
                  else sltu   when opcode = "0110011" and func3 = "011" and func7 = "0000000"

                  else addi   when opcode = "0010011" and func3 = "000"
                  else xori   when opcode = "0010011" and func3 = "100"
                  else ori    when opcode = "0010011" and func3 = "110"
                  else andi   when opcode = "0010011" and func3 = "111"

                  else slli   when opcode = "0010011" and func3 = "001" and func7 = "0000000"
                  else srli   when opcode = "0010011" and func3 = "101" and func7 = "0000000"
                  else srai   when opcode = "0010011" and func3 = "101" and func7 = "0100000"
                
                  else slti   when opcode = "0010011" and func3 = "010"
                  else sltiu  when opcode = "0010011" and func3 = "011"

                  else lui    when opcode = "0110111"
                  else auipc  when opcode = "0010111"

                  else lb     when opcode = "0000011" and func3 = "000"
                  else lh     when opcode = "0000011" and func3 = "001"
                  else lw     when opcode = "0000011" and func3 = "010"
                  else lbu    when opcode = "0000011" and func3 = "100"
                  else lhu    when opcode = "0000011" and func3 = "101"

                  else sb     when opcode = "0100011" and func3 = "000"
                  else sh     when opcode = "0100011" and func3 = "001"
                  else sw     when opcode = "0100011" and func3 = "010"

                  else beq    when opcode = "1100011" and func3 = "000"
                  else bne    when opcode = "1100011" and func3 = "001"
                  else blt    when opcode = "1100011" and func3 = "100"
                  else bge    when opcode = "1100011" and func3 = "101"
                  else bltu   when opcode = "1100011" and func3 = "110"
                  else bgeu   when opcode = "1100011" and func3 = "111"

                  else jal    when opcode = "1101111"
                  else jalr   when opcode = "1100111" and func3 = "000"

                  else fence  when opcode = "0001111" and func3 = "000"

                  else ecall  when instruction_encoded = "00000000000000000000000001110011"
                  else ebreak  when instruction_encoded = "00000000000100000000000001110011"

                  else illegal;

        return result;
    end;

    function decode_microinstruction(instruction : instruction_t) return microinstruction_t is
        variable microinstruction : microinstruction_t;
    begin
        with instruction select
        microinstruction :=
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when add,
                (
                    alu_op   => sub,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when sub,
                (
                    alu_op   => alu_xor,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when bxor,
                ( 
                    alu_op   => alu_or,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when bor,
                (
                    alu_op   => alu_and,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when band,
                (
                    alu_op   => s_left,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when bsll,
                (
                    alu_op   => s_right_l,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when bsrl,
                (
                    alu_op   => s_right_a,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when bsra,
                (
                    alu_op   => slt,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when slt,
                (
                    alu_op   => slt,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when sltu,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when addi,
                (
                    alu_op   => alu_xor,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when xori,
                (
                    alu_op   => alu_or,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when ori,
                (
                    alu_op   => alu_and,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when andi,
                (
                    alu_op   => s_left,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when slli,
                (
                    alu_op   => s_right_l,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when srli,
                (
                    alu_op   => s_right_a,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when srai,
                (
                    alu_op   => slt,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when slti,
                (
                    alu_op   => slt,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when sltiu,
                (
                    alu_op   => lui,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when lui,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => pc,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when auipc,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => mem,
                    operation_sign => s,
                    memory_data_len => byte
                ) when lb,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => mem,
                    operation_sign => s,
                    memory_data_len => half_word
                ) when lh,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => mem,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when lw,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => mem,
                    operation_sign => u,
                    memory_data_len => byte
                ) when lbu,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => mem,
                    operation_sign => u,
                    memory_data_len => half_word
                ) when lhu,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '1',
                    w_reg_en => '0',
                    mux_wb   => mem,
                    operation_sign => s,
                    memory_data_len => byte
                ) when sb,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '1',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => half_word
                ) when sh,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => imm,
                    r_w_mem  => '1',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when sw,

                (
                    alu_op   => sub,
                    branch   => equal,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when beq,
                (
                    alu_op   => sub,
                    branch   => not_equal,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when bne,
                (
                    alu_op   => sub,
                    branch   => less_s,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when blt,
                (
                    alu_op   => sub,
                    branch   => ge_s,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when bge,
                (
                    alu_op   => sub,
                    branch   => less_u,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when bltu,
                (
                    alu_op   => sub,
                    branch   => ge_u,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when bgeu,

                (
                    alu_op   => add,
                    branch   => jal,
                    mux_1    => pc,
                    mux_2    => pc_increment,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when jal,
                (
                    alu_op   => add,
                    branch   => jalr,
                    mux_1    => pc,
                    mux_2    => pc_increment,
                    r_w_mem  => '0',
                    w_reg_en => '1',
                    mux_wb   => alu_res,
                    operation_sign => u,
                    memory_data_len => full_word
                ) when jalr,

                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when fence,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when ecall,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when ebreak,
                (
                    alu_op   => add,
                    branch   => none,
                    mux_1    => reg,
                    mux_2    => reg,
                    r_w_mem  => '0',
                    w_reg_en => '0',
                    mux_wb   => alu_res,
                    operation_sign => s,
                    memory_data_len => full_word
                ) when illegal;
        return microinstruction;
    end;
end package body instructions;
