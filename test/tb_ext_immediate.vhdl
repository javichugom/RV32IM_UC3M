library ieee;
use ieee.std_logic_1164.all;

entity tb_ext_immediate is
end tb_ext_immediate;

architecture sim of tb_ext_immediate is
    signal instr   : std_logic_vector(31 downto 0) := (others => '0');
    signal imm_ext : std_logic_vector(31 downto 0) := (others => '0');
    
begin

    dut : entity work.ext_immediate
        port map (
            instr   => instr,
            imm_ext => imm_ext
        );
        
    stim : process
    begin
    
        instr   <= x"FFF00000";
        wait for 10 ns;
        assert imm_ext = x"FFFFFFFF"
            report "I-type negativo FAILED"
            severity error;
            
        instr   <= x"01400000";
        wait for 10 ns;
        assert imm_ext = x"00000014"
            report "I-type positivo FAILED"
            severity error;
            
        instr   <= x"00F507A3";
        wait for 10 ns;
        assert imm_ext = x"0000000F"
            report "S-type positivo FAILED"
            severity error;
            
        instr   <= x"FE000823";
        wait for 10 ns;
        assert imm_ext = x"FFFFFFF0"
            report "S-type negativo FAILED"
            severity error;
            
        instr   <= x"00000263";
        wait for 10 ns;
        assert imm_ext = x"00000004"
            report "B-type positivo FAILED"
            severity error;
        assert imm_ext(0) = '0'
            report "B-type LSB no es 0" severity error;
            
        instr   <= x"80000063";
        wait for 10 ns;
        assert imm_ext = x"FFFFF000"
            report "B-type negativo FAILED"
            severity error;
            
        instr   <= x"12345037";
        wait for 10 ns;
        assert imm_ext = x"12345000"
            report "U-type FAILED"
            severity error;
            
        instr   <= x"FFFFF037";
        wait for 10 ns;
        assert imm_ext = x"FFFFF000"
            report "U-type negativo FAILED"
            severity error;
            
        instr   <= x"004000EF";
        wait for 10 ns;
        assert imm_ext = x"00000004"
            report "J-type positivo FAILED"
            severity error;
        assert imm_ext(0) = '0'
            report "J-type LSB no es 0" severity error;
            
        instr   <= x"8000006F";
        wait for 10 ns;
        assert imm_ext = x"FFF00000"
            report "J-type negativo FAILED"
            severity error;
            
        instr   <= x"FFFFFFFF";
        wait for 10 ns;
        assert imm_ext = x"00000000"
            report "Default FAILED"
            severity error;
        report "Todos los tests ext_inm pasaron correctamente." severity note;
        std.env.finish;
    end process;
end sim;
