library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light_controller is
    port (
        clock                : in std_logic;
        reset                : in std_logic;
        night_switch         : in std_logic;
        main_road_lights     : out std_logic_vector(4 downto 0); -- WE direction
        secondary_road_lights: out std_logic_vector(4 downto 0)  -- NS direction
    );
end entity;

architecture behavior of traffic_light_controller is
    -- SIGNALS
    signal fsm_CLRN: std_logic; 
    signal fsm_CNT: std_logic_vector(3 downto 0);
    signal counter_out: std_logic_vector(3 downto 0);
    
    --COMPONENTS
    component trafficLight_FSM is 
    	port(
        CLK                  : in std_logic;					-- CLK
        ARESETN              : in std_logic;					-- aresetn	
        DAYNIGHT         	 : in std_logic;					-- day/night
        CNT					 : in std_logic_vector(3 downto 0);	-- ticks
        CLRN				 : out std_logic;
        main_road_lights     : out std_logic_vector(4 downto 0); -- WE direction
        secondary_road_lights: out std_logic_vector(4 downto 0)  -- NE direction
        );
    end component;
    
    component mod9_counter is
	port(
    	CLRN : in std_logic;
        CLK : in std_logic;
        ARESETN : in std_logic;
        CNT	: out std_logic_vector(3 downto 0);
    );
    end component; 
begin
	-- Instantiate the mod9_counter component
    mod9_counter_inst : mod9_counter
        port map (
            CLRN        => fsm_CLRN,           -- Clear from FSM
            CLK        => clock,              -- Clock input
            ARESETN     => reset,              -- Reset input from top-level entity
            CNT         => counter_out         -- Connect counter output to FSM
        );
        
        -- Instantiate the trafficLight_FSM component
    trafficLight_FSM_inst : trafficLight_FSM
        port map (
            CLK                	 => clock,               -- Clock input
            ARESETN              => reset,               -- Reset input from top-level entity
            DAYNIGHT         	 => night_switch,        -- Night switch input
            CNT                  => counter_out,         -- Counter output connected
            CLRN                 => fsm_CLRN,            -- Clear for FSM
            main_road_lights     => main_road_lights,    -- Main road lights output
            secondary_road_lights => secondary_road_lights -- Secondary road lights output
        );    

end architecture; 
