library ieee;
use ieee.std_logic_1164.all;

use work.instructions.all;
use work.definitions.all;

entity tb_instruction_decode is
end  tb_instruction_decode;

architecture sim of tb_instruction_decode is
    type test_cases is array(instruction_t) of word;
    constant test_data : test_cases := ( 
        add => "00000000000000000000000000110011",
        sub => "01000000000000000000000000110011",
        bxor => "00000000000000000100000000110011",
        bor => "00000000000000000110000000110011",
        band => "00000000000000000111000000110011",
        bsll => "00000000000000000001000000110011",
        bsrl => "00000000000000000101000000110011",
        bsra => "01000000000000000101000000110011",
        slt => "00000000000000000010000000110011",
        sltu => "00000000000000000011000000110011",
        addi => "00000000000000000000000000010011",
        xori => "00000000000000000100000000010011",
        ori => "00000000000000000110000000010011",
        andi => "00000000000000000111000000010011",
        slli => "00000000000000000001000000010011",
        srli => "00000000000000000101000000010011",
        srai => "01000000000000000101000000010011",
        slti => "00000000000000000010000000010011",
        sltiu => "00000000000000000011000000010011",
        lui => "00000000000000000000000000110111",
        auipc => "00000000000000000000000000010111",
        lb => "00000000000000000000000000000011",
        lh => "00000000000000000001000000000011",
        lw => "00000000000000000010000000000011",
        lbu => "00000000000000000100000000000011",
        lhu => "00000000000000000101000000000011",
        sb => "00000000000000000000000000100011",
        sh => "00000000000000000001000000100011",
        sw => "00000000000000000010000000100011",
        beq => "00000000000000000000000001100011",
        bne => "00000000000000000001000001100011",
        blt => "00000000000000000100000001100011",
        bge => "00000000000000000101000001100011",
        bltu => "00000000000000000110000001100011",
        bgeu => "00000000000000000111000001100011",
        jal => "00000000000000000000000001101111",
        jalr => "00000000000000000000000001100111",
        fence => "00001111111100000000000000001111",
        ecall => "00000000000000000000000001110011",
        ebreak => "00000000000100000000000001110011",
        undefined => (others => '1')
    );

begin
    process
        variable obtained_instruction : instruction_t;
    begin
        for instruction in test_data'range loop
            obtained_instruction := decode_instruction(test_data(instruction));
            assert instruction = obtained_instruction
                report "Error decoding " & instruction_t'image(instruction) & " instruction." & LF
                & ht & "expected: " & instruction_t'image(instruction) & LF
                & ht & "obtained: " & instruction_t'image(obtained_instruction);
        end loop;
        std.env.finish;
    end process;
end architecture sim;
