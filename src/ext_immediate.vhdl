library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;

entity ext_immediate is
    port(
        instr   : in word; 
        imm_ext : out word
    );
end ext_immediate;

architecture rtl of ext_immediate is
    type immediate_t is (none, i, s, b, u, j);

    signal sign : std_logic;
    signal imm_sel : immediate_t;
    signal opcode : std_logic_vector (4 downto 0);
begin

    opcode <= instr(6 downto 2);
    
    with opcode select
    imm_sel <=
        none when "01100",
        i when "00100" | "00000" | "11001",
        s when "01000",
        b when "11000",
        u when "01101" | "00101",
        j when "11011",
        none when others;
 
    sign <= instr(31);
 
    with imm_sel select
    imm_ext <=
        (
            31 downto 12 => sign,
            11 downto 0 => instr(31 downto 20)
        ) when i,
        (
            31 downto 12 => sign,
            11 downto 5 => instr(31 downto 25),
            4 downto 0 => instr(11 downto 7)
        ) when s,
        (
            31 downto 13 => sign,
            12 => instr(31),
            11 => instr(7),
            10 downto 5 => instr(30 downto 25),
            4 downto 1 => instr(11 downto 8),
            0 => '0'
        ) when b,
        (
            31 downto 21 => sign,
            20 => instr(31),
            19 downto 12 => instr(19 downto 12),
            11 => instr(20),
            10 downto 1 => instr(30 downto 21),
            0 => '0'
        ) when j,
        (
            31 downto 12 => instr(31 downto 12),
            11 downto 0 => '0'
        ) when u,
        (
            others => '0'
        ) when none;            
    
end rtl ;
