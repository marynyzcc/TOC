

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sim_parallel_reg is
end entity;

architecture arch of sim_parallel_reg is
component parallel_reg
port(  rst, clk, load: in  std_logic;
	   I:  in  std_logic_vector(3 downto 0);
	   O:  out std_logic_vector(3 downto 0) 
);
end component;
    signal rst,clk,load: std_logic;
    signal I: std_logic_vector(3 downto 0);
    signal O: std_logic_vector(3 downto 0);
    
    constant clk_period: time := 100 ns;
begin
prpm: parallel_reg port map (
    rst => rst,
    clk => clk,
    load => load,
    I => I,
    O => O
);

p_clk: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

p_sim: process
begin
    rst <= '1'; 
    load <= '1';
    I <= "1010";
    wait for 100 ns;
    rst <= '0'; 
    load <= '1';
    I <= "0010";
    wait for 100 ns;
    rst <= '1'; 
    load <= '0';
    I <= "0010";
    wait for 100 ns;
    rst <= '0'; 
    load <= '1';
    I <= "0010";
    wait for 100 ns;
    rst <= '0'; 
    load <= '1';
    I <= "0001";
    wait for 100 ns;
    rst <= '0'; 
    load <= '0';
    I <= "1010";
    wait for 100 ns;
    rst <= '0'; 
    load <= '0';
    I <= "1100";
    wait for 100 ns;
    rst <= '0'; 
    load <= '1';
    I <= "1111";
    wait for 100 ns;
       
end process;
end architecture;
