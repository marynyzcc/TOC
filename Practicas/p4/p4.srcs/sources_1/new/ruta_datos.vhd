
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ruta_datos is
  Port (A: in std_logic_vector(3 downto 0);
        B: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        ctrl: in std_logic_vector(7 downto 0);
        res: out std_logic_vector(7 downto 0);
        flags: out std_logic_vector(1 downto 0) );
end entity;

architecture rtl of ruta_datos is 
    signal a_r : std_logic_vector (3 downto 0);
	signal b_r : std_logic_vector (3 downto 0);
	signal a_8b : std_logic_vector (7 downto 0) := (others => '0');
	signal res_r: std_logic_vector (7 downto 0);
	signal res_aux: std_logic_vector (7 downto 0);
	signal n     : unsigned (3 downto 0);
	signal mux_output_a : std_logic_vector (7 downto 0);
	signal mux_output_b : std_logic_vector (7 downto 0);
	
	--señales de control
	signal a_ld   : std_logic;
	signal b_ld   : std_logic;
	signal n_ld   : std_logic;
	signal desp_ld_a  : std_logic;
	signal desp_ld_b  : std_logic;
	signal mux : std_logic;
	signal add : std_logic;
	signal n_rest : std_logic;
	
	--señales de estado
	signal zero : std_logic;
	signal msb : std_logic;

begin
    (n_rest, add, mux, desp_ld_b, desp_ld_a, n_ld, b_ld, a_ld) <= ctrl;
	flags <= (msb & zero);
	
	--registro 'a'
	reg_a : process (clk, rst) is
	begin
		if rst = '1' then
			a_r <= (others => '0');
		elsif rising_edge(clk) then
			if a_ld = '1' then
				a_r <= a;
			elsif desp_ld_a = '1' then
				a_r(3 downto 1) <= a_r(2 downto 0);
				a_r(0) <= '0';
			end if;
		end if;
	end process reg_a;
	
	 --registro 'b'
	reg_b : process (clk, rst) is
	begin
		if rst = '1' then
			b_r <= (others => '0');
		elsif rising_edge(clk) then
			if b_ld = '1' then
				b_r <= b;
			elsif desp_ld_b = '1' then
				b_r(2 downto 0) <= b_r(3 downto 1);
				b_r(3) <= '0';
			end if;
		end if;
	end process reg_b;
	
	p_a : a_8b(3 downto 0) <= a_r;
	p_msb : msb <= b_r(0);
	
	--contador
      p_cntr : process (clk, rst) is
      begin
        if rst = '1' then 
          n <= (others => '0');
        elsif rising_edge(clk) then
          if n_ld = '1' then
                n <= "1000";
            elsif n_rest = '1' then
                n <= n - "0001";
            end if;
        end if;
      end process p_cntr;
	
	 --sumador
	p_add : process (rst, clk) is
	begin 
		if rst = '1' then
			res_aux <= (others => '0');
		elsif rising_edge(clk) then
			if add = '1' then
				res_aux <= std_logic_vector(unsigned(mux_output_a) + unsigned(mux_output_b));
			elsif n_ld = '1' then
				res_aux <= (others => '0');
			end if;
		end if;
	end process p_add;
	
	p_reg : process (rst, clk) is
	begin 
		if rst = '1' then
			res_r <= (others => '0');
		elsif rising_edge(clk) then
			if n_ld = '1' then
				res_r <= (others => '0');
			else
				res_r <= res_aux;
			end if;
		end if;
	end process p_reg;

    --comparador de cero
	p_comp : process (n) is
	begin
		if n = "0000" then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end process p_comp;
    
    p_mux : process (res_r, a_8b, mux) is
    begin  
        if mux = '1' then
            mux_output_a <= a_8b;
          mux_output_b <= res_r;
        elsif mux = '0' then
            mux_output_a <= (others => '0');
            mux_output_b <= (others => '0');
        end if;
  end process p_mux;

	p_res : res <= res_r;

end rtl;