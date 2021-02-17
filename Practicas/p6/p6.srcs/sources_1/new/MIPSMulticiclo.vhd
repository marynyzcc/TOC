library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPSMulticiclo is
	port( 
		clk		: in  std_logic;
		rst	    : in  std_logic;
		modo    : in std_logic_vector(0 downto 0);
		pulsador: in std_logic;
		display : out std_logic_vector(6 downto 0);
		display_enable: out std_logic_vector(3 downto 0)
--        res      : out std_logic_vector(31 downto 0)
	);
end MIPSMulticiclo;

architecture MIPSMulticicloArch of MIPSMulticiclo is
    
	component unidadDeControl is
		port( 
			clk		: in  std_logic;
			rst  	: in  std_logic;
			control	: out std_logic_vector(16 downto 0);
			Zero	: in  std_logic;
			op		: in  std_logic_vector(5 downto 0);
			modo    : in std_logic_vector(0 downto 0);
			pulsador: in std_logic
		);
	end component;

	component rutaDeDatos is
		port( 
			clk		: in  std_logic;
			rst 	: in  std_logic;
			control	: in  std_logic_vector(16 downto 0);
			Zero	: out std_logic;
			op		: out std_logic_vector(5 downto 0);
			R3      : out std_logic_vector(31 downto 0);
			PC_debug: out std_logic_vector(31 downto 0) 
		);
	end component;
	
	component conv_7seg is
	port(
	    x : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0)
	);
	end component;
	
	component debouncer is
	port(
        rst: IN std_logic;
        clk: IN std_logic;
        x: IN std_logic;
        xDeb: OUT std_logic;
        xDebFallingEdge: OUT std_logic;
        xDebRisingEdge: OUT std_logic
	   );
	end component;
  
	signal control : std_logic_vector(16 downto 0);
	signal Zero	   : std_logic;
	signal op      : std_logic_vector(5 downto 0);

------------------------------------------------------    
    signal res: std_logic_vector(31 downto 0);
    signal display_0: std_logic_vector(6 downto 0);
    signal display_1: std_logic_vector(6 downto 0);
    signal display_2: std_logic_vector(6 downto 0);
    signal contador_refresco: std_logic_vector(19 downto 0);
    signal PC: std_logic_vector(31 downto 0);
    signal rst_d: std_logic;
    signal pulsador_d: std_logic;
------------------------------------------------------
    
begin

    UC : unidadDeControl port map
    (clk => clk, 
    rst => rst, 
    control => control, 
    Zero => Zero, 
    op => op, 
    modo => modo, 
    pulsador => pulsador
    );
    
    RD: rutaDeDatos port map
    (clk => clk, 
    rst => rst, 
    control => control, 
    Zero => Zero, 
    op => op, 
    R3 => res, 
    PC_debug => PC
    );
    
    -- displays 7 segmentos --
    pm_display_0: conv_7seg port map(x => res(3 downto 0), display => display_0);
    pm_display_1: conv_7seg port map(x => res(7 downto 4), display => display_1);
    pm_display_2: conv_7seg port map(x => PC(5 downto 2), display => display_2);
    
    
    display <= display_0 when (contador_refresco(19 downto 18) = "00") else
               display_1 when (contador_refresco(19 downto 18) = "01") 
               else
               display_2 when (contador_refresco(19 downto 18) = "10");
               
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
                      "1101" when (contador_refresco(19 downto 18) = "01") 
                      else
                      "1011" when (contador_refresco(19 downto 18) = "10");
    
    -- debouncer --
    deb_rst: debouncer port map(
        rst => rst,
        clk => clk,
        x => rst,
        xdeb => open,
        xdebfallingedge => open,
        xdebrisingedge => rst_d
    );

    deb_pulsador: debouncer port map(
        rst => rst,
        clk => clk,
        x => pulsador,
        xdeb => open,
        xdebfallingedge => open,
        xdebrisingedge => pulsador_d
    );

end MIPSMulticicloArch;