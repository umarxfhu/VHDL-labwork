LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY logic_processor IS
	PORT
	( 
		-- this component takes in hex values of the switch inputs and outputs logical operations for 
		-- pb(0): AND, pb(1): OR, and pb(2): XOR
	   	hex_A												: in std_logic_vector(3 downto 0);
	   	hex_B												: in std_logic_vector(3 downto 0);
		pb													: in std_logic_vector (2 downto 0);
		Logic_func											: out std_logic_vector(3 downto 0)
   );
	
END ENTITY logic_processor;

ARCHITECTURE logic OF  logic_processor IS
	
BEGIN
	-- depending on which push button is active the correct logic function will be activated
	-- if more than one pb is active or none are active then the output is set to be zero
	with pb(2 downto 0) select
	Logic_func <= 		hex_A AND hex_B when "001",
							hex_A OR hex_B when "010",
							hex_A XOR hex_B when "100",
							"0000" when others;
						
END logic;