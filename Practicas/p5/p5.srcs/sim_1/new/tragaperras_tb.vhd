----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tragaperras_tb IS
END tragaperras_tb;
 
ARCHITECTURE behavior OF tragaperras_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tragaperras
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ini : IN  std_logic;
         fin : IN  std_logic;
         leds: OUT  std_logic_vector(7 downto 0);
         display: out std_logic_vector(6 downto 0);
         display_enable: out std_logic_vector(3 downto 0)
--         a : OUT  std_logic_vector(6 downto 0);
--         b : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ini : std_logic := '0';
   signal fin : std_logic := '0';

 	--Outputs
   signal leds: std_logic_vector(7 downto 0);
   signal display: std_logic_vector(6 downto 0);
   signal display_enable: std_logic_vector(3 downto 0);
--   signal a : std_logic_vector(6 downto 0);
--   signal b : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tragaperras PORT MAP (
          clk => clk,
          rst => rst,
          ini => ini,
          fin => fin,
          leds => leds,
          display => display,
          display_enable => display_enable
--          a => a,
--          b => b
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

		ini <= '0';
		fin <= '0';
		rst <= '1';
        wait for 100 ns;	
--		wait until rising_edge(clk);
		rst <= '0';
		
		wait until rising_edge(clk);
		ini <= '1';

		wait until rising_edge(clk);
		ini <= '0';
		wait for 100 ns;
		wait until rising_edge(clk);
		fin <= '1';
		wait until rising_edge(clk);
		fin <= '0';

		wait;
   end process;

END;