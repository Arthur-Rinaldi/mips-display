----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Newton Jr
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;


entity testebench is

end testebench;

architecture Behavioral of testebench is

    component miTo is
    port (
         signal clk             : in  std_logic :='0';
         signal rst_n           : in  std_logic :='0';
         signal data_in         : in  std_logic_vector (15 downto 0);
         signal data_out        : out std_logic_vector (15 downto 0)         
    ); 
    
    end component;   
     
        -- control signals
        signal clk_s            : std_logic :='0';
        signal reset_s          : std_logic;
        signal data_in_s        : std_logic_vector (15 downto 0);
        signal data_out_s       : std_logic_vector (15 downto 0);
        constant clk_period  : time                := 10 ns;
        
    begin
    
      miTo_i : miTo
      port map(
        clk                 => clk_s,
        rst_n               => reset_s,   
        data_in             => data_in_s,
        data_out            => data_out_s
      );

  -- Clock process definitions
    clk_100Mhz : process
  begin
       clk_s <= '0';
       wait for clk_period/2;
       clk_s <= '1';
       wait for clk_period/2;
    end process;
    
    -- reset signal
    reset_s		<= '1' after 2 ns,
		   '0' after 8 ns;	

end Behavioral;
