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

        undefined
    );

    function decode_instruction(instruction_encoded : std_logic_vector(31 downto 0)) return instruction_t;
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

                  else undefined;

        return result;
    end;
end package body instructions;

