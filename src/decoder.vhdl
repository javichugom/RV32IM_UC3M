library ieee;
use ieee.std_logic_1164.all;

use work.instructions.all;
use work.definitions.all;

entity decoder is
    port (        
        instr   : in  word;
        rs1     : out std_logic_vector(4 downto 0);
        rs2     : out std_logic_vector(4 downto 0);
        rd      : out std_logic_vector(4 downto 0);
        microinstruction : out microinstruction_t;
        illegal_instr : out std_logic         
    );
end decoder;

architecture rtl of decoder is
    signal instruction : instruction_t;  
begin
    rs1     <= instr(19 downto 15);
    rs2     <= instr(24 downto 20);
    rd      <= instr(11 downto 7);

    instruction <= decode_instruction(instr);
    microinstruction <= decode_microinstruction(instruction);
    illegal_instr <= '1' when instruction = illegal else '0';
end rtl;
