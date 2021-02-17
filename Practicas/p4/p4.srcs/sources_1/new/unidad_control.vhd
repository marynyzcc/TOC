
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unidad_control is
  Port ( clk: in std_logic;
         rst: in std_logic;
         ini: in std_logic;
         leds_out: out std_logic_vector(15 downto 0);
         ctrl: out std_logic_vector(7 downto 0);
         flags: in std_logic_vector(1 downto 0)
--         fin: out std_logic
        );
end entity;

architecture rtl of unidad_control is
    type estado_t is (s0, s1, s2, s3, s4);
	signal estado_actual, estado_siguiente : estado_t;
	signal zero, msb : std_logic;

begin
    p_status_signals : (msb, zero) <= flags;
        
    p_reg : process(clk, rst) is
    begin
        if rst = '1' then
            estado_actual <= s0;
        elsif rising_edge(clk) then
            estado_actual <= estado_siguiente;	
        end if; 
    end process p_reg; 
    
    p_sig_estado : process (estado_actual, ini, msb, zero) is
	begin
		case estado_actual is 
			when s0 =>
				if ini = '1' then
					estado_siguiente <= s1;
				else
					estado_siguiente <= s0;
				end if;
				
			when s1 => 
				estado_siguiente <= s2 ;
			when s2 =>
				if zero = '1' then
					estado_siguiente <= s0;
				elsif msb = '1' then
					estado_siguiente <= s3;
				else
					estado_siguiente <= s4;
				end if;
			when s3 =>
				estado_siguiente <= s2;
			when s4 =>
				estado_siguiente <= s2; 
--			when others => null;
		end case;
	end process p_sig_estado;
	
	p_outputs: process(estado_actual) is
	
	constant a_ld   	: std_logic_vector(7 downto 0) := "00000001";
	constant b_ld   	: std_logic_vector(7 downto 0) := "00000010";
	constant n_ld   	: std_logic_vector(7 downto 0) := "00000100";
	constant desp_ld_a: std_logic_vector(7 downto 0) := "00001000";
	constant desp_ld_b: std_logic_vector(7 downto 0) := "00010000";
	constant mux   	: std_logic_vector(7 downto 0) := "00100000";
	constant add   	: std_logic_vector(7 downto 0) := "01000000";
	constant n_rest   : std_logic_vector(7 downto 0) := "10000000";
	
	begin
		case estado_actual is
			when s0 => 
				ctrl <= (others => '0');
--				fin <= '1';
				leds_out <= (others => '1');
			when s1 =>
				ctrl <= a_ld or b_ld or n_ld; 
--				fin <= '0';
				leds_out <= (others => '0');
			when s2 =>
				ctrl <= (others => '0');
--				fin <= '0';
				leds_out <= (others => '0');
			when s3 =>
				ctrl <= desp_ld_a or desp_ld_b or mux or add or n_rest;
				leds_out <= (others => '0');
--				fin <= '0';
			when s4 =>
				ctrl <= desp_ld_a or desp_ld_b or n_rest;
				leds_out <= (others => '0');
--				fin <= '0';
		end case;
	end process p_outputs;
end rtl;
