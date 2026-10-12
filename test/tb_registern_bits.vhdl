library ieee;
use ieee.std_logic_1164.all;

entity tb_registern_bits is
end tb_registern_bits; 

architecture sim of tb_registern_bits is
    constant N : integer := 32;
    constant ZERO : std_logic_vector(N-1 downto 0) := (others => '0');

    signal d : STD_LOGIC_vector (N-1 downto 0) := (others => '0');
    signal clk : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal q : STD_LOGIC_vector (N-1 downto 0);
    signal reset : std_logic := '0';

    procedure tick is
    begin
        wait until rising_edge(clk);
        wait for 1 ns;
    end procedure;
begin
    dut : entity work.registern_bits
        generic map (
            N => N
        )
        port map (
            d => d,
            clk => clk,
            load => load,
            q => q,
            reset => reset
        );
        
    clk <= not clk after 5 ns;
    
    reg_sim : process
    begin
    
        reset <= '1';
        tick;
        assert q = ZERO report "Mismatch for Q: Q isn't 0" severity error; 

        reset <= '0';
        wait until rising_edge(clk);
        
        load <= '1'; 
        d <= x"abc04f31";
        tick;
        assert q = x"abc04f31" report "Mismatch for Q: register isn't loaded when Load=1" severity error; 

        load <= '0'; 
        d <= x"11111111";
        tick;
        assert q = x"abc04f31" report "Mismatch for Q: register loads when Load=0" severity error;

        d <= x"22222222";
        tick;
        assert q = x"abc04f31" report "Mismatch for Q: register loads without Load" severity error;

        reset <= '1';
        tick;
        assert q = ZERO report "Mismatch for reset" severity error;
        
        reset <= '0';
        wait until rising_edge(clk);
        
        load <= '1';
        d <= x"abc04f31";
        tick;
        assert q = x"abc04f31" report "Error 1" severity error;
        
        d <= x"abc04f32";
        tick;
        assert Q = x"abc04f32" report "Error 2" severity error;
        
        d <= x"abc04f33";
        tick;
        assert q = x"abc04f33" report "Error 3" severity error;
        
        report "Test finished OK" severity note; 
        
        std.env.finish;
    end process;
end sim;
