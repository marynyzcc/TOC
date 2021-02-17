-- We add the libraries needed
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Entity declaration
ENTITY simadd IS
END simadd;

-- Architecture
ARCHITECTURE testbench_arch OF simadd IS
    -- Component declaration
    COMPONENT adder4b
    PORT(
         a : IN  std_logic_vector(3 downto 0);
         b : IN  std_logic_vector(3 downto 0);
         c : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;

   -- Inputs
   signal a : std_logic_vector(3 downto 0) := (others => '0');
   signal b : std_logic_vector(3 downto 0) := (others => '0');

   -- Outputs
   signal c : std_logic_vector(3 downto 0);

   BEGIN
     -- Instantiation of the unit under test
      uut: adder4b PORT MAP (
             a => a,
             b => b,
             c => c );
     -- Stimuli process
   stim_proc: process
       begin
           a <= "0000";        b <= "0000";
           wait for 100 ns;
           a <= "0101";        b <= "0100";
           wait for 100 ns;
           a <= "0000";        b <= "0111";
           wait for 100 ns;
           a <= "0011";        b <= "1000";
           wait for 100 ns;
           a <= "1011";        b <= "1111";
           wait for 100 ns;
           a <= "1001";        b <= "0110";
           wait;
   end process;

   END testbench_arch;
