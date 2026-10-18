library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

use work.instructions.mux_wb_t;

package definitions is
    constant WORD_LENGTH : natural := 32;
    subtype word is std_logic_vector(WORD_LENGTH - 1 downto 0); 

    constant PC_INCREMENT_VALUE : natural := 4;

    constant NOP : word := x"00000033";

    type stage1_output_t is record
        instruction : word;
        pc : word;
    end record;

    type stage2_output_t is record
        alu_result : word;
        rs2 : word;
        rd_address : std_logic_vector(4 downto 0);
        memory_write : std_logic;
        reg_write :std_logic;
        mux_wb : mux_wb_t;
    end record;

    function address_width(num_addresses: natural) return natural;
end package definitions;

package body definitions is
    function address_width(num_addresses: natural) return natural is
    begin
        return natural(ceil(log2(real(num_addresses))));
    end;
end package body definitions;
