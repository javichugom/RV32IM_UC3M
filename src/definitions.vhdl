library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

package definitions is
    constant WORD_LENGTH : natural := 32;
    subtype word is std_logic_vector(WORD_LENGTH - 1 downto 0); 

    function address_width(num_addresses: natural) return natural;
end package definitions;

package body definitions is
    function address_width(num_addresses: natural) return natural is
    begin
        return natural(ceil(log2(real(num_addresses))));
    end;
end package body definitions;
