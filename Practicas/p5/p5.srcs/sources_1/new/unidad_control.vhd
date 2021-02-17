----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_unsigned.all;

entity unidad_control is
	port(clk 	 : in std_logic;
		  rst		 : in std_logic;
		  ini 	 : in std_logic;
		  fin		 : in std_logic;  
		  ctrl	 : out std_logic_vector(3 downto 0);
		  status	 : in std_logic_vector (1 downto 0)
		  );
end unidad_control;

architecture rtl of unidad_control is
	type estado_t is (s0, s1, s2, s3);
	signal estado_actual, estado_siguiente : estado_t;
	signal eq : std_logic;
	signal f : std_logic;
begin
	
	p_status_signals : (eq, f) <= status;
	
	p_reg : process(clk, rst) is
	begin
		if rst = '1' then
			estado_actual <= s0;
		elsif rising_edge(clk) then
			estado_actual <= estado_siguiente;	
		end if; 
	end process p_reg; 
	
	p_sig_estado : process (estado_actual, ini, fin, eq, f) is
	begin
		case estado_actual is 
			when s0 =>
				if ini = '1' then
					estado_siguiente <= s1;
				else
					estado_siguiente <= estado_actual;
				end if;
				
			when s1 => 
				if fin = '0' then
					estado_siguiente <= estado_actual;
				elsif fin = '1' and eq = '0' then
					estado_siguiente <= s2;
				elsif fin = '1' and eq = '1' then
					estado_siguiente <= s3;
				end if;
			when s2 =>
				if f = '1' then
					estado_siguiente <= s0;
				else
					estado_siguiente <= estado_actual;
				end if;
			when s3 =>
				if f = '1' then
					estado_siguiente <= s0;
				else
					estado_siguiente <= estado_actual;
				end if;
			when others => null;
		end case;
	end process p_sig_estado;
	
	
	p_outputs: process(estado_actual) is
	
	constant count : std_logic_vector(3 downto 0) := "0001";
	constant led_p : std_logic_vector(3 downto 0) := "0010";
	constant led_g : std_logic_vector(3 downto 0) := "0100";
	constant led_a : std_logic_vector(3 downto 0) := "1000";
	 
	begin
		case estado_actual is
			when s0 => 
				ctrl <= led_a;
			when s1 =>
				ctrl <= count;
			when s2 =>
				ctrl <= led_p;
			when s3 =>
				ctrl <= led_g; 
		end case;
	end process p_outputs;
end rtl;