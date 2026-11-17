library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.all;

entity tb_bytes_organiser_read is
end tb_bytes_organiser_read;

architecture sim of tb_bytes_organiser_read is
    signal memory_address : word;
    signal memory_rdata : word;
    signal memory_data_len : memory_data_len_t;

    signal operation_sign : operation_sign_t;

    signal memory_rdata_organised : word;
    signal unaligned_memory_raddress : std_logic;
begin
    dut: entity work.bytes_organiser_read(rtl)
     port map(
        memory_address => memory_address,
        memory_rdata => memory_rdata,
        memory_data_len => memory_data_len,
        operation_sign => operation_sign,
        memory_rdata_organised => memory_rdata_organised,
        unaligned_memory_raddress => unaligned_memory_raddress
    );

    process
        variable expected_data : word;
    begin
        memory_address <= x"00000000";
        memory_rdata <= x"00FA00FF";
        memory_data_len <= full_word;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := memory_rdata;
        assert memory_rdata_organised = expected_data
            report "Incorrect load of full word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000002";
        memory_rdata <= x"00FA00FF";
        memory_data_len <= full_word;
        operation_sign <= s;
        wait for 10 ns;
        assert unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000002";
        memory_rdata <= x"00FAF00F";
        memory_data_len <= half_word;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := x"000000FA";
        assert memory_rdata_organised = expected_data 
            report "Incorrect load of half word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000004";
        memory_rdata <= x"01FAF0FF";
        memory_data_len <= half_word;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := x"FFFFF0FF";
        assert memory_rdata_organised = expected_data
            report "Incorrect load of half word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000007";
        memory_rdata <= x"00FA00FF";
        memory_data_len <= half_word;
        operation_sign <= s;
        wait for 10 ns;
        assert unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000005";
        memory_rdata <= x"00FAF0FF";
        memory_data_len <= byte;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := x"FFFFFFF0";
        assert memory_rdata_organised = expected_data 
            report "Incorrect load of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000006";
        memory_rdata <= x"01FAF0FF";
        memory_data_len <= byte;
        operation_sign <= u;
        wait for 10 ns;
        expected_data := x"000000FA";
        assert memory_rdata_organised = expected_data 
            report "Incorrect load of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000007";
        memory_rdata <= x"01FAF0FF";
        memory_data_len <= byte;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := x"00000001";
        assert memory_rdata_organised = expected_data
            report "Incorrect load of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000008";
        memory_rdata <= x"01FAF04F";
        memory_data_len <= byte;
        operation_sign <= s;
        wait for 10 ns;
        expected_data := x"0000004F";
        assert memory_rdata_organised = expected_data 
            report "Incorrect load of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_rdata_organised);
        assert not unaligned_memory_raddress
            report "Incorrect unaligned detection";
        std.env.finish;
    end process;
end sim;

