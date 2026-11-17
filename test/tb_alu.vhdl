library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.definitions.all;
use work.instructions.all;

entity tb_alu is
    generic (
        CHECK_FLAGS_ALL_OPS : boolean := false
    );
end tb_alu;

architecture sim of tb_alu is
    signal a, b          : word := (others => '0');
    signal alu_operation : alu_operation_t := add;
    signal operation_sign : operation_sign_t;
    signal result        : word;
    signal f_eq          : std_logic;
    signal f_lt          : std_logic;
    signal f_lt_u        : std_logic;

begin

    dut : entity work.alu(rtl)
        port map (
            a             => a,
            b             => b,
            alu_operation => alu_operation,
            operation_sign => operation_sign,
            result        => result,
            f_eq          => f_eq,
            f_lt          => f_lt,
            f_lt_u        => f_lt_u
        );

    stim : process

        variable errors : integer := 0;

        procedure check (
            constant a_v  : in word;
            constant b_v  : in word;
            constant op_v : in alu_operation_t;
            constant op_s : in operation_sign_t;
            constant name : in string) is

            variable exp_res : word;
            variable exp_eq  : std_logic;
            variable exp_lt  : std_logic;
            variable exp_ltu : std_logic;
            variable sh      : integer range 0 to 31;
            variable do_flags : boolean;
        begin
            a             <= a_v;
            b             <= b_v;
            alu_operation <= op_v;
            operation_sign <= op_s;
            wait for 10 ns;

            sh := to_integer(unsigned(b_v(4 downto 0)));

            if a_v = b_v then exp_eq := '1'; else exp_eq := '0'; end if;
            if signed(a_v)   < signed(b_v)   then exp_lt  := '1'; else exp_lt  := '0'; end if;
            if unsigned(a_v) < unsigned(b_v) then exp_ltu := '1'; else exp_ltu := '0'; end if;

            exp_res :=
               std_logic_vector(unsigned(a_v) + unsigned(b_v)) when op_v = add else 
               std_logic_vector(unsigned(a_v) - unsigned(b_v)) when op_v = sub else 
               a_v and b_v when op_v = alu_and else 
               a_v or b_v when op_v = alu_or else 
               a_v xor b_v when op_v = alu_xor else 
               std_logic_vector(shift_left (unsigned(a_v), sh)) when op_v = s_left else 
               std_logic_vector(shift_right(unsigned(a_v), sh)) when op_v = s_right_l else 
               std_logic_vector(shift_right(signed(a_v),   sh)) when op_v = s_right_a else 
               (0 => exp_lt,  others => '0') when op_v = slt and op_s = s else 
               (0 => exp_ltu, others => '0') when op_v = slt and op_s = u else 
               b_v when op_v = lui else 
               (others => '0');

            if result /= exp_res then
                report name & ": wrong result" severity error;
                errors := errors + 1;
            end if;

            do_flags := CHECK_FLAGS_ALL_OPS or (op_v = sub);
            if do_flags then
                if f_eq /= exp_eq then
                    report name & ": wrong f_eq" severity error;
                    errors := errors + 1;
                end if;
                if f_lt /= exp_lt then
                    report name & ": wrong f_lt" severity error;
                    errors := errors + 1;
                end if;
                if f_lt_u /= exp_ltu then
                    report name & ": wrong f_lt_u" severity error;
                    errors := errors + 1;
                end if;
            end if;
        end procedure;

    begin

        -- ADD
        check(x"00000005", x"00000003", add, s, "ADD basic");
        check(x"FFFFFFFF", x"00000001", add, s, "ADD wraps to 0");
        check(x"7FFFFFFF", x"00000001", add, s, "ADD signed overflow");
        check(x"80000000", x"80000000", add, s, "ADD MSB+MSB");
        check(x"00000000", x"00000000", add, s, "ADD zero");

        -- SUB (also checks the flags, used by branches)
        check(x"00000005", x"00000005", sub, s, "SUB equal");
        check(x"00000003", x"00000005", sub, s, "SUB 3-5");
        check(x"00000005", x"00000003", sub, s, "SUB 5-3");
        check(x"00000000", x"00000001", sub, s, "SUB 0-1");
        check(x"80000000", x"00000001", sub, s, "SUB signed underflow");
        check(x"FFFFFFFF", x"00000001", sub, s, "SUB -1 vs 1");
        check(x"00000001", x"FFFFFFFF", sub, s, "SUB 1 vs -1");
        check(x"80000000", x"7FFFFFFF", sub, s, "SUB MIN vs MAX");
        check(x"7FFFFFFF", x"80000000", sub, s, "SUB MAX vs MIN");
        check(x"FFFFFFFE", x"FFFFFFFF", sub, s, "SUB -2 vs -1");
        check(x"00000000", x"00000000", sub, s, "SUB 0 vs 0");

        -- Logic
        check(x"0F0F0F0F", x"00FF00FF", alu_and, s, "AND");
        check(x"FFFFFFFF", x"80000000", alu_and, s, "AND MSB");
        check(x"0F0F0F0F", x"00FF00FF", alu_or,  s, "OR");
        check(x"80000000", x"00000001", alu_or,  s, "OR extremes");
        check(x"0F0F0F0F", x"00FF00FF", alu_xor, s, "XOR");
        check(x"FFFFFFFF", x"FFFFFFFF", alu_xor, s, "XOR equal");

        -- Shifts
        check(x"00000001", x"00000002", s_left, s, "SLL 2");
        check(x"00000001", x"0000001F", s_left, s, "SLL 31");
        check(x"FFFFFFFF", x"00000000", s_left, s, "SLL 0");
        check(x"FFFFFFFF", x"00000020", s_left, s, "SLL shamt uses 5 bits (32 -> 0)");
        check(x"80000001", x"00000001", s_left, s, "SLL drops MSB");

        check(x"00000004", x"00000001", s_right_l, s, "SRL 1");
        check(x"80000000", x"0000001F", s_right_l, s, "SRL 31");
        check(x"FFFFFFF8", x"00000001", s_right_l, s, "SRL negative fills with 0");
        check(x"FFFFFFFF", x"00000000", s_right_l, s, "SRL 0");

        check(x"FFFFFFF8", x"00000001", s_right_a, s, "SRA -8>>1");
        check(x"80000000", x"0000001F", s_right_a, s, "SRA 31 negative");
        check(x"7FFFFFFF", x"0000001F", s_right_a, s, "SRA 31 positive");
        check(x"40000000", x"00000004", s_right_a, s, "SRA positive");
        check(x"FFFFFFFF", x"00000000", s_right_a, s, "SRA 0");

        -- SLT (signed)
        check(x"00000003", x"00000005", slt, s, "SLT 3<5");
        check(x"00000005", x"00000003", slt, s, "SLT 5<3");
        check(x"00000005", x"00000005", slt, s, "SLT equal");
        check(x"FFFFFFFF", x"00000001", slt, s, "SLT -1<1");
        check(x"00000001", x"FFFFFFFF", slt, s, "SLT 1<-1");
        check(x"80000000", x"7FFFFFFF", slt, s, "SLT MIN<MAX");
        check(x"7FFFFFFF", x"80000000", slt, s, "SLT MAX<MIN");
        check(x"FFFFFFFE", x"FFFFFFFF", slt, s, "SLT -2<-1");

        -- SLTU (unsigneud)
        check(x"00000003", x"00000005", slt, u, "SLTU 3<5");
        check(x"00000005", x"00000003", slt, u, "SLTU 5<3");
        check(x"00000005", x"00000005", slt, u, "SLTU equal");
        check(x"FFFFFFFF", x"00000001", slt, u, "SLTU 0xFFFFFFFF<1");
        check(x"00000001", x"FFFFFFFF", slt, u, "SLTU 1<0xFFFFFFFF");
        check(x"80000000", x"7FFFFFFF", slt, u, "SLTU 0x80000000<0x7FFFFFFF");
        check(x"7FFFFFFF", x"80000000", slt, u, "SLTU 0x7FFFFFFF<0x80000000");

        -- LUI
        check(x"12345678", x"ABCDE000", lui, s, "LUI passes b");
        check(x"FFFFFFFF", x"00000000", lui, s, "LUI zero");

        if errors = 0 then
            report "ALL TESTS PASS" severity note;
        else
            report "FAILED CHECKS: " & integer'image(errors) severity failure;
        end if;

        std.env.finish;
    end process;
end sim;
