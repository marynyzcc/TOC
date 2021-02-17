----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ruta_datos is
  Port (clk: in std_logic;
        rst: in std_logic;
        ctrl: in std_logic_vector(3 downto 0);
        res_a: out std_logic_vector(3 downto 0);
        res_b: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(7 downto 0);
        status: out std_logic_vector(1 downto 0)
        );
end ruta_datos;

architecture rtl of ruta_datos is
    signal cnt_a : std_logic_vector(3 downto 0);
	signal cnt_b : std_logic_vector(3 downto 0);
	signal cnt_s : std_logic_vector(3 downto 0);
	signal a   : std_logic_vector(3 downto 0);
	signal b   : std_logic_vector(3 downto 0);
	signal l_p : std_logic_vector(7 downto 0);
	signal l_g : std_logic_vector(7 downto 0);
	signal l_a : std_logic_vector(7 downto 0);
	
	signal clk_a : std_logic;
	signal clk_b : std_logic;
	signal clk_c : std_logic;
	
	-- señales de control
	signal count: std_logic;
	signal led_a : std_logic;
	signal led_p : std_logic;
	signal led_g : std_logic;
	
	-- señales de estado
	signal eq : std_logic;
	signal f: std_logic; 
    
    component divisor is
        port (
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
            clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
        );
    end component;
    
    component divisor2 is
        port (
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
            clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
        );
    end component;
    
    component divisor3 is
        port (
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
            clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
        );
    end component;
    
begin
    (led_a,
	 led_g,
	 led_p,
	 count) <= ctrl;
	 
	status <= (eq & f);
    
    -- divisor frecuencias
    clk_cnt_a: divisor port map(
        rst => rst,
        clk_entrada => clk,
        clk_salida => clk_a
    );
    
    clk_cnt_b: divisor2 port map(
        rst => rst,
        clk_entrada => clk,
        clk_salida => clk_b
    );
    
    clk_cnt_c: divisor3 port map(
        rst => rst,
        clk_entrada => clk,
        clk_salida => clk_c
    );
    
    --contador
	p_cntr_a : process (clk_b, rst) is
	begin
		if rst = '1' then 
			cnt_a <= (others => '0');
		elsif rising_edge(clk_b) then
			if count = '1' then
				cnt_a <= std_logic_vector(unsigned(cnt_a) + "0001");
				
				if cnt_a = "1001" then
					cnt_a <= (others => '0');
				end if;
			end if;
		end if;
	end process p_cntr_a;
	
	p_cntr_b : process (clk_c, rst) is
	begin
		if rst = '1' then 
			cnt_b <= (others => '0');
		elsif rising_edge(clk_c) then
			if count = '1' then
				cnt_b <= std_logic_vector(unsigned(cnt_b) + "0001");
				
				if cnt_b = "1001" then
					cnt_b <= (others => '0');
				end if;
				
			end if;
		end if;
	end process p_cntr_b;
	
	p_cntr_s : process (clk_a, rst) is
	begin
		if rst = '1' then 
			cnt_s <= (others => '0');
		elsif rising_edge(clk_a) then
			if led_g = '1' or led_p = '1' then
				cnt_s <= std_logic_vector(unsigned(cnt_s) + "0001");
				
				if cnt_s = "1001" then
					f <= '1';
					cnt_s <= (others => '0');
				end if;
			else
				f <= '0';
			end if;
		end if;
	end process p_cntr_s;
    
    --comparador
	p_comp: process (cnt_a, cnt_b) is
	begin
		if cnt_a = cnt_b then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process p_comp; 
	
	-- leds perder
	l_perder : process (clk_a, rst) is
	begin
		if rst = '1' then
			l_p <= "10101010";
		elsif rising_edge(clk_a) then
			if led_p = '1' then
				l_p <= not l_p;
			end if;
		end if;
	end process l_perder;
	
	-- leds ganar
	l_ganar : process (clk_a, rst) is
	begin
		if rst = '1' then
			l_g <= (others => '1');
		elsif rising_edge(clk_a) then
			if led_g = '1' then
				l_g <= not l_g;
			end if;
		end if;
	end process l_ganar;
	
	-- leds atraer
	l_atraer : process (clk_a, rst) is
	begin
		if rst = '1' then
			l_a <= (others => '0');
		elsif rising_edge(clk_a) then
			if led_a = '1' then
				if l_a(0) = '0' then
					l_a(7) <= '1';
				else
					l_a(7) <= '0';
				end if;
				l_a (6 downto 0) <= l_a(7 downto 1);
			end if;
		end if;
	end process l_atraer;
	
	--decodificador
	decod : process (led_a, led_p, led_g, l_a, l_p, l_g) is
	begin
		if led_a = '1' then
			leds <= l_a;
		elsif led_g = '1' then 
			leds <= l_g;
		elsif led_p = '1' then
			leds <= l_p;
		else
			leds <= (others => '0');
		end if;
	end process decod;
	
	p_res_a : process (rst, clk) is
	begin
		if rst = '1' then
			res_a <= (others => '0');
		elsif rising_edge(clk) then
			if count = '1' then
				res_a <= cnt_a;
			elsif f = '1' then
				res_a <= (others => '0');
			end if;
		end if;
	end process p_res_a;
	
	p_res_b : process (rst, clk) is
	begin
		if rst = '1' then
			res_b <= (others => '0');
		elsif rising_edge(clk) then
			if count = '1' then
				res_b <= cnt_b;
			elsif f = '1' then
				res_b <= (others => '0');
			end if;
		end if;
	end process p_res_b;
	
end rtl;
