library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;

entity tb_stage_register is
end tb_stage_register;

architecture sim of tb_stage_register is
    constant CLK_PERIOD : time := 10 ns;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal stall       : std_logic := '0';

    signal data_in  : std_logic;
    signal data_out : std_logic;

    procedure tick is
    begin
        wait until rising_edge(clk);
        wait for 1 ns;
    end procedure;
begin
    ---------------------------------------------------------------------------
    -- DUT
    ---------------------------------------------------------------------------
    dut : entity work.stage_register(rtl)
        generic map (
            stage_output_t => std_logic,
            reset_value => '0'
        )
        port map (
            clk         => clk,
            rst         => rst,
            stall       => stall,
            stage_output_i => data_in,
            stage_output_o => data_out
        );

    -- Reloj
    clk <= not clk after CLK_PERIOD / 2;

    ---------------------------------------------------------------------------
    -- Estimulos y comprobaciones
    ---------------------------------------------------------------------------
    stim : process
    begin
        report "TEST 1: reset" severity note;
        rst <= '1';
        stall <= '0';
        tick;

        assert data_out = '0'
            report "Incorrect data_out after reset" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(data_out);

        report "TEST 2: write data" severity note;
        rst <= '0';
        stall <= '0';
        data_in <= '1';
        tick;

        assert data_out = data_in
            report "Incorrect data_out" & LF
            & ht & "expected: " & to_string(data_in) & LF
            & ht & "obtained: " & to_string(data_out);

        report "TEST 3: write data again" severity note;
        rst <= '0';
        stall <= '0';
        data_in <= '0';
        tick;

        assert data_out = data_in
            report "Incorrect data_out" & LF
            & ht & "expected: " & to_string(data_in) & LF
            & ht & "obtained: " & to_string(data_out);

        report "TEST 4: stall" severity note;
        rst <= '0';
        stall <= '1';
        data_in <= '1';
        tick;

        assert data_out = data_in
            report "Incorrect data_out after stall" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(data_out);

        rst <= '0';
        stall <= '0';
        data_in <= '1';
        tick;

        report "TEST 5: stall and reset" severity note;
        rst <= '1';
        stall <= '1';
        data_in <= '1';
        tick;

        assert data_out = data_in
            report "Incorrect data_out after reset and stall" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(data_out);

        report "TEST 6: write data" severity note;
        rst <= '0';
        stall <= '0';
        data_in <= '1';
        tick;

        assert data_out = data_in
            report "Incorrect data_out" & LF
            & ht & "expected: " & to_string(data_in) & LF
            & ht & "obtained: " & to_string(data_out);

        std.env.finish;
    end process;
end sim;
