library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity BranchPC is 
generic (n:integer:=32;
         indexBits:integer:=5);
port(
     reset : in  std_logic:='0';
	clk   : in  std_logic;
     enable: in  std_logic:='0';--jz is an enable 
     PC    : in  std_logic_vector(n-1 downto 0);--updated--not include in doc , input PC 
     index : out std_logic_vector(indexBits-1 downto 0);
     PCinc : out std_logic_vector(n-1 downto 0));
     
     
end BranchPC;

architecture BranchPCArch of BranchPC is 
signal dummy   : std_logic; --dummy signal not used 
signal tmpPCinc: std_logic_vector(n-1 downto 0);

begin 
PCAdder:entity work.adder generic map(n)port map(PC,"00000000000000000000000000000001",'0',tmpPCinc,dummy);

process(clk) 
  begin 
     if enable='1'then 
          PCinc<=tmpPCinc;
          index<=PC(indexBits-1 downto 0);
     else 
          PCinc<=(others => 'Z' );
          index<=(others => 'Z' );
     end if;
  end process;
end architecture;