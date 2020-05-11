LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY decision IS
GENERIC (n:integer:=32);
	PORT (
		PCreg,DecodePC,TargetAddress,MemoryPC:	IN	std_logic_vector(n-1 downto 0);
		rst,clk,ReadFromMemorySignal,JZ,UnconditionBranch:	IN	std_logic;
		T_NT,State:IN std_logic_vector(1 downto 0);
		--T/NT --> 00 Taken ,01 Not Taken , 10 not jz,11 not jz
		--State output of BHT table for JZ instruction.
		-- 00 weakly not taken ,, 01 strongly not taken ,, 10 weakly taken ,, 11 strongly taken
		IF_IDFlush:OUT std_logic;
		PCnext		:	OUT	std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE decisionArch of decision is
signal dummy: std_logic;
signal PC_1,DecodePC_1:std_logic_vector(n-1 downto 0);

begin
PC_1<=std_logic_vector(unsigned(PCreg) + 1);
DecodePC_1<=std_logic_vector(unsigned(PCreg) + 1);
PCnext<=TargetAddress when (JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "10" or State = "11")) 
else PC_1 when (JZ ='1' and (T_NT ="11" or T_NT ="10") and (State = "00" or State = "01"))
else TargetAddress when (JZ ='0' and T_NT ="00") or (JZ ='1' and T_NT ="00") or UnconditionBranch='1'
else PC_1 when (JZ ='0' and T_NT ="01")
else DecodePC when (JZ ='1' and T_NT ="01")
else MemoryPC when ReadFromMemorySignal='1';

IF_IDFlush<='1' when T_NT = "01"else '0';
END ARCHITECTURE;



