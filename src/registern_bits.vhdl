library ieee;
use ieee.std_logic_1164.all;

entity registern_bits is
    generic(
        N : integer := 32
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        load : in std_logic;
        d : in std_logic_vector (N-1 downto 0);
        q : out std_logic_vector (N-1 downto 0)
    );
end registern_bits;

architecture rtl of registern_bits is
    signal reg : std_logic_vector (N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset then
                reg <= (others => '0');
            elsif load then
                reg <= d;
            end if;
        end if;
    end process;

    q <= reg;
end rtl;
