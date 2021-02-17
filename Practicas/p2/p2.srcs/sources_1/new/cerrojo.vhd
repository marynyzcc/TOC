-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cerrojo is
	port(clave: in std_logic_vector (2 downto 0);
		 leds : out std_logic_vector (15 downto 0);
		 intentos: out std_logic_vector (6 downto 0);
		 intro: in std_logic;
	     clk: in std_logic;
		 rst: in std_logic);
end cerrojo;

architecture rtl of cerrojo is
	type states is (s0_inicial, s1_tres, s2_dos, s3_uno, s4_final);
	signal state, next_state : states;
	signal clave_in1, clave_in2: std_logic_vector (2 downto 0);
	signal x_in: std_logic_vector (3 downto 0);
	signal display_out: std_logic_vector (6 downto 0);
	signal clk_int: std_logic;

--- Descomentar cuando se vaya a implementar en FPGA
-- signal ini_d: std_logic;
----------------------------------------------------------
	
	component conv_7seg is
		port (x       : in  std_logic_vector (3 downto 0);
				display : out std_logic_vector (6 downto 0));
	end component conv_7seg;
	
	
--- Descomentar cuando se vaya a implementar en FPGA	
--	component debouncer 
--        PORT (
--            rst: IN std_logic;
--            clk: IN std_logic;
--            x: IN std_logic;
--            xDeb: OUT std_logic;
--            xDebFallingEdge: OUT std_logic;
--            xDebRisingEdge: OUT std_logic
--        );
--    end component debouncer;
    
--    component divisor 
--    port (
--        rst: in STD_LOGIC;
--        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
--        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
--    );
--    end component;
--------------------------------------------------------    
   
begin	
	conv2Display : conv_7seg port map(
		x => x_in,
		display => display_out);
		
-- Descomentar cuando se vaya a implementar en FPGA
--	debpm: debouncer port map(
--		rst => rst_in,
--		clk => clk,
--		x => intro,
--      xDeb => open,
--      xDebFallingEdge => open,
--      xDebRisingEdge => ini_d
--	);
	
--	divisorpm: divisor port map(
--	   rst => rst,
--	   clk_entrada => clk, 
--	   clk_salida => clk_int
--	);
--------------------------------------------------

-- Comentar cuando se vaya a implementar en FPGA
   clk_int <= clk;
-------------------------------------------------

	p_reg : process(clk, intro, clave, rst)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
			     state <= s0_inicial;
			elsif(rst = '0' and intro = '1') then
		         state <= next_state;
            else
                 if(state = s0_inicial and intro = '0') then
                    clave_in1 <= clave;
                 elsif (state /= s0_inicial and intro = '0') then
                    clave_in2 <= clave;
                 end if;	
	       end if;
	    end if;	
	end process p_reg;
	
	p_next_state: process(state, intro, clave, clave_in1, clave_in2, display_out)
	begin
		case state is 
			when s0_inicial =>
			    leds <= (others =>'1');
		        x_in <= "0000";
			    intentos <= display_out; 
			    
				if (intro = '1' and clave_in1 = clave) then
					next_state <= s1_tres;
				else
					next_state <= state;
				end if;
				
			when s1_tres => 
			    leds <= (others =>'0');
		        x_in <= "0011";
			    intentos <= display_out;
				
				if (intro = '1' and clave_in1 = clave_in2) then
					next_state <= s0_inicial;
			   else
					next_state <= s2_dos ;
				end if;
					
			when s2_dos =>
			    leds <= (others =>'0');
		        x_in <= "0010";
			    intentos <= display_out;
			    
				if (intro = '1' and clave_in1 = clave_in2) then
					next_state <= s0_inicial;
				else
					next_state <= s3_uno;
				end if;	
				
			when s3_uno =>
			    leds <= (others =>'0');
		        x_in <= "0001";
			    intentos <= display_out;
			    
                if (intro = '1' and clave_in1 = clave_in2) then
					next_state <= s0_inicial;
				else
					next_state <= s4_final;
				end if;
				
			when s4_final =>
			     leds <= (others =>'1');
		         x_in <= "0000";
			     intentos <= display_out;
			     
			     next_state <= state; 
		end case;
	end process;
	
--    p_output: process(state, display_out)
--    begin
--    case state is
--        when s0_inicial =>
--                leds <= (others =>'1');
--                x_in <= "0000";
--                intentos <= display_out;
--        when s1_tres =>
--                leds <= (others =>'0');
--                x_in <= "0011";
--                intentos <= display_out;            
--        when s2_dos =>           
--                leds <= (others =>'0');
--			    x_in <= "0010";
--			    intentos <= display_out; 			
--        when s3_uno =>
--                leds <= (others =>'0');
--                x_in <= "0001";
--                intentos <= display_out;
--        when s4_final =>
--            leds <= (others =>'0');	
--			x_in <= "0000";	
--			intentos <= display_out;
--	   end case;
--    end process;	
end rtl;
