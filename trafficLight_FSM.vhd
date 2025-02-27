library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity trafficLight_FSM is
    port (
        CLK                : in std_logic;					-- CLK
        ARESETN                : in std_logic;					-- aresetn	
        DAYNIGHT         : in std_logic;					-- day/night
        CNT					 : in std_logic_vector(3 downto 0);	-- ticks
        CLRN				 : out std_logic;
        main_road_lights     : out std_logic_vector(4 downto 0); -- WE direction
        secondary_road_lights: out std_logic_vector(4 downto 0)  -- NE direction
    );
end entity;

architecture behavior of trafficLight_FSM is
    type state is (I0, D1, D2, D3, D4, D5, D6, D7, D8, N1, N2, N3);
    signal current_state : state := I0; -- Initial state
    signal next_state    : state;
    signal current_mode  : std_logic := '0'; -- Initial mode
    signal clear_counter : std_logic := '0';
    
begin

    
    update_logic: process(CLK, ARESETN)
    begin
        if ARESETN = '0' then -- was '1' before
            current_state <= I0;
            current_mode <= DAYNIGHT; -- Store switch value on reset
        elsif rising_edge(CLK) then
            current_state <= next_state;
            current_mode <= DAYNIGHT; -- Update mode
        end if;
    end process;

    
    transition_logic: process(current_state, current_mode, CNT)
    begin
    clear_counter <= '0';
        case current_state is
            when I0 =>		-- Phase duration 2 >> CNT = '0010' 
                if (current_mode = '0' and CNT = "0010") then
                    next_state <= D1;
                    clear_counter <= '1'; 
                elsif (current_mode = '1' and CNT = "0010") then
                    next_state <= N1;
                    clear_counter <= '1';
                end if;
            when D1 =>
            	if(CNT = "0010") then
                	next_state <= D2;
                    clear_counter <= '1';
                end if;
            when D2 =>
            	if(CNT = "0001") then
                	next_state <= D3;
                	clear_counter <= '1';
                end if; 
            when D3 =>
            	if(CNT = "1000") then
                	next_state <= D4;
                	clear_counter <= '1';
                end if; 
            when D4 =>
            	if(CNT = "0001") then
                	next_state <= D5;
                    clear_counter <= '1';
                end if;     
            when D5 =>
            	if(CNT = "0010") then
                	next_state <= D6;
                    clear_counter <= '1';
                end if;     
            when D6 =>
                if(CNT = "0001") then
                	next_state <= D7;
                    clear_counter <= '1';
                end if;   
            when D7 =>
                if(CNT = "0100") then
                	next_state <= D8;
                    clear_counter <= '1';
                end if;
            when D8 =>
                if (current_mode = '0' and CNT = "0001") then
                    next_state <= D1;
                    clear_counter <= '1';
                elsif (current_mode = '1' and CNT = "0001") then
                    next_state <= N1;
                    clear_counter <= '1';
                end if;
            when N1 =>
                if(CNT = "0010") then
                	next_state <= N2;
                    clear_counter <= '1';
                end if;    
            when N2 =>
                if(CNT = "0001") then
                next_state <= N3;
                clear_counter <= '1';
                end if;
            when N3 =>
                if (current_mode = '1' and CNT = "0001") then
                    next_state <= N2;
                	clear_counter <= '1';    
                elsif (current_mode = '0' and CNT = "0001") then
                    next_state <= I0;
                	clear_counter <= '1';
                end if;
            when others =>
                next_state <= I0; -- Fallback
                clear_counter <= '1';
        end case;
    end process;
	CLRN <= clear_counter; 
    
    output_logic: process(current_state)
    begin
        case current_state is
            when I0 =>
                main_road_lights <= "01010";
                secondary_road_lights <= "01010";
            when D1 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "10010";
            when D2 =>
                main_road_lights <= "11001";
                secondary_road_lights <= "10010";
            when D3 =>
                main_road_lights <= "00101";
                secondary_road_lights <= "10010";
            when D4 =>
                main_road_lights <= "01010";
                secondary_road_lights <= "10010";
            when D5 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "10010";
            when D6 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "11001";
            when D7 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "00101";
            when D8 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "01010";
            when N1 =>
                main_road_lights <= "10010";
                secondary_road_lights <= "10010";
            when N2 =>
                main_road_lights <= "00000";
                secondary_road_lights <= "01000";
            when N3 =>
                main_road_lights <= "00000";
                secondary_road_lights <= "00000";
            when others =>
                main_road_lights <= "10010";
                secondary_road_lights <= "10010";
        end case;
    end process;

end architecture behavior;
