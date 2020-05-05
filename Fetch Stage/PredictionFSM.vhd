library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is 
port(clock: in std_logic;
     reset: in std_logic:='0';
     taken: in std_logic:='0';--not taken = 0 , taken = 1
     predict_taken: out std_logic:='0';
	 prediction_state: out std_logic_vector(1 downto 0));
     
     
end FSM;

architecture behavioural of FSM is 
type State_type  is (strongly_not_taken, weakly_not_taken, weakly_taken, strongly_taken);
signal current_state, next_state :State_type;

begin 
process(clock,reset)
begin
 if(reset='1') then
  current_state <= strongly_not_taken;
 elsif(rising_edge(clock)) then
  current_state <= next_state;
 end if;
end process;

process(current_state, taken)
begin
case (current_state) is 
when strongly_not_taken=>
     if taken='1'then
	next_state<=weakly_not_taken;
     else 
	next_state<=strongly_not_taken;
     end if;
when weakly_not_taken=>
     if taken='1' then 
	next_state<=weakly_taken;
     else 
	next_state<=strongly_not_taken;
    end if;
when weakly_taken=>
     if taken='1'then 
	next_state<=strongly_taken;
     else 
	next_state<=weakly_not_taken;
     end if;
when strongly_taken=>
     if taken='1'then
	next_state<=strongly_taken;
     else 
	next_state<=weakly_taken;
     end if;
end case;


end process;

process(current_state)
begin 
 case current_state is
 when strongly_not_taken =>
  predict_taken <= '0';
  prediction_state<="10";--strongly not taken
 when weakly_not_taken =>
  predict_taken <= '0'; 
  prediction_state<="00";--weakly not taken
 when weakly_taken => 
  predict_taken <= '1'; 
  prediction_state<="01"; -- weakly taken 
 when strongly_taken =>
  predict_taken <= '1'; 
  prediction_state<="11"; --strongly taken
  

 end case;
end process;


 


end behavioural;

