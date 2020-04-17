

	
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY ALU2 IS  
		PORT (	S	:  IN STD_LOGIC_VECTOR(3 downto 0);
			Cin,EN: 	IN STD_LOGIC;
            A:         in     STD_LOGIC_VECTOR(15 downto 0);
			B:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:          out STD_LOGIC_VECTOR(15 downto 0);
			ZF,SignF,Parity,OVF :out STD_LOGIC;
			Cout:	   OUT STD_LOGIC
);
									
  		                
END ENTITY ALU2;


ARCHITECTURE DataFlow OF ALU2 IS

COMPONENT PartB is
   PORT (		S0,S1	:  IN STD_LOGIC;
              		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			B:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:         out STD_LOGIC_VECTOR(15 downto 0)
);
END COMPONENT;

COMPONENT PartC is
PORT (			S0,S1	:  IN STD_LOGIC;
			Cin: 	IN STD_LOGIC;			
              		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:          out STD_LOGIC_VECTOR(15 downto 0);
			Cout:	   OUT STD_LOGIC
			);
END COMPONENT;

COMPONENT PartD IS
PORT (			S0,S1	:  IN STD_LOGIC;
			Cin: 	IN STD_LOGIC;			
	      		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:          out STD_LOGIC_VECTOR(15 downto 0);
			Cout:	   OUT STD_LOGIC
			);
END COMPONENT;

component PartA is 
generic (n:integer:=16);
PORT (		S0,S1	:  IN STD_LOGIC;
            A:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			B:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			Cin: 	IN STD_LOGIC;
			Cout,OVF: out std_logic;
			F:out STD_LOGIC_VECTOR(n-1 downto 0)
);							
end component;

SIGNAL outputB,outputC,outputD: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL outputA:STD_LOGIC_VECTOR(15 downto 0);
SIGNAL CarryC,CarryD,CarryA: STD_LOGIC;
signal temp :STD_LOGIC_VECTOR(15 downto 0);
signal ov:STD_LOGIC;
BEGIN
PB:PartB PORT MAP(S(0),S(1),A,B,outputB);
PC:PartC PORT MAP(S(0),S(1),Cin,A,outputC,CarryC);
PD:PartD PORT MAP(S(0),S(1),Cin,A,outputD,CarryD);
pA:PartA generic map (n=>16) port map(S(0),S(1),A,B,Cin,CarryA,ov,outputA);	
	
		 temp <= outputB when(S(3 downto 0) = "0100" or S(3 downto 0) = "0101" or S(3 downto 0) = "0110" or S(3 downto 0) = "0111")else 
			
		  outputC  when (S(3 downto 0) = "1000" or S(3 downto 0) = "1001" or S(3 downto 0) = "1010" or S(3 downto 0) = "1011")else 
			
		 outputD when (S(3 downto 0) = "1100" or S(3 downto 0) = "1101" or S(3 downto 0) = "1110" or S(3 downto 0) = "1111")else
		 outputA when (S(3 downto 0) = "0000" or S(3 downto 0) = "0001" or S(3 downto 0) = "0010" or S(3 downto 0) = "0011"); 
		
		 
		process(temp,EN)
		begin
		if (EN = '1')then 
			 Cout <= CarryC  when (S(3 downto 0) = "1000" or S(3 downto 0) = "1001" or S(3 downto 0) = "1010" or S(3 downto 0) = "1011")else 
			 CarryD when (S(3 downto 0) = "1100" or S(3 downto 0) = "1101" or S(3 downto 0) = "1110" or S(3 downto 0) = "1111")else
			 CarryA when (S(3 downto 0) = "0000" or S(3 downto 0) = "0001" or S(3 downto 0) = "0010" or S(3 downto 0) = "0011");
			 F <= temp;	
			ZF <= '1' when(temp = "0000000000000000")else
				'0' when (temp /= "0000000000000000");
			SignF <= temp(15);
			Parity <= not(xor temp);
			OVF<=ov;
		end if;
		end process;
END DataFlow;