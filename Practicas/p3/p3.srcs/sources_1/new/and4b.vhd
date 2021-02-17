library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and4b is
	port(	x : in std_logic_vector(3 downto 0);
			y : in std_logic;
			res_and : out std_logic_vector(3 downto 0)
		  );
end and4b;

architecture Behavioral of and4b is
signal aux: std_logic_vector(3 downto 0);

begin
	and_process: process(y, x)
		begin
		if (y = '0') then
			aux <= "0000";
		else	
			aux <= x;
		end if;
	end process;
	
res_and <= aux;
end Behavioral;
