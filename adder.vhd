LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY adder IS
	PORT
	( -- Entity section listing all inputs and outputs
	   hex_A												: in std_logic_vector(3 downto 0); -- first 4 bits of switches
	   hex_B												: in std_logic_vector(3 downto 0); -- second 4 bits of switches
		sum												: out std_logic_vector(7 downto 0) -- 8 bit output of addition
   );
	
END ENTITY adder;

ARCHITECTURE logic OF  adder IS
	-- 8 bit signal variables to store hex inputs after concatenation
	signal add_inpA: 					std_logic_vector(7 downto 0);
	signal add_inpB: 					std_logic_vector(7 downto 0);

BEGIN
	-- concatentating hex values with 4 zeroes to create 8 bit numbers and avoid overflow errors
	add_inpA <= "0000" & hex_A;
	add_inpB <= "0000" & hex_B;

	-- adding logic where binary inputs are converted to integer values added and then again
	-- stored as binary into the sum variable
	sum (7 downto 0)<= std_logic_vector(unsigned(add_inpA) + unsigned(add_inpB));
	
END logic;