library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod9_counter is
	generic (N: natural := 9);
	port(
    	CLRN : in std_logic;
        CLK : in std_logic;
        ARESETN : in std_logic;
        CNT	: out std_logic_vector(3 downto 0);
    );
end entity;

architecture behavior of mod9_counter is
    signal count : unsigned(3 downto 0);  -- 4-bit signal to hold the counter value
begin
    
counting: process(CLK, ARESETN, CLRN)
    begin
        if ARESETN = '0' then  -- was 1 
            count <= (others => '0');  
        elsif CLRN = '1' then  
            count <= (others => '0');  
        elsif rising_edge(CLK) then  
            if count = to_unsigned(N - 1, count'length) then  
                count <= (others => '0'); 
            else
                count <= count + 1;  
            end if;
        end if;
    end process;
    CNT <= std_logic_vector(count);

end architecture;
