library ieee;
use ieee.std_logic_1164.all;

use work.definitions.all;
use work.instructions.all;

entity riscv_wb is
    port (
        memory_address : in word;
        memory_rdata : in word;
        memory_data_len : memory_data_len_t;
        operation_sign : operation_sign_t;

        mux_wb : in mux_wb_t;
        alu_result : word;
        unaligned_memory_raddress : out std_logic;

        wb_value : out word
    );
end riscv_wb;

architecture rtl of riscv_wb is
    signal memory_data : word;
begin
    bytes_organiser_read_inst: entity work.bytes_organiser_read(rtl)
     port map(
        memory_address => memory_address,
        memory_rdata => memory_rdata,

        memory_data_len => memory_data_len,
        operation_sign => operation_sign,

        memory_rdata_organised => memory_data,
        unaligned_memory_raddress => unaligned_memory_raddress
    );

    with mux_wb select
    wb_value <= alu_result when alu_res,
                memory_data when mem;
end rtl;
