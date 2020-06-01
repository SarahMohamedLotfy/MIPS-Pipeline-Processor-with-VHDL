LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity ForwardingUnit is
  port (
    HasRt:in std_logic;
    MEM_WBRegisterRd,EX_MEMRegisterRd,ID_EXRegisterRs,ID_EXRegisterRt:IN std_logic_vector(2 downto 0);
    EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMSWAP,MEM_WBSWAP:IN std_logic;
    ForwardA,ForwardB:OUT std_logic_vector(1 downto 0)
  ) ;
end ForwardingUnit ;

architecture arch of ForwardingUnit is
begin
ForwardA <= "10" when ((EX_MEMRegWrite='1' or EX_MEMSWAP='1')  and (EX_MEMRegisterRd = ID_EXRegisterRs))else
 "01"  when  ((MEM_WBRegWrite='1' or MEM_WBSWAP='1')  and (MEM_WBRegisterRd = ID_EXRegisterRs)) else "00";

 -- hasRt =0  then one operand that means that rt feild always equal zeros 
 ForwardB <= "10" when ((EX_MEMRegWrite='1' or EX_MEMSWAP='1')and (EX_MEMRegisterRd = ID_EXRegisterRt)and HasRt='1')    else
  "01"  when  ((MEM_WBRegWrite='1' or MEM_WBSWAP='1')and (MEM_WBRegisterRd = ID_EXRegisterRt)and HasRt='1') else "00" when HasRt='0'; 

end architecture ; 
