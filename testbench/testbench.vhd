-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_traffic_light_controller is
end tb_traffic_light_controller;

architecture behavior of tb_traffic_light_controller is
    -- Signal declarations
    signal clock              : std_logic := '0';
    signal reset              : std_logic := '0';
    signal night_switch       : std_logic := '0';
    signal main_road_lights   : std_logic_vector(4 downto 0);
    signal secondary_road_lights : std_logic_vector(4 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.traffic_light_controller
        port map (
            clock => clock,
            reset => reset,
            night_switch => night_switch,
            main_road_lights => main_road_lights,
            secondary_road_lights => secondary_road_lights
        );

    -- Clock process to generate a clock signal
    clock_process: process
    begin
        while true loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Test process
    stimulus_process: process
    begin
        -- Initial reset test
        reset <= '0'; -- was 1
        night_switch <= '0';
        wait for clk_period * 2;
        reset <= '1';

        -- Test Day Mode (Default) test
        wait for clk_period * 30;

        -- Switch to Night Mode test
        night_switch <= '1';
        wait for clk_period * 20;

        -- Switch back to Day Mode test
        night_switch <= '0';
        wait for clk_period * 10;
        reset <= '0';

        -- End simulation
        wait;
    end process;

end architecture behavior;
