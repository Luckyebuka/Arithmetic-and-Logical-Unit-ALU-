library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ALU is
    generic (
        bit_depth : integer := 32
    );
    port (
        result  : out std_logic_vector(bit_depth-1 downto 0);
        Error   : out std_logic;
        A       : in std_logic_vector(bit_depth-1 downto 0);
        B       : in std_logic_vector(bit_depth-1 downto 0);
        Opcode  : in std_logic_vector(3 downto 0)
    );
end ALU;

architecture behavioral of ALU is
    signal temp_result : std_logic_vector(bit_depth-1 downto 0);
begin
    process (A, B, Opcode)
    begin
        Error <= '0';  -- Initialize error signal
        
        case Opcode is
            when "0000" =>
                -- OpCode 0: Not A
                temp_result <= (others => '0');
                for i in 0 to bit_depth-1 loop
                    temp_result(i) <= not A(i);
                end loop;
                
            when "0001" =>
                -- OpCode 1: Not B
                temp_result <= (others => '0');
                for i in 0 to bit_depth-1 loop
                    temp_result(i) <= not B(i);
                end loop;
                
            when "0010" =>
                -- OpCode 2: A + B
                temp_result <= std_logic_vector(signed(A) + signed(B));
                
            when "0011" =>
                -- OpCode 3: A - B
                temp_result <= std_logic_vector(signed(A) - signed(B));
                
            when "0100" =>
                -- OpCode 4: Shift A left by 1 (multiply by 2)
                temp_result <= (others => '0');
                for i in 1 to bit_depth-1 loop
                    temp_result(i) <= A(i-1);
                end loop;
                temp_result(0) <= '0';
                
            when "0101" =>
                -- OpCode 5: Sign shift A right by 2 bits (divide by 4)
                if A(bit_depth-1) = '1' then
                    temp_result <= (others => A(bit_depth-1));
                    for i in 2 to bit_depth-1 loop
                        temp_result(i) <= A(i-2);
                    end loop;
                else
                    temp_result <= (others => 'X');
                end if;
                
            when "0110" =>
                -- OpCode 6: Shift B right by 1 (multiply by 2)
                temp_result <= (others => '0');
                for i in 0 to bit_depth-2 loop
                    temp_result(i) <= B(i+1);
                end loop;
                temp_result(bit_depth-1) <= '0';
                
            when "0111" =>
                -- OpCode 7: Sign shift B right by 2 bits (divide by 4)
                if B(bit_depth-1) = '1' then
                    temp_result <= B(bit_depth-2 downto 0) & "00";
                else
                    temp_result <= (others => 'X');
                end if;
                
            when "1000" =>
                -- OpCode 8: Flip the bits of A
                temp_result <= (others => '0');
                for i in 0 to bit_depth-1 loop
                    temp_result(i) <= not A(i);
                end loop;
                
            when "1001" =>
                -- OpCode 9: Flip the bits of B
                temp_result <= (others => '0');
                for i in 0 to bit_depth-1 loop
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


testbench begin here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_TB is
end ALU_TB;

architecture testbench of ALU_TB is
    constant bit_depth : integer := 32;
    
    signal result      : std_logic_vector(bit_depth-1 downto 0);
    signal Error       : std_logic;
    signal A, B        : std_logic_vector(bit_depth-1 downto 0);
    signal Opcode      : std_logic_vector(3 downto 0);
    
begin
    -- Instantiate the ALU component
    UUT: entity work.ALU
        generic map (
            bit_depth => bit_depth
        )
        port map (
            result   => result,
            Error    => Error,
            A        => A,
            B        => B,
            Opcode   => Opcode
        );
    
    -- Stimulus generation
    process
    begin
        -- Test case 1: Not A
        A <= "10101010101010101010101010101010";
        B <= "00000000000000000000000000000000";
        Opcode <= "0000";
        wait for 10 ns;
        
        -- Test case 2: A + B
        A <= "10101010101010101010101010101010";
        B <= "01010101010101010101010101010101";
        Opcode <= "0010";
        wait for 10 ns;
        
        -- Add more test cases as needed
        
                -- Test case 12: ERROR
        A <= "10101010101010101010101010101010";
        B <= "01010101010101010101010101010101";
        Opcode <= "1100";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;
end testbench;

