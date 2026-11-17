library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.memory_data_len_t;
use work.instructions.operation_sign_t;

entity bytes_organiser_read is
    port (
        memory_address : in word;
        memory_rdata : in word;
        memory_data_len : in memory_data_len_t;

        operation_sign : in operation_sign_t;

        memory_rdata_organised : out word;
        unaligned_memory_raddress : out std_logic
    );
end bytes_organiser_read;

architecture rtl of bytes_organiser_read is
    signal rdata_byte : std_logic_vector(7 downto 0);
    signal rdata_half_word : std_logic_vector(15 downto 0);

    function need_sign_extension(
        operation_sign : operation_sign_t
    ) return std_logic is
    begin
        case operation_sign is
            when s =>
                return '1';
            when u =>
                return '0';
        end case;
        
    end function need_sign_extension;
begin
    with memory_data_len select
    memory_rdata_organised <= memory_rdata when full_word,
                              (
                                  15 downto 0 => rdata_half_word,
                                  31 downto 16 => rdata_half_word(15) and need_sign_extension(operation_sign)
                              ) when half_word,
                              (
                                  7 downto 0 => rdata_byte,
                                  31 downto 8 => rdata_byte(7) and need_sign_extension(operation_sign)
                              ) when byte;

    unaligned_memory_raddress <= is_address_unaligned(memory_address, memory_data_len);

    with memory_address(1) select
    rdata_half_word <= memory_rdata(15 downto 0) when '0',
                       memory_rdata(31 downto 16) when '1',
                       memory_rdata(15 downto 0) when others;

    with memory_address(0) select
    rdata_byte <= rdata_half_word(7 downto 0) when '0',
                  rdata_half_word(15 downto 8) when '1',
                  (others => 'X') when others;
end architecture rtl;
