library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.all;

entity alu is
    port(
        a : in word;
        b : in word;
        alu_operation : in alu_operation_t;
        result : out word;
        f_eq : out std_logic;
        f_lt : out std_logic;
        f_lt_u : out std_logic
    );
end alu;

architecture rtl of alu is
    signal result_extended : std_logic_vector (32 downto 0);

    signal shamt : integer range 0 to 31;
    signal a_extended : std_logic_vector(32 downto 0);
    signal b_extended : std_logic_vector(32 downto 0);
begin
    shamt <= to_integer(unsigned(b(4 downto 0)));
    a_extended <= '0' & a;
    b_extended <= '0' & b;

    with alu_operation select
    result_extended <=
        std_logic_vector(signed(a_extended) + signed(b_extended))   when add,
        std_logic_vector(signed(a_extended) - signed(b_extended))   when sub | slt | sltu,
        a_extended and b_extended                                   when alu_and,
        (a_extended or b_extended)                                  when alu_or,
        (a_extended xor b_extended)                                 when alu_xor,
        std_logic_vector(shift_left (unsigned(a_extended), shamt))  when s_left,
        std_logic_vector(shift_right(unsigned(a_extended), shamt))  when s_right_l,
        std_logic_vector(shift_right(  signed(a_extended), shamt))  when s_right_a,
        b_extended                                                  when lui;
        
    with alu_operation select
    result <=
        (0 => f_lt, others => '0') when slt,
        (0 => f_lt_u, others => '0') when sltu,
        result_extended(31 downto 0) when others;
    
    f_eq <= nor result;
    f_lt <= result(31) when (a(31) = b(31)) else a(31);    
    f_lt_u <= result_extended(32);                
end rtl;
