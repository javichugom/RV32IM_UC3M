library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;
use work.instructions.all;

entity tb_bytes_organiser_write is
end tb_bytes_organiser_write;

architecture sim of tb_bytes_organiser_write is
    signal memory_address : word;
    signal memory_wdata : word;
    signal memory_data_len : memory_data_len_t;

    signal be_write : std_logic_vector(3 downto 0);
    signal memory_wdata_organised : word;
    signal unaligned_memory_waddress : std_logic;
begin
    dut: entity work.bytes_organiser_write(rtl)
        port map(
            memory_address => memory_address,
            memory_wdata => memory_wdata,
            memory_data_len => memory_data_len,
            be_write => be_write,
            memory_wdata_organised => memory_wdata_organised,
            unaligned_memory_waddress => unaligned_memory_waddress
        );

    process
        variable expected_data : word;
        variable expected_be : std_logic_vector(3 downto 0);
    begin
        memory_address <= x"00000000";
        memory_wdata <= x"00FA00FF";
        memory_data_len <= full_word;
        wait for 10 ns;
        expected_data := memory_wdata;
        assert memory_wdata_organised = expected_data
            report "Incorrect store of full word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "1111";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000002";
        memory_wdata <= x"00FA00FF";
        memory_data_len <= full_word;
        wait for 10 ns;
        assert unaligned_memory_waddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000002";
        memory_wdata <= x"00F0AF0F";
        memory_data_len <= half_word;
        wait for 10 ns;
        expected_data := x"AF0F----";
        assert memory_wdata_organised ?= expected_data 
            report "Incorrect store of half word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "1100";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000004";
        memory_wdata <= x"00F0AF0F";
        memory_data_len <= half_word;
        wait for 10 ns;
        expected_data := x"----AF0F";
        assert memory_wdata_organised ?= expected_data
            report "Incorrect store of half word" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "0011";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000007";
        memory_wdata <= x"00FA00FF";
        memory_data_len <= half_word;
        wait for 10 ns;
        assert unaligned_memory_waddress
            report "Incorrect unaligned detection";

        memory_address <= x"00000005";
        memory_wdata <= x"00FAF0FF";
        memory_data_len <= byte;
        wait for 10 ns;
        expected_data := x"----FF--";
        assert memory_wdata_organised ?= expected_data 
            report "Incorrect store of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "0010";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000006";
        memory_wdata <= x"01FAF0FF";
        memory_data_len <= byte;
        wait for 10 ns;
        expected_data := x"--FF----";
        assert memory_wdata_organised ?= expected_data 
            report "Incorrect store of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "0100";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000007";
        memory_wdata <= x"01FAF0FF";
        memory_data_len <= byte;
        wait for 10 ns;
        expected_data := x"FF------";
        assert memory_wdata_organised ?= expected_data
            report "Incorrect store of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "1000";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);

        memory_address <= x"00000008";
        memory_wdata <= x"01FAF0FF";
        memory_data_len <= byte;
        wait for 10 ns;
        expected_data := x"------FF";
        assert memory_wdata_organised ?= expected_data 
            report "Incorrect store of byte" & LF
                & ht & "expected: " & to_hstring(expected_data) & LF
                & ht & "obtained: " & to_hstring(memory_wdata_organised);
        assert not unaligned_memory_waddress
            report "Incorrect unaligned detection";
        expected_be := "0001";
        assert expected_be = expected_be
            report "Incorrect be_write" & LF
                & ht & "expected: " & to_hstring(expected_be) & LF
                & ht & "obtained: " & to_hstring(be_write);
        std.env.finish;
    end process;
end sim;

