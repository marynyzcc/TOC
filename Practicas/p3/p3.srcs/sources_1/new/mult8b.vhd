----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity mult8b is
    port( X : in  std_logic_vector(3 downto 0);
          Y : in  std_logic_vector(3 downto 0);
          Z : out std_logic_vector(7 downto 0) );
end mult8b;

--- Multiplicador usando librería numeric_std -----------------
--architecture beh of mult8b is
--begin
--   Z <= std_logic_vector(unsigned(X)*unsigned(Y));
--end beh;
---------------------------------------------------------------


----- Multiplicador usando sumadores -----------------
architecture beh of mult8b is

signal and1, and2, and3, and4: std_logic_vector(3 downto 0);
signal sumando1, sumando2, sumando3, sumando4: std_logic_vector(7 downto 0) := (others => '0');
signal res_adder1, res_adder2, res_adder3: std_logic_vector(7 downto 0) := (others => '0');

component adder8b is
    port( a: in  std_logic_vector(7 downto 0);
          b: in  std_logic_vector(7 downto 0);
          c: out std_logic_vector(7 downto 0) );
end component;

component and4b is
port(x : in std_logic_vector(3 downto 0);
	 y : in std_logic;
     res_and : out std_logic_vector(3 downto 0)
		  );
end component;

begin
------- primera suma ----------
 and_1: and4b port map
    ( x => X,
      y => Y(0),
      res_and => and1);
 
 and_2: and4b port map
    ( x => X,
      y => Y(1),
      res_and => and2);

sumando1(3 downto 0) <= and1;  
sumando2(4 downto 1) <= and2;  
      
 add_1: adder8b port map
    ( a => sumando1,
      b => sumando2,
      c => res_adder1);
      
------- segunda suma ---------------
 and_3: and4b port map
    ( x => X,
      y => Y(2),
      res_and => and3);
 
 sumando3(5 downto 2) <= and3;
  
 add_2: adder8b port map
    ( a => res_adder1,
      b => sumando3,
      c => res_adder2);  
      
-------- ultima suma -------------------
and_4: and4b port map
    ( x => X,
      y => Y(3),
      res_and => and4);
 
 sumando4(6 downto 3) <= and4;
  
 add_3: adder8b port map
    ( a => res_adder2,
      b => sumando4,
      c => res_adder3);        

 Z <= res_adder3;
        
end beh;
-----------------------------------------------------------------