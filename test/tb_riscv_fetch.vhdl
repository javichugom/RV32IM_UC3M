library ieee;
use ieee.std_logic_1164.all;

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

    signal pc          : word;

    signal addr_inst   : word;
    signal wdata_inst  : word;
    signal rdata_inst  : word;
    signal we_inst     : std_logic;
    signal be_inst     : std_logic_vector(3 downto 0);

    signal branch      : std_logic;
    signal branch_operand1 : word;
    signal branch_operand2 : word;

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
            branch      => branch,
            operand1    => branch_operand1,
            operand2    => branch_operand2,
            pc => pc,
            instruction => instruction
        );

    -- Reloj
    clk <= not clk after CLK_PERIOD / 2;


    ---------------------------------------------------------------------------
    -- Estimulos y comprobaciones
    ---------------------------------------------------------------------------
    stim : process
        variable expected_address : word;
        variable expected_pc : word;
    begin
        report "TEST 1: reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '0';
        branch_operand1 <= x"BC000000";
        branch_operand2 <= x"0000009A";
        branch <= '0';
        tick;

        expected_address := x"00000000";
        assert addr_inst = expected_address
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 2: deasert reset" severity note;
        rst <= '0';
        rdata_inst <= NOP;
        stall <= '0';
        branch_operand1 <= x"BC000000";
        branch_operand2 <= x"0000009A";
        branch <= '0';
        wait for 1 ns;

        expected_address := x"00000004";
        assert addr_inst = expected_address
            report "Incorrect address after reset" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00000000";
        assert pc = expected_pc
            report "Incorrect pc after reset" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 3: advance clock" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"00078000";
        branch_operand2 <= x"00056000";
        branch <= '0';
        tick;

        expected_address := x"00000008";
        assert addr_inst = expected_address
            report "Incorrect address" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00000004";
        assert pc = expected_pc
            report "Incorrect pc" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 4: advance clock again" severity note;
        rst <= '0';
        rdata_inst <= NOP;
        stall <= '0';
        branch_operand1 <= x"00120000";
        branch_operand2 <= x"00034000";
        branch <= '0';
        tick;

        expected_address := x"0000000C";
        assert addr_inst = expected_address
            report "Incorrect address" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00000008";
        assert pc = expected_pc
            report "Incorrect pc" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 5: stall" severity note;
        rst <= '0';
        rdata_inst <= NOP;
        stall <= '1';
        branch_operand1 <= x"00AE0000";
        branch_operand2<= x"0000DC00";
        branch <= '0';
        tick;

        expected_address := x"0000000C";
        assert addr_inst = expected_address
            report "Incorrect address after stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00000008";
        assert pc = expected_pc
            report "Incorrect pc" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 6: stall and reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '1';
        branch_operand1 <= x"00000EE0";
        branch_operand2 <= x"00008500";
        branch <= '0';
        tick;

        expected_address := x"00000000";
        assert addr_inst = expected_address
            report "Incorrect address after reset and stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 7: branch" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"00F00000";
        branch_operand2 <= x"00000AE4";
        branch <= '1';
        tick;

        expected_address := x"00F00AE4";
        assert addr_inst = expected_address
            report "Incorrect address after branch" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 8: branch and stall" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '1';
        branch_operand1 <= x"04680000";
        branch_operand2 <= x"0007579A";
        branch <= '1';
        tick;

        expected_address := x"046F579A";
        assert addr_inst = expected_address
            report "Incorrect address after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00F00AE4";
        assert pc = expected_pc
            report "Incorrect pc after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 9: deasert stall after branch" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"00007460";
        branch_operand2 <= x"0007579A";
        branch <= '0';
        wait for 1 ns;

        expected_address := x"00F00AE8";
        assert addr_inst = expected_address
            report "Incorrect address after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00F00AE4";
        assert pc = expected_pc
            report "Incorrect pc after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 10: advance clock after stall" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"00007460";
        branch_operand2 <= x"0007579A";
        branch <= '0';
        tick;

        expected_address := x"00F00AEC";
        assert addr_inst = expected_address
            report "Incorrect address after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00F00AE8";
        assert pc = expected_pc
            report "Incorrect pc after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 11: branch again" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"AA000001";
        branch_operand2 <= x"0007579A";
        branch <= '1';
        tick;

        expected_address := x"AA07579A";
        assert addr_inst = expected_address
            report "Incorrect address after branch and stall" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);

        report "TEST 12: branch and reset" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '0';
        branch_operand1 <= x"00000047";
        branch_operand2 <= x"00000759";
        branch <= '1';
        tick;

        expected_address := x"00000000";
        assert addr_inst = expected_address
            report "Incorrect address after branch and reset" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 13: advance clock" severity note;
        rst <= '0';
        rdata_inst <= SUB;
        stall <= '0';
        branch_operand1 <= x"00000360";
        branch_operand2 <= x"00054000";
        branch <= '0';
        tick;

        expected_address := x"00000008";
        assert addr_inst = expected_address
            report "Incorrect address" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        expected_pc := x"00000004";
        assert pc = expected_pc
            report "Incorrect pc" & LF
            & ht & "expected: " & to_hstring(expected_pc) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);


        report "TEST 14: reset, stall and branch" severity note;
        rst <= '1';
        rdata_inst <= NOP;
        stall <= '1';
        branch_operand1 <= x"05400000";
        branch_operand2 <= x"00084000";
        branch <= '1';
        tick;

        expected_address := x"00000000";
        assert addr_inst = expected_address
            report "Incorrect address after reset, stall and branch" & LF
            & ht & "expected: " & to_hstring(expected_address) & LF
            & ht & "obtained: " & to_hstring(addr_inst);
        assert we_inst = '0'
            report "Incorrect write enable. It should always be low" & LF
            & ht & "expected: " & to_string(std_logic'('0')) & LF
            & ht & "obtained: " & to_string(we_inst);
        assert be_inst= "1111"
            report "Incorrect byte enable" & LF
            & ht & "expected: " & to_string(std_logic_vector'("1111")) & LF
            & ht & "obtained: " & to_string(be_inst);
        assert instruction = rdata_inst
            report "Incorrect instruction" & LF
            & ht & "expected: " & to_hstring(rdata_inst) & LF
            & ht & "obtained: " & to_hstring(instruction);

        std.env.finish;
    end process;
end sim;
