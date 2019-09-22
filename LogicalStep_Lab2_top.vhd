library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb					: in	std_logic_vector(3 downto 0);	-- pushbuttons that will be used as inputs
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is

-- Components Used ---
--listing componentes used (additional comments are provided within the component files)
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component hex_mux port (
	   hex_0												: in std_logic_vector(7 downto 0);
		hex_1												: in std_logic_vector(7 downto 0);
	   hex_2												: in std_logic_vector(7 downto 0);
		hex_3												: in std_logic_vector(7 downto 0);		
		mux_select1										: in std_logic;
		mux_select2										: in std_logic;
		hex_out											: out std_logic_vector(7 downto 0)	-- used as the output variable from our hex_mux
		);
	end component;
	
	
	component Logic_Processor port (
		hex_A												: in std_logic_vector(3 downto 0);
	   hex_B												: in std_logic_vector(3 downto 0);
		pb													: in std_logic_vector (2 downto 0);
		Logic_func										: out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
	); 
	end component;

	component adder port(
	   hex_A												: in std_logic_vector(3 downto 0);
	   hex_B												: in std_logic_vector(3 downto 0);
		sum												: out std_logic_vector(7 downto 0)	
	);
	end component;


	signal seg7_A		: std_logic_vector(6 downto 0);		
	signal seg7_B		: std_logic_vector(6 downto 0);
	-- the above two variables to be used in processing the outputs of the seven segment display
	signal hex_A		: std_logic_vector(3 downto 0);
	--hex_A will hold the values of the first 4 switches
	signal hex_out		: std_logic_vector(7 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);
	--hex_B will hold the values of the second 4 switches
	signal hex_AB		: std_logic_vector(7 downto 0);
	--concatenates hex A and B to be used in inst5 of hex_mux
	signal seg_in1		: std_logic_vector(3 downto 0);
	signal seg_in2		: std_logic_vector(3 downto 0);
	-- the above two are the inputs to the two digits of the seven segment display
	signal logic		: std_logic_vector(7 downto 0);
	-- the output of logic processor concatenated with '0000'
	signal Logic_func	: std_logic_vector(3 downto 0);
	-- the output of logic processor
	signal sum			: std_logic_vector(7 downto 0);
	signal error		: std_logic;		-- error = 1 means two or more push buttons are pressed, error = 0 means everything is functioning normally
	
	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);				
	hex_B <= sw(7 downto 4);			
	seg_in1 <= hex_out(3 downto 0);		
	seg_in2 <= hex_out(7 downto 4);
	logic <= "0000" & Logic_func;
	hex_AB <= hex_B & hex_A;				
	error <= (not(pb(0)) and not(pb(1))) or (not(pb(0)) and not(pb(2))) or (not(pb(0)) and not(pb(3))) or (not(pb(1)) and not(pb(2))) or (not(pb(1)) and not(pb(3))) or (not(pb(2)) and not(pb(3)));
	-- the above error variable will be set to '1' if ANY of the two (or more) push buttons are pressed
	

	INST1: SevenSegment port map(seg_in1, seg7_A);
	INST2: SevenSegment port map(seg_in2, seg7_B);
	INST3: segment7_mux port map(clkin_50, seg7_B, seg7_A, seg7_data, seg7_char1, seg7_char2);
	INST4: adder port map (hex_A, hex_B, sum);
	INST5: hex_mux port map(hex_AB, "10001000", sum, "10001000", error, not(pb(3)), hex_out);	-- this function decides what will be the value to be displayed on the seven segment
											-- if error = 1 mux will output "10001000" ie the number 8
	INST6: hex_mux port map(logic, "11111111", sum, "11111111", error, not(pb(3)), leds);		--this function decides what will be displayed on the leds
											-- if error = 1 the mux will select to output all 1's ie all leds will be on
	INST7: Logic_Processor port map (hex_A, hex_B, not(pb(2 downto 0)), Logic_func);				-- the logic processor is what decides which operation will be done (ie and,or,xor)
	
end SimpleCircuit;

