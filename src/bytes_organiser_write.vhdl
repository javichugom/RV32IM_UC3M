library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.memory_data_len_t;
use work.instructions.operation_sign_t;

entity bytes_organiser_write is
    port (
        memory_address : in word;
        memory_wdata : in word;
        memory_data_len : in memory_data_len_t;

        be_write : out std_logic_vector(3 downto 0);
        memory_wdata_organised : out word;
        unaligned_memory_waddress : out std_logic
    );
end bytes_organiser_write;

architecture rtl of bytes_organiser_write is
    signal wdata_byte : word;
    signal wdata_half_word : word;
begin
    with memory_data_len select
    memory_wdata_organised <= memory_wdata when full_word,
                              wdata_half_word when half_word,
                              wdata_byte when byte;

    unaligned_memory_waddress <= is_address_unaligned(memory_address, memory_data_len);

    process(all)
    begin
        case memory_data_len is
            when byte =>
                with memory_address(1 downto 0) select
                be_write <= "0001" when "00",
                            "0010" when "01",
                            "0100" when "10",
                            "1000" when "11",
                            (others => 'X') when others;
            when half_word =>
                with memory_address(1) select?
                be_write <= "0011" when '0',
                            "1100" when '1',
                            (others => 'X') when others;
                            
            when full_word =>
                be_write <= "1111";
        end case;
    end process;

    with memory_address(1) select
    wdata_half_word <= memory_wdata when '0',
                       std_logic_vector(
                           shift_left(unsigned(memory_wdata), 16)
                       ) when '1',
                       (others => 'X') when others;

    with memory_address(0) select
    wdata_byte <= wdata_half_word when '0',
                  std_logic_vector(
                      shift_left(unsigned(wdata_half_word), 8)
                  ) when '1',
                  (others => 'X') when others;
end architecture rtl;
