library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ALU is
    generic (
        bit_depth : integer := 32
    );
    port (
        result  : out std_logic_vector(bit_depth - 1 downto 0);
        Error   : out std_logic;
        A       : in std_logic_vector(bit_depth - 1 downto 0);
        B       : in std_logic_vector(bit_depth - 1 downto 0);
        Opcode  : in std_logic_vector(3 downto 0)
    );
end ALU;

architecture behavioral of ALU is
    signal temp_result : std_logic_vector(bit_depth - 1 downto 0);
begin
    process (A, B, Opcode)
    begin
        Error <= '0';  -- Initialize error signal

        case Opcode is
            when "0000" =>
                -- OpCode 0: Not A
                for i in 0 to bit_depth - 1 loop
                    temp_result(i) <= not A(i);
                end loop;

            when "0001" =>
                -- OpCode 1: Not B
                for i in 0 to bit_depth - 1 loop
                    temp_result(i) <= not B(i);
                end loop;

            when "0010" =>
                -- OpCode 2: A + B
                temp_result <= std_logic_vector(unsigned(A) + unsigned(B));

            when "0011" =>
                -- OpCode 3: A - B
                temp_result <= std_logic_vector(unsigned(A) - unsigned(B));

            when "0100" =>
                -- OpCode 4: Shift A left by 1 (multiply by 2)
                temp_result(0) <= '0';
                for i in 1 to bit_depth - 1 loop
                    temp_result(i) <= A(i - 1);
                end loop;

            when "0101" =>
                -- OpCode 5: Sign shift A right by 2 bits (divide by 4)
                if A(bit_depth - 1) = '1' then
                    temp_result(bit_depth - 1 downto 2) <= A(bit_depth - 3 downto 0);
                    temp_result(1 downto 0) <= "00";
                else
                    temp_result <= (others => 'X');
                end if;

            when "0110" =>
                -- OpCode 6: Shift B right by 1 (multiply by 2)
                temp_result(bit_depth - 1) <= '0';
                for i in 0 to bit_depth - 2 loop
                    temp_result(i) <= B(i + 1);
                end loop;

            when "0111" =>
                -- OpCode 7: Sign shift B right by 2 bits (divide by 4)
                if B(bit_depth - 1) = '1' then
                    temp_result(bit_depth - 3 downto 0) <= B(bit_depth - 2 downto 1);
                    temp_result(1 downto 0) <= "00";
                else
                    temp_result <= (others => 'X');
                end if;

            when "1000" =>
                -- OpCode 8: Flip the bits of A
                for i in 0 to bit_depth - 1 loop
                    temp_result(i) <= not A(i);
                end loop;

            when "1001" =>
                -- OpCode 9: Flip the bits of B
                for i in 0 to bit_depth - 1 loop
                    temp_result(i) <= not B(i);
                end loop;

            when "1010" =>
                -- OpCode 10: A AND B
                temp_result <= A and B;

            when "1011" =>
                -- OpCode 11: A OR B
                temp_result <= A or B;

            when others =>
                -- OpCode 12: ERROR
                Error <= '1';
                temp_result <= (others => 'X');  -- Set result to 'X' for error
        end case;

        result <= temp_result;
    end process;
end behavioral;
