library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
generic (n:integer := 32);
port(	
	interrupt,reset, clk: in std_logic;
	IF_ID:in std_logic_vector(5 downto 0);
	RegWriteinput,Swapinput:in std_logic;
	Mem_Wb_Rd,Mem_Wb_Rs,Rt_from_fetch: in std_logic_vector(2 downto 0);
  value1,value2 :in std_logic_vector(31 downto 0);
  
  Target_Address,Rsrc,Rdst :out std_logic_vector(n-1 downto 0)
);
end entity;

architecture decoder_arch of decoder is
  type registerFile is array(0 to 6) of std_logic_vector(n-1 downto 0);
  signal registers : registerFile;
  signal OpCode:std_logic_vector(5-1 downto 0);
	signal IF_ID_Rt,IF_ID_Rs:  std_logic_vector(3-1 downto 0);
  
begin
  
IF_ID_Rt <= IF_ID( 2 downto 0);
IF_ID_Rs <= IF_ID(5 downto 3);

process (clk)
begin
if rising_edge(clk) then
   if (reset ='1')then 
     
     -- Initialization
     Target_Address <= "00000000000000000000000000000000";
     Rsrc <= "00000000000000000000000000000000";
     Rdst <= "00000000000000000000000000000000";
     registers(0) <= "00000000000000000000000000000000";
     registers(1) <= "00000000000000000000000000000000";
     registers(2) <= "00000000000000000000000000000000";
     registers(3) <= "00000000000000000000000000000000";
     registers(4) <= "00000000000000000000000000000000";
     registers(5) <= "00000000000000000000000000000000";
     registers(6) <= "00000000000000000000000000000000";
 
   
   else  
      -- Read registers
      Rsrc <= registers(to_integer(unsigned(IF_ID_Rs)));
      Rdst <= registers(to_integer(unsigned(IF_ID_Rt)));
      if (RegWriteinput= '0') and (Swapinput = '0') then
        
         Target_Address <= registers(to_integer(unsigned(Rt_from_fetch)));
         
       
         
      -- Write in registers
      elsif (RegWriteinput = '1') and (Swapinput = '1') then
        registers(to_integer(unsigned(Mem_Wb_Rd))) <= value1;  
        registers(to_integer(unsigned(Mem_Wb_Rs))) <= value2; 
        
      elsif (RegWriteinput='1') then
        registers(to_integer(unsigned(Mem_Wb_Rd))) <= value1;
	
      else 
	      registers(to_integer(unsigned(Mem_Wb_Rs))) <= value2; 

      end if;
         
    end if;
  end if;
  end process;
end architecture;




