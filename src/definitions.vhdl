library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

use work.instructions.mux_wb_t;
use work.instructions.memory_data_len_t;
use work.instructions.operation_sign_t;

package definitions is
    constant WORD_LENGTH : natural := 32;
    subtype word is std_logic_vector(WORD_LENGTH - 1 downto 0); 
    type registers_t is array (integer range<>) of word;

    constant PC_INCREMENT_VALUE : natural := 4;

    constant NOP : word := x"00000033";

    type pc_source_t is (
        pc_plus_4,
        jalr,
        branch_target
    );

    type stage1_output_t is record
        instruction : word;
        pc : word;
    end record;

    type stage2_output_t is record
        alu_result : word; -- Depending on the mux_wb is one or the other
        rd_address : std_logic_vector(4 downto 0);
        reg_write :std_logic;
        mux_wb : mux_wb_t;
        memory_data_len : memory_data_len_t;
        operation_sign : operation_sign_t;
    end record;

    function address_width(num_addresses: natural) return natural;
    function is_address_unaligned(
        address : word;
        data_len : memory_data_len_t
    ) return std_logic;
end package definitions;

package body definitions is
    function address_width(num_addresses: natural) return natural is
    begin
        return natural(ceil(log2(real(num_addresses))));
    end;

    function is_address_unaligned(
        address : word;
        data_len : memory_data_len_t
    ) return std_logic is
    begin
        case data_len is
            when byte =>
                return '0';
            when half_word =>
                return address(0);
            when full_word =>
                return (or address(1 downto 0));
        end case;        
    end function is_address_unaligned;
end package body definitions;
