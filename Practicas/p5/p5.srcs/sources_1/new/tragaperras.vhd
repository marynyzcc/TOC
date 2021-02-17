----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tragaperras is
	port(clk 	 : in std_logic;
		  rst	    : in std_logic; 
		  ini 	 : in std_logic;
		  fin		 : in std_logic;
		  leds	 : out std_logic_vector(7 downto 0);
		  display: out std_logic_vector(6 downto 0);
		  display_enable: out std_logic_vector(3 downto 0)
--		  a	 : out std_logic_vector(6 downto 0);
--		  b	 : out std_logic_vector(6 downto 0)
		 );
end tragaperras;

architecture struct of tragaperras is

	component ruta_datos is
		port(clk 	 : in std_logic;
			  rst	    : in std_logic;
			  res_a	 : out std_logic_vector(3 downto 0);
			  res_b	 : out std_logic_vector(3 downto 0);
			  leds : out std_logic_vector(7 downto 0);
			  ctrl	 : in std_logic_vector(3 downto 0);
			  status	 : out std_logic_vector (1 downto 0)
			 );
	end component ruta_datos;
	
	component unidad_control is
		port(clk 	 : in std_logic;
			  rst		 : in std_logic;	
			  ini 	 : in std_logic;
			  fin		 : in std_logic;
			  ctrl	 : out std_logic_vector(3 downto 0);
			  status	 : in std_logic_vector(1 downto 0)
			 );
	end component unidad_control;
	
	component conv_7seg is
		port (x       : in  std_logic_vector (3 downto 0);
				display : out std_logic_vector (6 downto 0));
	end component conv_7seg;
	
	component debouncer is
	port (
		rst             : in  std_logic;
		clk             : in  std_logic;
		x               : in  std_logic;
		xdeb            : out std_logic;
		xdebfallingedge : out std_logic;
		xdebrisingedge  : out std_logic
		);
	end component debouncer;

	signal ctrl		: std_logic_vector(3 downto 0);
	signal res_a	: std_logic_vector(3 downto 0);
	signal res_b	: std_logic_vector(3 downto 0);
	signal status	: std_logic_vector(1 downto 0);

	signal ini_d	: std_logic;
	signal fin_d	: std_logic;
  signal rst_d    : std_logic;
    
    signal display_0: std_logic_vector(6 downto 0); 
    signal display_1: std_logic_vector(6 downto 0); 
    signal contador_refresco: std_logic_vector(19 downto 0); 

begin

	--camino de datos
	i_cd : ruta_datos port map(
		clk => clk, --conectar a divisor
		rst => rst,
		res_a => res_a,
		res_b => res_b,
		leds => leds,
		ctrl => ctrl,
		status => status
	);
	
	-- unidad de control
	i_uc : unidad_control port map(
		clk => clk, 
		rst => rst,
		ini => ini, 
		fin => fin,
		ctrl => ctrl,
		status => status
	);
	
	-- displays 7 segmentos
	conv7A : conv_7seg port map( x => res_a, display => display_0);
	conv7B : conv_7seg port map( x => res_b, display => display_1);
	
	display <=  display_0 when (contador_refresco(19 downto 18) = "00") else
                display_1 when (contador_refresco(19 downto 18) = "01");
	
	process(clk)
	begin 
	   if rising_edge(clk) then
	       if rst = '1' then
	           contador_refresco <= (others => '0');
	       else
	          contador_refresco <= contador_refresco + 1;
            end if;
        end if;
    end process;  
	
	display_enable <= "1110" when (contador_refresco(19 downto 18) = "00") else
                "1101" when (contador_refresco(19 downto 18) = "01");
	
	deb_ini : debouncer port map(
		rst => rst,     
		clk => clk,           
		x => ini,         
		xdeb => open,          
		xdebfallingedge => open,
		xdebrisingedge => ini_d
	);
--	
	deb_fin : debouncer port map(
		rst => rst,     
		clk => clk,           
		x => fin,         
		xdeb => open,          
		xdebfallingedge => open,
		xdebrisingedge => fin_d
	);

	deb_rst : debouncer port map(
		rst => rst,     
		clk => clk,           
		x => rst,         
		xdeb => open,          
		xdebfallingedge => open,
		xdebrisingedge => rst_d
	);
end struct;
