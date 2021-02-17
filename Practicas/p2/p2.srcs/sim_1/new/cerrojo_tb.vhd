-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO

library ieee;
use ieee.std_logic_1164.ALL;
 
entity cerrojo_tb IS
end entity;
 
architecture arch of cerrojo_tb is 
 
    component cerrojo
    port(
         clave: in  std_logic_vector(2 downto 0);
         leds: out  std_logic_vector(15 downto 0);
         intentos: out  std_logic_vector(6 downto 0);
         intro: in  std_logic;
         clk: in  std_logic;
         rst: in  std_logic
        );
    end component;
    
   --Inputs
   signal clave: std_logic_vector(2 downto 0):= "000";
   signal intro: std_logic := '0';
   signal clk: std_logic:= '0';
   signal rst: std_logic := '0';

 	--Outputs
   signal leds: std_logic_vector(15 downto 0);
   signal intentos: std_logic_vector(6 downto 0);
	
   constant clk_period : time := 50 ns;
 
begin
 
   cerrojopm: cerrojo port map (
          clave => clave,
          leds => leds,
          intentos => intentos,
          intro => intro,
          clk => clk, 
          rst => rst
        );

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   sim: process
   begin		
		rst <= '1';
		intro <= '1';
		wait for 50 ns;	
		rst <= '0'; 
		wait until rising_edge (clk);
		
--- acierto en el primer intento --- 		
		clave <= "001";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
	    clave <= "001";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
			
 --- acierto en el segundo intento ---	
		clave <= "010";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "001";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "010";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		
 --- acierto tercer intento ---	
		clave <= "100";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);		
		clave <= "010"; 
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "001";
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "100";
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		
-- no acertar --- 		
        clave <= "001";
		intro <= '0'; 
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "010"; 
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "110";
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		clave <= "100";
		intro <= '0';
		wait until rising_edge (clk);
		intro <= '1';
		wait until rising_edge (clk);
		
		wait; 
   end process;
end arch;