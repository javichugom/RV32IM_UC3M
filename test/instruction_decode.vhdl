library ieee;
use ieee.std_logic_1164.all;

use work.instructions.all;

entity test_instruction_decode is
end  test_instruction_decode;

architecture test of test_instruction_decode is
    subtype inst is std_logic_vector(31 downto 0);

    type test_case is record
        instruction_encoded : inst;
        instruction_decoded : instruction_t;
    end record test_case;

    type test_cases is array(0 to 40) of test_case;
    constant test_data : test_cases := ( 
        (instruction_encoded => "00000000000000000000000000110011", instruction_decoded => add),
        (instruction_encoded => "01000000000000000000000000110011", instruction_decoded => sub),
        (instruction_encoded => "00000000000000000100000000110011", instruction_decoded => bxor),
        (instruction_encoded => "00000000000000000110000000110011", instruction_decoded => bor),
        (instruction_encoded => "00000000000000000111000000110011", instruction_decoded => band),
        (instruction_encoded => "00000000000000000001000000110011", instruction_decoded => bsll),
        (instruction_encoded => "00000000000000000101000000110011", instruction_decoded => bsrl),
        (instruction_encoded => "01000000000000000101000000110011", instruction_decoded => bsra),
        (instruction_encoded => "00000000000000000010000000110011", instruction_decoded => slt),
        (instruction_encoded => "00000000000000000011000000110011", instruction_decoded => sltu),
        (instruction_encoded => "00000000000000000000000000010011", instruction_decoded => addi),
        (instruction_encoded => "00000000000000000100000000010011", instruction_decoded => xori),
        (instruction_encoded => "00000000000000000110000000010011", instruction_decoded => ori),
        (instruction_encoded => "00000000000000000111000000010011", instruction_decoded => andi),
        (instruction_encoded => "00000000000000000001000000010011", instruction_decoded => slli),
        (instruction_encoded => "00000000000000000101000000010011", instruction_decoded => srli),
        (instruction_encoded => "01000000000000000101000000010011", instruction_decoded => srai),
        (instruction_encoded => "00000000000000000010000000010011", instruction_decoded => slti),
        (instruction_encoded => "00000000000000000011000000010011", instruction_decoded => sltiu),
        (instruction_encoded => "00000000000000000000000000110111", instruction_decoded => lui),
        (instruction_encoded => "00000000000000000000000000010111", instruction_decoded => auipc),
        (instruction_encoded => "00000000000000000000000000000011", instruction_decoded => lb),
        (instruction_encoded => "00000000000000000001000000000011", instruction_decoded => lh),
        (instruction_encoded => "00000000000000000010000000000011", instruction_decoded => lw),
        (instruction_encoded => "00000000000000000100000000000011", instruction_decoded => lbu),
        (instruction_encoded => "00000000000000000101000000000011", instruction_decoded => lhu),
        (instruction_encoded => "00000000000000000000000000100011", instruction_decoded => sb),
        (instruction_encoded => "00000000000000000001000000100011", instruction_decoded => sh),
        (instruction_encoded => "00000000000000000010000000100011", instruction_decoded => sw),
        (instruction_encoded => "00000000000000000000000001100011", instruction_decoded => beq),
        (instruction_encoded => "00000000000000000001000001100011", instruction_decoded => bne),
        (instruction_encoded => "00000000000000000100000001100011", instruction_decoded => blt),
        (instruction_encoded => "00000000000000000101000001100011", instruction_decoded => bge),
        (instruction_encoded => "00000000000000000110000001100011", instruction_decoded => bltu),
        (instruction_encoded => "00000000000000000111000001100011", instruction_decoded => bgeu),
        (instruction_encoded => "00000000000000000000000001101111", instruction_decoded => jal),
        (instruction_encoded => "00000000000000000000000001100111", instruction_decoded => jalr),
        (instruction_encoded => "00001111111100000000000000001111", instruction_decoded => fence),
        (instruction_encoded => "00000000000000000000000001110011", instruction_decoded => ecall),
        (instruction_encoded => "00000000000100000000000001110011", instruction_decoded => ebreak),
        (instruction_encoded => (others => '1'), instruction_decoded => undefined)
    );

begin
    process
        variable instruction_encoded : inst;
        variable expected : instruction_t;
        variable obtained : instruction_t;
    begin
        for i in 0 to test_data'length-1 loop
            instruction_encoded := test_data(i).instruction_encoded;
            expected := test_data(i).instruction_decoded;

            obtained := decode_instruction(instruction_encoded);
            assert expected = obtained
                report "Error decoding " & instruction_t'image(expected) & " instruction." & LF
                & ht & "expected: " & instruction_t'image(expected) & LF
                & ht & "obtained: " & instruction_t'image(obtained);
        end loop;
        wait;
    end process;
end architecture test;
