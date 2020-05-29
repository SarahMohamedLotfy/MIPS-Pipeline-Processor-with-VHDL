library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is 
port(clk: in std_logic;
     inputState,T_NT:in std_logic_vector(1 downto 0);
     --T/NT --> 00 Taken ,01 Not Taken , 10 not jz,11 not jz
     --if not jz then reset state
     IF_IDFlush:OUT std_logic;
     prediction_state: out std_logic_vector(1 downto 0));
-- 00 weakly not taken ,, 01 strongly not taken ,, 10 weakly taken ,, 11 strongly taken
		
     
     
end FSM;

architecture behavioural of FSM is 
type State_type  is (strongly_not_taken, weakly_not_taken, weakly_taken, strongly_taken);
signal current_state, prev_state,next_state :State_type;
signal reset,taken,IF_IDFlushSig:std_logic;

begin 
reset<=T_NT(1); 
taken<=T_NT(0);
IF_IDFlush<=IF_IDFlushSig when reset='0' else '0';    
process(clk,reset)
begin
if(reset='1')then
     if(inputState="00")then
          prev_state <=weakly_not_taken;
     elsif(inputState="01")then
          prev_state <=strongly_not_taken;
     elsif(inputState="10")then
          prev_state <=weakly_taken;
     elsif(inputState="11")then
          prev_state <=strongly_taken;
     end if;
 
elsif reset='0' then
     current_state<=prev_state;
end if;
end process;

process(current_state, taken,reset)
begin
if(reset='0')then     
     case (current_state) is 
     when strongly_not_taken=>
          if taken='0'then--taken
          next_state<=weakly_not_taken;
          elsif(taken ='1')then
          next_state<=strongly_not_taken;
          end if;
     when weakly_not_taken=>
          if taken='0' then
          next_state<= weakly_taken;    
          elsif(taken ='1')then
          next_state<=strongly_not_taken;
     end if;
     when weakly_taken=>
          if taken='0'then
          next_state<= strongly_taken;
          elsif(taken ='1')then
          next_state<=weakly_not_taken;
          end if;
     when strongly_taken=>
          if taken='0'then
          next_state<=strongly_taken; 
          elsif(taken ='1')then
          next_state<=weakly_taken;  
          end if;
     end case;
end if;

end process;

process(next_state)
begin 
case next_state is
     when strongly_not_taken =>
     IF_IDFlushSig<='0';
     prediction_state<="01";--strongly not taken
     
     when weakly_not_taken =>
     IF_IDFlushSig<='1';     
     prediction_state<="00";--weakly not taken
     
     when weakly_taken =>
     IF_IDFlushSig<='1';     
     prediction_state<="10"; -- weakly taken 
     
     when strongly_taken => 
     IF_IDFlushSig<='0';
     prediction_state<="11"; --strongly taken
end case;

end process;


 


end behavioural;

