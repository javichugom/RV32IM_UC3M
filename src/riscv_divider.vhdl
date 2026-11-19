library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instructions.all;
use work.definitions.all;

entity riscv_divider is
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        dividend       : in  word;
        divider        : in  word;
        operation_sign : in operation_sign_t;
        valid          : in  std_logic;
        ready          : out std_logic;
        done           : out std_logic;
        quotient       : out word;
        remainder      : out word
    );
end riscv_divider;

architecture rtl of riscv_divider is
    signal sign_dividend  : std_logic;
    signal sign_divider   : std_logic;
    signal div_by_zero    : std_logic;

    signal dividend_abs   : std_logic_vector(31 downto 0);
    signal divider_abs    : std_logic_vector(31 downto 0);
    signal quotient_raw   : std_logic_vector(31 downto 0);
    signal remainder_raw  : std_logic_vector(31 downto 0);
begin
    u_divider: entity work.divider(parallel)
        port map (
            clk => clk,
            rst => rst,
            dividend => dividend_abs,
            divider  =>  divider_abs,
            valid => valid,
            ready => ready,
            done => done,
            quotient => quotient_raw,
            remainder => remainder_raw
        );

    sign_dividend <= dividend(31) when operation_sign = s else '0';
    sign_divider <= divider(31) when operation_sign = s else '0';

    div_by_zero <= '1' when divider = x"00000000" else '0';

    dividend_abs <= std_logic_vector(abs(signed(dividend))) when operation_sign = s else
                    dividend;
    divider_abs <= std_logic_vector(abs(signed(divider))) when operation_sign = s else
                   divider;  

    P_COMBINCACIONAL:
    process (all)
        variable remainder_aux : signed(31 downto 0);
        variable quotient_aux : signed(31 downto 0);
    begin
        remainder_aux := signed(remainder_raw);
        quotient_aux := signed(quotient_raw);
  
        if (sign_dividend = '1')
        then
            remainder_aux := -remainder_aux;
        end if;
  
        if  (sign_dividend /= sign_divider)
        then
            quotient_aux := -quotient_aux;
        end if;    
  
        if div_by_zero = '1'
        then
            quotient  <= x"FFFFFFFF";
            remainder <= dividend;
        elsif (dividend = x"80000000" and divider = x"FFFFFFFF" and operation_sign = s)
        then
            quotient  <= x"80000000";
            remainder <= x"00000000";
        else
            quotient  <= std_logic_vector(quotient_aux);
            remainder <= std_logic_vector(remainder_aux);
        end if;
    end process P_COMBINCACIONAL;
end rtl;
