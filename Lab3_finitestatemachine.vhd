library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Lab3_finitestatemachine is
end entity;
 
architecture sim of Lab3_finitestatemachine is
 
    -- Low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod      : time := 1000 ms / ClockFrequencyHz;
 
    signal Clk         : std_logic := '1';
    signal nRst        : std_logic := '0';
    signal button      : std_logic := '1';
    signal ctl_red     : std_logic;
    signal ctl_amber   : std_logic;
    signal ctl_green   : std_logic;
    signal ptl_red     : std_logic;
    signal ptl_green   : std_logic;
 
begin
 
    -- The Device Under Test (DUT)
    i_TrafficLights : entity work.Lab3_trafficlight(rtl) -- instance of Lab3_trafficlight with architecture rtl
    generic map(ClockFrequencyHz => ClockFrequencyHz)
    port map (
        Clk         => Clk,
        nRst        => nRst,
        button      => button,
        ctl_red     => ctl_red,
        ctl_amber   => ctl_amber,
        ctl_green   => ctl_green,
        ptl_red     => ptl_red,
        ptl_green   => ptl_green);
 
    -- Process for generating clock
    Clk <= not Clk after ClockPeriod / 2;
 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
 
        -- Take the DUT out of reset
        nRst <= '1';
 
        wait;
    end process;
 
end architecture;