
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
          display_enable: out std_logic_vector(3 downto 0);
          displays: out std_logic_vector(6 downto 0)
--          res_out: out std_logic_vector(7 downto 0);
--          fin: out std_logic;          
   );
   end component;
   
   signal A: std_logic_vector(3 downto 0) := (others => '0');
   signal B: std_logic_vector(3 downto 0) := (others => '0');
   signal ini: std_logic := '0'; 
   signal clk: std_logic := '0'; 
   signal rst: std_logic := '0';
   signal leds: std_logic_vector(15 downto 0);
   signal display_enable: std_logic_vector(3 downto 0);
   signal displays: std_logic_vector(6 downto 0);
--   signal res_out:std_logic_vector(7 downto 0);
--   signal res_xpct:std_logic_vector(7 downto 0);
--   signal fin : std_logic;
   
   
   constant clk_period : time := 100 ns;
    
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
        display_enable => display_enable,
        displays => displays
--        fin => fin,
--        res_out => res_out        
         );
   
    sim: process
    variable v_i: natural := 0;
    variable v_j: natural := 0;
    
    begin
        wait until rising_edge(clk);
        rst <= '1';
        wait until rising_edge(clk);
	    rst <= '0';
	    wait for 5 ns;
--        wait until rising_edge(clk);
        
        i_loop : for v_i in 0 to 15 loop
          j_loop : for v_j in 0 to 15 loop
            A      <= std_logic_vector(to_unsigned(v_i, 4));
            B      <= std_logic_vector(to_unsigned(v_j, 4));
--            res_xpct <= std_logic_vector(to_unsigned(v_i * v_j, 8));
            
 --           wait until rising_edge(clk);
		    ini <= '1';
            wait until rising_edge(clk);
            ini <= '0';
            wait until leds <= "1111111111111111"; 
            
--            assert res_out = res_xpct
--              report "Error multiplying, "&integer'image(v_i)&" * " &integer'image(v_j)& " = " & integer'image(v_i*v_j) &
--                     " not " &integer'image(to_integer(unsigned(res_out)))
--              severity error;      
               
			wait for 5 ns;
          end loop j_loop;
        end loop i_loop;
        wait;
    end process;
end Behavioral;