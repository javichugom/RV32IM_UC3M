library ieee;
use ieee.std_logic_1164.all;

entity stage_register is
    generic (
        type stage_output_t;
        constant reset_value : stage_output_t
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        stall : in std_logic;

        stage_output_i : in stage_output_t;
        stage_output_o : out stage_output_t
    );
end stage_register;

architecture rtl of stage_register is
    signal data : stage_output_t;
begin
    process(clk)
    begin
        if rising_edge(clk)
        then
            data <= reset_value when rst else
                    data        when stall else
                    stage_output_i;
        end if;
    end process;

    stage_output_o <= data;
end rtl;
