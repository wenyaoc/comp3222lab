-- this design can be clocked as 604.96 MHz under 85C slow model
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L4P13 IS
	PORT(	KEY: IN std_logic_vector(2 DOWNTO 0);
			SW: IN std_logic_vector(9 DOWNTO 0);
			HEX0: OUT std_logic_vector(0 TO 6);
			HEX1: OUT std_logic_vector(0 TO 6);
			HEX2: OUT std_logic_vector(0 TO 6);
			HEX3: OUT std_logic_vector(0 TO 6));
END L4P13;

ARCHITECTURE structural OF L4P13 IS
	COMPONENT T_ff IS
		PORT(	T, Clk, Clearn :IN	std_logic;
				Q : BUFFER std_logic);
	END COMPONENT;
	COMPONENT seg_7 IS
		PORT(	v :IN	std_logic_vector(3 DOWNTO 0);
				d : OUT std_logic_vector(0 TO 6));
	END COMPONENT;
	-- your signal declarations
	SIGNAL T : std_logic_vector(7 DOWNTO 0);
	SIGNAL Q : std_logic_vector(7 DOWNTO 0);
	SIGNAL Clk: std_logic;
	SIGNAL Clearn: std_logic;
BEGIN

	HEX2 <= "1111111"; -- blank higher order HEX displays
	HEX3 <= "1111111";
	
	-- your signal assignments to external pins
 	Clk <= KEY(0);
	Clearn <= SW(0);
	T(0) <= SW(1);
	-- your VHDL code
	t1: T_ff PORT MAP (T(0), Clk, Clearn, Q(0));
	G1: For i IN 1 TO 7 GENERATE
		T(i) <= T(i-1) AND Q(i-1);
		t_2to8: T_ff PORT MAP (T(i), Clk, Clearn, Q(i));
	END GENERATE;	
	
	h0: seg_7 PORT MAP (Q(3 DOWNTO 0), HEX0);
	h1: seg_7 PORT MAP (Q(7 DOWNTO 4), HEX1);
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY T_ff IS
	PORT(	T, Clk, Clearn :IN	std_logic;
			Q : BUFFER std_logic);
END T_ff;

ARCHITECTURE behavioural OF T_ff IS
BEGIN

	-- your VHDL code from Part I Step 1
	PROCESS (Clearn, Clk)
	BEGIN
		IF Clearn = '0' THEN
			Q <= '0';
		ELSIF Clk'EVENT AND Clk = '1' THEN
			Q <= Q XOR T;
		END IF;
	END PROCESS;
	
END behavioural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY seg_7 IS
	PORT(	v :IN	std_logic_vector(3 DOWNTO 0);
			d : OUT std_logic_vector(0 TO 6));
END seg_7;

ARCHITECTURE behavioural OF seg_7 IS
BEGIN	
	PROCESS (v)
	BEGIN	
		CASE v IS             --0123456
			WHEN "0000" => d <= "0000001";
			WHEN "0001" => d <= "1001111";
			WHEN "0010" => d <= "0010010";
			WHEN "0011" => d <= "0000110";
			WHEN "0100" => d <= "1001100";
			WHEN "0101" => d <= "0100100";
			WHEN "0110" => d <= "0100000";
			WHEN "0111" => d <= "0001111";
			WHEN "1000" => d <= "0000000";
			WHEN "1001" => d <= "0001100";
			WHEN "1010" => d <= "0001000";
			WHEN "1011" => d <= "1100000";
			WHEN "1100" => d <= "0110001";
			WHEN "1101" => d <= "1000010";
			WHEN "1110" => d <= "0110000";
			WHEN "1111" => d <= "0111000";
			WHEN OTHERS => d <= "-------";
		END CASE;
	END PROCESS;
END behavioural;