library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
generic (n:integer := 32);
port(	
  interrupt: in std_logic;
	reset : in std_logic ; 
	clk: in std_logic ;
	flush_decoderInput: in std_logic ;
	
	RegWrite:in std_logic ;
	Swap:    in std_logic ;
	Rt_from_fetch	: in std_logic_vector(3-1 downto 0);
	IF_ID_Rt	: in std_logic_vector(3-1 downto 0);
	IF_ID_Rs	: in std_logic_vector(3-1 downto 0);
	Mem_Wb_Rd	: in std_logic_vector(3-1 downto 0);
	value1:in std_logic_vector(n-1 downto 0);
	Mem_Wb_Rs	: in std_logic_vector(3-1 downto 0);
	value2:in std_logic_vector(n-1 downto 0);
	
	Target_Address :out std_logic_vector(n-1 downto 0);
	Rsrc1 :out std_logic_vector(n-1 downto 0);
	Rsrc2 :out std_logic_vector(n-1 downto 0);
	flush_decoder:out std_logic
);
end entity;

architecture decoder_arch of decoder is
  type registerFile is array(0 to 6) of std_logic_vector(n-1 downto 0);
  signal registers : registerFile;
  
begin
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
    
   elsif (flush_decoderInput='1')
         flush_decoder<='1';
   
   
   else  
      -- Read registers
      if (RegWrite = '0') and (Swap = '0') then
        
         Target_Address <= registers(to_integer(unsigned(Rt_from_fetch)));
         if Rs ="000" and Rt /="000" then
          Rsrc1 <= registers(to_integer(unsigned(IF_ID_Rt)));
          Rsrc2 <= (others=>'0');
          else
          Rsrc1 <= registers(to_integer(unsigned(IF_ID_Rs)));
          Rsrc2 <= registers(to_integer(unsigned(IF_ID_Rt)));
        end if;
         
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




