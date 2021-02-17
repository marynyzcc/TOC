------------------------------------------------------------
-- register with parallel input / parallel output
------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity parallel_reg is
    port( rst, clk, load: in  std_logic;
	       I:  in  std_logic_vector(3 downto 0);
	       O:  out std_logic_vector(3 downto 0) );
end parallel_reg;

architecture circuit of parallel_reg is
    signal clk_int: std_logic;

-- Descomentar para la implementacion en la FPGA

component divider is 
    port(
        rst: in std_logic;
        clk_100mhz: in std_logic;
       clk_1hz: out std_logic
    );
end component;
-----------------------------------------
begin
 
--Descomentar cuando se vaya a realizar la implementacion en la FPGA
 i_clk_int: divider port map(
    rst => rst,
    clk_100mhz => clk,
    clk_1hz => clk_int
 );
------------------------------------------------------------------------

--Comentar cuando se vaya a realizar la implementacion en la FPGA
--clk_int <= clk;
-------------------------------------------------------------------


    process(rst, clk_int)
    begin
	      if clk_int'event and clk_int = '1' then
		      if rst = '1' then
			    O <= "0000";
		      elsif load = '1' then
			    O <= I;
		      end if;
	      end if;
    end process;
end circuit;