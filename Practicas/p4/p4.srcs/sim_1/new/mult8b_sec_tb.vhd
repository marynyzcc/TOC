
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mult8b_sec_tb is
--  Port ( );
end mult8b_sec_tb;

architecture Behavioral of mult8b_sec_tb is

    component mult8b_secuencial 
    port( A: in std_logic_vector(3 downto 0);
          B: in std_logic_vector(3 downto 0);
          ini: in std_logic;
          rst: in std_logic;
          clk: in std_logic;
          leds: out std_logic_vector(15 downto 0);
--          display_enable: out std_logic_vector(3 downto 0);
 --         displays: out std_logic_vector(6 downto 0);   
          res_out: out std_logic_vector(7 downto 0)
--          unidades: out std_logic_vector(3 downto 0);
--          decenas: out std_logic_vector(3 downto 0);
--          centenas: out std_logic_vector(3 downto 0)  
   );
   end component;
   
   signal A: std_logic_vector(3 downto 0) := (others => '0');
   signal B: std_logic_vector(3 downto 0) := (others => '0');
   signal ini: std_logic := '0'; 
   signal clk: std_logic := '0'; 
   signal rst: std_logic := '0';
   signal leds: std_logic_vector(15 downto 0);
--   signal display_enable: std_logic_vector(3 downto 0);
--   signal displays: std_logic_vector(6 downto 0);
   signal res_out:std_logic_vector(7 downto 0);   
--    signal unidades: std_logic_vector(3 downto 0);
--    signal decenas:  std_logic_vector(3 downto 0);
--    signal centenas:  std_logic_vector(3 downto 0);
   
   constant clk_period : time := 40 ns;
    
begin
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    pmsim: mult8b_secuencial port map(
        A => A,
        B => B,
        ini => ini,
        rst => rst,
        clk => clk,
        leds => leds,
--       display_enable => display_enable,
--       displays => displays
        res_out => res_out
--        unidades => unidades,
--        decenas => decenas,
--        centenas => centenas       
         );
   
    sim: process
    begin
       wait until rising_edge(clk);
       rst <= '1';
       wait until rising_edge(clk);
	   rst <= '0';
       
       wait until rising_edge(clk);
		A <= "0101";
		B <= "0010";
		wait until rising_edge(clk);
		ini <= '1';
        wait until rising_edge(clk);
		ini <= '0';
        wait until leds <= "1111111111111111";
              
        wait until rising_edge(clk);
		A <= "0010";
		B <= "0100";
		wait until rising_edge(clk);
		ini <= '1';
        wait until rising_edge(clk);
		ini <= '0';
        wait until leds <= "1111111111111111";
        
        wait until rising_edge(clk);
		A <= "0110";
		B <= "0011";
		wait until rising_edge(clk);
		ini <= '1';
        wait until rising_edge(clk);
		ini <= '0';
        wait until leds <= "1111111111111111";
        
        wait until rising_edge(clk);
		A <= "0011";
		B <= "0101";
		wait until rising_edge(clk);
		ini <= '1';
        wait until rising_edge(clk);
		ini <= '0';
        wait until leds <= "1111111111111111";
		wait;     
    end process;
    
end Behavioral;