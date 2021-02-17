----------------------------------------------------------------------------------
-- NOMBRE Y APELLIDOS: MARYNY ZARA CASTADA COLLADO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
 
entity mult8b_secuencial is
  Port ( A: in std_logic_vector(3 downto 0);
         B: in std_logic_vector(3 downto 0);
         ini: in std_logic;
         rst: in std_logic;
         clk: in std_logic;
         leds: out std_logic_vector(15 downto 0);
         res_out: out std_logic_vector(7 downto 0)
--         fin: out std_logic;
--         display_enable: out std_logic_vector(3 downto 0);
--         displays: out std_logic_vector(6 downto 0)
--        unidades: out std_logic_vector(3 downto 0);
--        decenas: out std_logic_vector(3 downto 0);
--        centenas: out std_logic_vector(3 downto 0)
   );
end mult8b_secuencial;

architecture rtl of mult8b_secuencial is
    signal ctrl_in: std_logic_vector(7 downto 0);
    signal flags_out: std_logic_vector(1 downto 0);
--    signal res_aux: std_logic_vector(7 downto 0);
    signal resul: std_logic_vector(7 downto 0);
--    signal bcd: std_logic_vector(11 downto 0);
      
--    signal centenas: std_logic_vector(3 downto 0);
--    signal decenas: std_logic_vector(3 downto 0);
--    signal unidades: std_logic_vector(3 downto 0);
    
--    signal display_0: std_logic_vector(6 downto 0);
--    signal display_1: std_logic_vector(6 downto 0);
--    signal display_2: std_logic_vector(6 downto 0);
--    signal display_3: std_logic_vector(6 downto 0) := "1000000";
--    signal contador: STD_LOGIC_VECTOR (19 downto 0);
--    signal contador_aux: std_logic_vector(1 downto 0);
    --    signal deb: std_logic;
    
    
    component ruta_datos is
        port( A: in std_logic_vector(3 downto 0);
              B: in std_logic_vector(3 downto 0);
              clk: in std_logic;
              rst: in std_logic;
              ctrl: in std_logic_vector(7 downto 0);
              res: out std_logic_vector(7 downto 0);
              flags: out std_logic_vector(1 downto 0)
        ); 
    end component;
    
    component unidad_control is
        port( clk: in std_logic;
              rst: in std_logic;
              ini: in std_logic;
              leds_out: out std_logic_vector(15 downto 0);
              ctrl: out std_logic_vector(7 downto 0);
              flags: in std_logic_vector(1 downto 0)
--              fin: out std_logic
        );
    end component;
    
--    component debouncer is
--        PORT (
--            rst: IN std_logic;
--            clk: IN std_logic;
--            x: IN std_logic;
--            xDeb: OUT std_logic;
--            xDebFallingEdge: OUT std_logic;
--            xDebRisingEdge: OUT std_logic
--        );
--    end component;
    
--    component conv_7seg
--     Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
--           display : out  STD_LOGIC_VECTOR (6 downto 0));
--    end component;
 
begin
--    elim_rebotes: debouncer port map(
--        rst => rst,
--        clk => clk,
--        x => ini, 
--        xDeb => open,
--        xDebFallingEdge => open,
--        xDebRisingEdge => deb
--    );
    
    i_rd: ruta_datos port map(
        A => A,
        B => B, 
        clk => clk,
        rst => rst,
        ctrl => ctrl_in,
        res => resul,
        flags => flags_out
    );
    
    res_out <= resul;
--    res_aux <= resul;
    
    i_uc: unidad_control port map(
        clk => clk,
        rst => rst,
        ini => ini,
        leds_out => leds,
        ctrl => ctrl_in,
        flags => flags_out
 --       fin => fin
    ); 
   
--    p_bcd: process (res_aux)
--        variable v_res: std_logic_vector(7 downto 0);
--        variable v_bcd: std_logic_vector(11 downto 0);
      
--    begin
--        v_res := res_aux;
--        v_bcd := (others => '0');
    
--        for i in 0 to 7 loop
--            v_bcd := v_bcd(11 downto 1) & v_res(7);
--            v_res := v_res(7 downto 1) & '0';
            
--            if v_bcd(3 downto 0) > "0100" then
--                v_bcd(3 downto 0) := v_bcd(3 downto 0) + "0011";
--            end if;
--            if v_bcd(7 downto 4) > "0100" then
--                v_bcd(7 downto 4) := v_bcd(7 downto 4) + "0011";
--            end if;
--            if v_bcd(11 downto 8) > "0100" then
--                v_bcd(11 downto 8) := v_bcd(11 downto 8) + "0011";
--            end if;            
--        end loop;
        
--        bcd <= v_bcd;
        
--    end process;
    
--    p_bcd_out: process(bcd)
--    begin
--        centenas <= bcd(11 downto 8);
--        decenas <= bcd(7 downto 4);
--        unidades <= bcd(3 downto 0);
--    end process;
    
    
--    i_display2: conv_7seg port map( x => centenas, display => display_2);
--    i_display1: conv_7seg port map(x => decenas,display => display_1);
--    i_display0: conv_7seg port map(x => unidades, display => display_0);
    
--     p_contador: process(clk,rst)
--     begin 
--        if rst='1' then
--            contador <= (others => '0');
--        elsif rising_edge(clk) then
--            contador <= contador + 1;
--        end if;
--    end process;
    
--    displays <= display_0 when (contador(19 downto 18) = "00") else
--                display_1 when (contador(19 downto 18) = "01") else
--                display_2 when (contador(19 downto 18) = "10") else
--                display_3;
    
    
--    display_enable <= "1110" when (contador(19 downto 18) = "00") else
--                      "1101" when (contador(19 downto 18) = "01") else
--                      "1011" when (contador(19 downto 18) = "10") else
--                      "0111";

end rtl;
