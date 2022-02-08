-- MAIN FILE


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity trafficlight is
generic(ClockFrequencyHz : integer);
port( 
    -- Input
    Clk         : in std_logic;
    nRst        : in std_logic; -- Negative reset
   
   -- Output
    ctl_red     : out std_logic; --  car traffic light red
    ctl_amber   : out std_logic; --  car traffic light amber
    ctl_green   : out std_logic; --  car traffic light green
    ptl_red     : out std_logic; --  pedestrian traffic light red
    ptl_green   : out std_logic); -- pedestrian traffic light green
end entity;
 
architecture rtl of trafficlight is
    
    type t_State is (start, start_ped, ped_green, stop, -- Enumerated type declaration and state signal declaration
                        stop_next, stop_delay);
    signal State : t_State; -- register to hold current state
 
    -- Counter for counting clock periods, 1 minute max
    signal Counter : integer range 0 to ClockFrequencyHz * 60;
 
begin
 
    process(Clk) is
    begin
        if rising_edge(Clk) then
            if nRst = '0' then
                -- Reset values
                State   <= start;
                Counter <= 0;
                ctl_red   <=  '0';
                ctl_amber <=  '0';
                ctl_green <=  '0';
                ptl_red   <=  '1';
                ptl_green <=  '0';
 
            else
                -- Default values
                ctl_red   <=  '0';
                ctl_amber <=  '0';
                ctl_green <=  '0';
                ptl_red   <=  '0';
                ptl_green <=  '0';
 
                Counter <= Counter + 1;
 
                case State is
 
                    -- green for cars and red for pedestrians
                    when start =>
                        ctl_green <= '1';
                        ptl_red <= '1';
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= start_ped;
                        end if;
 
                    -- yellow for cars and red for pedestrians          
                    when start_ped =>
                        ctl_amber      <= '1';
                        ptl_red        <= '1';
                        -- If 2 seconds has passed
                        if Counter = ClockFrequencyHz * 2 -1 then
                            Counter <= 0;
                            State   <= ped_green;
                        end if;
 
                    -- red for cars and green for pedestrians
                    when ped_green =>
                        ctl_red      <= '1';
                        ptl_green    <= '1';
                        -- If 10 seconds has passed
                        if Counter = ClockFrequencyHz * 10 -1 then
                            Counter <= 0;
                            State   <= stop;
                        end if;
 
                    -- red for cars and red for pedestrians
                    when stop =>
                        ctl_red     <= '1';
                        ptl_red     <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 5 -1 then
                            Counter <= 0;
                            State   <= stop_next;
                        end if;
 
                    -- amber for cars and red for pedestrians
                    when stop_next =>
                        ctl_amber <= '1';
                        ptl_red   <= '1';
                        -- If 2 seconds have passed
                        if Counter = ClockFrequencyHz * 2 -1 then
                            Counter <= 0;
                            State   <= stop_delay;
                        end if;
 
                    -- Red and yellow in west/east direction
                    when stop_delay =>
                        ctl_green   <= '1';
                        ptl_red     <= '1';
                        -- If 5 seconds have passed
                        if Counter = ClockFrequencyHz * 20 -1 then
                            Counter <= 0;
                            State   <= start;
                        end if;
 
                end case;
          end if; 
        end if;
    end process;
    
    

end architecture;
