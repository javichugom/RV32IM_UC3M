library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.definitions.all;

entity tb_riscv_fetch is
end tb_riscv_fetch;

architecture sim of tb_riscv_fetch is
    constant CLK_PERIOD : time := 10 ns;
    constant NOP        : word := x"00000013";
    constant SUB        : word := x"40000033";

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal stall       : std_logic := '0';

    signal addr_inst   : word;
    signal wdata_inst  : word;
    signal rdata_inst  : word;
    signal we_inst     : std_logic;
    signal be_inst     : std_logic_vector(3 downto 0);

    signal branch_e    : std_logic := '0';
    signal branch_addr : word := (others => '0');

    signal instruction : word;

    procedure tick is
    begin
        wait until rising_edge(clk);
        wait for 1 ns;
    end procedure;
begin

    ---------------------------------------------------------------------------
    -- DUT
    ---------------------------------------------------------------------------
    dut : entity work.riscv_fetch(rtl)
        port map (
            clk         => clk,
            rst         => rst,
            stall       => stall,
            addr_inst   => addr_inst,
            wdata_inst  => wdata_inst,
            rdata_inst  => rdata_inst,
            we_inst     => we_inst,
            be_inst     => be_inst,
            branch_e    => branch_e,
            branch_addr => branch_addr,
            instruction => instruction
        );

    -- Reloj
    clk <= not clk after CLK_PERIOD / 2;


    ---------------------------------------------------------------------------
    -- Estimulos y comprobaciones
    ---------------------------------------------------------------------------
    stim : process
        variable expected_pc : word;
    begin
        report "TEST 1: reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '0';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000000";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 2: advance clock" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000004";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 3: advance clock again" severity note;
        rst <= '0';
        rdata_inst <= NOP;
        stall <= '0';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000008";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 4: stall" severity note;
        rst <= '0';
        rdata_inst <= NOP;
        stall <= '1';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000008";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 5: stall and reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '1';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000000";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 6: branch" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_e <= '1';
        branch_addr <= x"22222220";
        tick;

        expected_pc := branch_addr;
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 7: branch and stall" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '1';
        branch_e <= '1';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"22222220";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 8: branch and reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '0';
        branch_e <= '1';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000000";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 9: advance clock" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_e <= '0';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000004";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 10: reset, stall and branch" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '1';
        branch_e <= '1';
        branch_addr <= x"FFFFFFF0";
        tick;

        expected_pc := x"00000000";
        assert addr_inst = expected_pc
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It shoudl always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);

        std.env.finish;
    end process;
end sim;
