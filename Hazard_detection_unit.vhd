library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_detection_unit is 
generic (n:integer := 32);
port(	
  ID_EX_RegisterRegdst,IF_ID_RegisterRs,IF_ID_RegisterRt : in std_logic_vector(3-1 downto 0);
	ID_EX_MemRead,reset : in std_logic;
  PCwrite,IF_ID_write,ControlUnit_Mux_Selector :out std_logic
);
end entity;

architecture Hazard_detection_unit_arch of Hazard_detection_unit is

begin

process (ID_EX_RegisterRegdst,IF_ID_RegisterRs,IF_ID_RegisterRt,ID_EX_MemRead)
begin
   if (reset ='1')then 
     -- Initialization
     ControlUnit_Mux_Selector <= '0';
     PCwrite<= '1';
     IF_ID_write <= '1';   
    else
    if  reset ='0' and ID_EX_MemRead ='1' and ID_EX_RegisterRegdst /="000" and  ((ID_EX_RegisterRegdst = IF_ID_RegisterRs) or (ID_EX_RegisterRegdst = IF_ID_RegisterRt)) then 
        PCwrite<= '0';
        IF_ID_write <= '0';
        ControlUnit_Mux_Selector <= '1';
    else
    PCwrite<= '1';
    IF_ID_write <= '1';
    ControlUnit_Mux_Selector <= '0';
    end if;
 end if;      
    
   end process;
end architecture;




