library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity BranchHazard is 
generic (
         n        :integer:=32;
         indexBits:integer:=5;
         RBits    :integer:=3;
         RtBits   :integer:=3;
         selector :integer:=3);
    port(
        reset            : in  std_logic:='0';
        clk              : in  std_logic;
        Rs_instr_fetch   : in std_logic_vector(RBits-1 downto 0);
        Reg_write_decode : in std_logic;
        RegDst_decode : in std_logic;
        Reg_Rd_EX        : in std_logic_vector(RBits-1 downto 0);
        Rs_instr_decode  : in std_logic_vector(RBits-1 downto 0);
        Rdst_instr_decode: in std_logic_vector(RBits-1 downto 0);
        ID_EX_RegWrite   : in std_logic;
        ID_EX_instr_Rs   : in std_logic_vector(RBits-1 downto 0); 
        ID_EX_instr_Rd   : in std_logic_vector(RBits-1 downto 0);
        Rdst_decode      : in std_logic_vector(RBits-1 downto 0);
        Swap_decode      : in std_logic;
        ID_EX_swap       : in std_logic;
        PC_write         : out std_logic;
        IF_ID_flush      : out std_logic;
        Target_Selector  : out std_logic_vector(selector-1 downto 0)

        ); 
     
     
end BranchHazard;

architecture BranchHazardArch of BranchHazard is 

begin 
process (clk,reset)
begin 
if (Reg_write_decode='1'and RegDst_decode='0' and Rdst_instr_decode=Rs_instr_fetch) then
 
     PC_write<='0'; -- stall
    IF_ID_flush<='1';--flushing
    Target_Selector<="XX";


elsif(Reg_write_decode='1' and RegDst_decode='1' and Rs_instr_decode=Rs_instr_fetch) then 
    PC_write<='0'; -- stall
    IF_ID_flush<='1';--flushing 
    Target_Selector<="XX";


elsif(ID_EX_RegWrite='1' and Reg_Rd_EX=Rs_instr_fetch) then 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="000";


elsif(Swap_decode='1' and Rs_instr_decode=Rs_instr_fetch) then 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="001"; --src2 from decode 

 
elsif(Swap_decode='1' and Rs_instr_fetch=Rdst_instr_decode) then 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="010"; --src1 from execute 

elsif(ID_EX_swap='1' and ID_EX_instr_Rs=Rs_instr_fetch) then 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="011"; --src2 from execute  

elsif(ID_EX_swap='1' and ID_EX_instr_Rd=Rs_instr_fetch) then 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="100"; --src1 from execute  

else 
    IF_ID_flush<='0';
    PC_write<='1'; 
    Target_Selector<="101"; --normal data from decode   
end if;

end process;


end architecture;