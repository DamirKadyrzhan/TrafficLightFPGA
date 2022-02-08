library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity finitestatemachine is
end entity;
 
architecture sim of finitestatemachine is
 
    -- Low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod      : time := 1000 ms / ClockFrequencyHz;
 
    signal Clk         : std_logic := '1';
    signal nRst        : std_logic := '0';
    signal ctl_red     : std_logic;
    signal ctl_amber   : std_logic;
    signal ctl_green   : std_logic;
    signal ptl_red     : std_logic;
    signal ptl_green   : std_logic;
 
begin
 
    -- The Device Under Test (DUT)
    i_TrafficLights : entity work.trafficlight(rtl) -- instance of trafficlight with architecture rtl
    generic map(ClockFrequencyHz => ClockFrequencyHz)
    port map (
        Clk         => Clk,
        nRst        => nRst,
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
