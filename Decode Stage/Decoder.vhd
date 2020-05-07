library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
generic (n:integer := 32);
port(	
  interrupt,reset, clk: in std_logic;
	flush_decoderInput: in std_logic ;
	IF_ID:in std_logic_vector(80 downto 0);
	
	Target_Address :out std_logic_vector(n-1 downto 0);
	Rsrc :out std_logic_vector(n-1 downto 0);
	Rdst :out std_logic_vector(n-1 downto 0);
	flush_decoder:out std_logic
);
end entity;

architecture decoder_arch of decoder is
  type registerFile is array(0 to 6) of std_logic_vector(n-1 downto 0);
  signal registers : registerFile;
  signal RegWrite,Swap : std_logic ;
	signal Rt_from_fetch,IF_ID_Rt,IF_ID_Rs,Mem_Wb_Rd,Mem_Wb_Rs:  std_logic_vector(3-1 downto 0);
	signal value1,value2: std_logic_vector(n-1 downto 0);


begin
  
RegWrite<=IF_ID(0);
Swap <= IF_ID(1);
Rt_from_fetch <=IF_ID(4 downto 2);
IF_ID_Rt <= IF_ID(7 downto 5);
IF_ID_Rs <= IF_ID(10 downto 8);
Mem_Wb_Rd <= IF_ID(13 downto 11);
Mem_Wb_Rs <= IF_ID(16 downto 14);
value1 <= IF_ID(48 downto 17);
value2 <= IF_ID(80 downto 49);
  
  
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
    
   elsif (flush_decoderInput='1')then
         flush_decoder<='1';
   
   
   else  
      -- Read registers
      if (RegWrite = '0') and (Swap = '0') then
        
         Target_Address <= registers(to_integer(unsigned(Rt_from_fetch)));
         Rsrc <= registers(to_integer(unsigned(IF_ID_Rs)));
         Rdst <= registers(to_integer(unsigned(IF_ID_Rt)));
       
         
      -- Write in registers
      elsif (RegWrite = '1') and (Swap = '1') then
        registers(to_integer(unsigned(Mem_Wb_Rd))) <= value1;  
        registers(to_integer(unsigned(Mem_Wb_Rs))) <= value2; 
        
      elsif (RegWrite ='1') then
        registers(to_integer(unsigned(Mem_Wb_Rd))) <= value1;
	
      else 
	      registers(to_integer(unsigned(Mem_Wb_Rs))) <= value2; 

      end if;
       
    
    end if;
  end if;
  end process;
end architecture;




