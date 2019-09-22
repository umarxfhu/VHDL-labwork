LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hex_mux IS
	PORT
	( 
		-- this is a 4:1 mux with 2 select lines where two of the lines take the regular inputs
		-- (sum or logic/operands) and the other take in "88" for the seven segment or "11111111" for the leds
	   hex_0												: in std_logic_vector(7 downto 0); 
		hex_1												: in std_logic_vector(7 downto 0);
	   hex_2												: in std_logic_vector(7 downto 0);
		hex_3												: in std_logic_vector(7 downto 0);		
		mux_select1										: in std_logic; -- the select lines are pb(3) and 'error'
		mux_select2										: in std_logic;
		hex_out											: out std_logic_vector(7 downto 0) -- output 8 bit value
   );
	
END ENTITY hex_mux;

ARCHITECTURE mux_logic OF  hex_mux  IS

	signal mux_select21 		: std_logic_vector(1 downto 0); 
	-- signal variable to store the two seperate select line values as a 2 bit entity

BEGIN

	mux_select21  <=  mux_select2 & mux_select1; -- concatenation

with mux_select21 select
hex_out <= 	hex_0 when "00", -- operands/sum
				hex_1 when "01", -- error
				hex_2 when "10", -- sum/logic
				hex_3 when "11"; -- error
				
END mux_logic;