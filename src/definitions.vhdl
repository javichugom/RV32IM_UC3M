library ieee;
use ieee.std_logic_1164.all;

package definitions is
    constant WORD_LENGTH : natural := 32;
    subtype word is std_logic_vector(WORD_LENGTH - 1 downto 0); 
end package definitions;
