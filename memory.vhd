library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is 
generic (n:integer := 32);
port(	
  reset, clk: in std_logic;
	EX_MEM:in std_logic_vector(145 downto 0);

  Rsrc2o,Addresso,ALUresulto, resultfrommemory :out std_logic_vector(n-1 downto 0);
  SWAPo, memTorego,regWriteo,outenableo :out std_logic;
  Rso :out std_logic_vector(3-1 downto 0)
);
end entity;

architecture memory_arch of memory is
 
  signal Rsrc2:std_logic_vector(n-1 downto 0);
	signal SWAP, interrupt,RRI,CRR,memRead,memWrite,memToreg,regWrite,outenable:  std_logic;
	signal Rs,Rdst : std_logic_vector(3-1 downto 0);
	signal spType :std_logic_vector(2-1 downto 0);
	signal ALUresult,PC,Address : std_logic_vector(n-1 downto 0);
	
  
begin
  
Rsrc2 <= EX_MEM( 145 downto 114);
SWAP<= EX_MEM(113);
Rs <= EX_MEM( 112 downto 110);
ALUresult<= EX_MEM( 109 downto 78);
PC<= EX_MEM( 76 downto 45);
Address<= EX_MEM( 44 downto 13);
Rdst<= EX_MEM( 12 downto 10);
interrupt<= EX_MEM(9);
RRI<= EX_MEM(8);
CRR<= EX_MEM(7);
memRead <= EX_MEM(6);
memWrite <= EX_MEM(5);
spType <= EX_MEM( 4 downto 3);
memToreg <= EX_MEM( 2);
regWrite <= EX_MEM(1);
outenable <= EX_MEM(0);

process (clk)
begin
if rising_edge(clk) then
   if (reset ='1')then 
    Rsrc2o<= "00000000000000000000000000000000";
    Addresso<= "00000000000000000000000000000000";
    ALUresulto<=  "00000000000000000000000000000000";
    
    SWAPo<= '0';
    Rso<= "000";
    memTorego<= '0';
    regWriteo<= '0';
    outenableo <=outenable ;
    resultfrommemory<="00000000000000000000000000000000";
     
   
   else  
    Rsrc2o<=Rsrc2;
    Addresso<=Address ;
    ALUresulto<= ALUresult;
    
    SWAPo<=SWAP;
    Rso<= Rs;
    memTorego<= memToreg;
    regWriteo<= regWrite;
    outenableo <=outenable ;
    resultfrommemory<="00000000000000000000000000000000";
     
    end if;
  end if;
  end process;
end architecture;




