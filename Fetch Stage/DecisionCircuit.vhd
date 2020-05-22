LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY decision IS
GENERIC (n:integer:=32);
	PORT (
		PCreg,DecodePC,TargetAddress,oldTargetAddress,MemoryPC:	IN	std_logic_vector(n-1 downto 0);
		rst,clk,ReadFromMemorySignal,JZ,UnconditionBranch,IF_IDFLUSH:	IN	std_logic;
		T_NT,State:IN std_logic_vector(1 downto 0);
		--T/NT --> 00 Taken ,01 Not Taken , 10 not jz,11 not jz
		--State output of BHT table for JZ instruction.
		-- 00 weakly not taken ,, 01 strongly not taken ,, 10 weakly taken ,, 11 strongly taken
		PCnext		:	OUT	std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE decisionArch of decision is
signal dummy: std_logic;
signal PC_1,DecodePC_1,tempPCNext:std_logic_vector(n-1 downto 0);

begin
PC_1<=std_logic_vector(unsigned(PCreg) + 1);
DecodePC_1<=std_logic_vector(unsigned(PCreg) + 1);


PCnext<= TargetAddress when (JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "10" or State = "11")) 
else 
PC_1 when (JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "00" or State = "01"))
else 
TargetAddress when (UnconditionBranch='1')
else
oldTargetAddress when (IF_IDFLUSH='1' and T_NT = "00")
else 
DecodePC_1 when (IF_IDFLUSH='1' and T_NT = "01")
else
MemoryPC when (ReadFromMemorySignal='1')
else 
PC_1;

-- process(clk,rst,TargetAddress,PC_1,DecodePC,MemoryPC,JZ,T_NT,State,UnconditionBranch,ReadFromMemorySignal)

-- begin	
-- if rst ='1' then
-- 	tempPCNext<=PCreg;	
	
-- else 	
-- 	if(JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "10" or State = "11")) then
-- 		tempPCNext<=TargetAddress;
		
-- 	elsif (JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "00" or State = "01"))  then
-- 		tempPCNext <= PC_1;
		
-- 	elsif (UnconditionBranch='1')  then
-- 		tempPCNext<=TargetAddress;
		
-- 	elsif (IF_IDFLUSH='1' and T_NT = "00") then -- wrong decision and the true is taken then Target Address
-- 	tempPCNext<=oldTargetAddress;
		
-- 	elsif (IF_IDFLUSH='1' and T_NT = "01") then -- wrong decision and the true is not taken then next instruction after jz ,, DEcodePC+1
-- 	tempPCNext<=DecodePC_1;
-- 	elsif (ReadFromMemorySignal='1') then
-- 		tempPCNext<=MemoryPC;
-- 	else
-- 	tempPCNext<=PC_1;
-- 	end if;
	
-- end if;
-- end process;

-- process(tempPCNext,clk)
-- begin 
-- PCnext<= tempPCNext;
-- 	end process;
END ARCHITECTURE;



