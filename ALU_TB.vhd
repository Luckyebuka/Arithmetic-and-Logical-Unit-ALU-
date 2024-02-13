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

