library ieee;
use ieee.std_logic_1164.all;  
use work.Pack.all;

-- OR_2 Gate
entity OR_2 is	 
	generic(
	OR_Delay:Time:=0 ns
	);
	port(
	A,B:in bit;
	F:out bit
	);
end OR_2;
architecture Behaviour_OR_2 of OR_2 is
begin	 
	process (A,B)
	begin
		F <= A or B after OR_Delay;
	end process;
end Behaviour_OR_2;	

-- AND_2 Gate
entity AND_2 is	 
	generic(
	AND_Delay:Time:=0 ns
	);
	port(
	A,B:in bit;
	F:out bit
	);
end AND_2;
architecture Behaviour_AND_2 of AND_2 is
begin
	process (A,B)
	begin
		F <= A and B after AND_Delay;
	end process;
end Behaviour_AND_2;

-- Half Adder
entity HalfAdder is	 
	generic(
	AND_Delay:Time:=0 ns;
	XOR_Delay:Time:=0 ns
	);
	port(
	A,B:in bit;
	Sum,Carry:out bit
	);
end HalfAdder;
architecture Behaviour_HalfAdder of HalfAdder is
begin	 
	Sum <= A xor B after XOR_Delay;
	Carry <= A and B after AND_Delay;
end Behaviour_HalfAdder;

-- Full Adder
entity FullAdder is
	generic(
	AND_Delay:Time:=0 ns;
	XOR_Delay:Time:=0 ns;
	OR_Delay:Time:=0 ns
	);
	port(
	A,B,Carry_In:in bit;
	Sum,Carry_Out:out bit
	);
end FullAdder;
architecture Behaviour_FullAdder of FullAdder is
	component HalfAdder	 
		generic(
		AND_Delay:Time:=0 ns;
		XOR_Delay:Time:=0 ns
		);
		port(
		A,B:in bit;
		Sum,Carry:out bit
		);
	end component;	
	component OR_2	 
		generic(
		OR_Delay:Time:=0 ns
		);
		port(
		A,B:in bit;
		F:out bit
		);
	end component;	
	signal Temp_Sum:bit;	
	signal Temp_Carry1:bit;
	signal Temp_Carry2:bit;
begin		 
	FullAdder_1: HalfAdder generic map(AND_Delay,XOR_Delay) port map(A,B,Temp_Sum,Temp_Carry1);
	FullAdder_2: HalfAdder generic map(AND_Delay,XOR_Delay) port map(Temp_Sum,Carry_In,Sum,Temp_Carry2);
	FullAdder_3: OR_2 generic map(OR_Delay) port map(Temp_Carry1,Temp_Carry2,Carry_Out);	
end Behaviour_FullAdder;

-- Adder
entity Adder is	 
	generic(
	BitCount:natural:=0;
	AND_Delay:Time:=0 ns;
	XOR_Delay:Time:=0 ns;
	OR_Delay:Time:=0 ns
	);
	port(
	A,B:in bit_Vector(BitCount-1 downto 0);
	Carry_In:in bit;
	Sum:out bit_Vector(BitCount-1 downto 0);
	Carry_Out:out bit
	);
end Adder;
architecture Behaviour_Adder of Adder is
	component FullAdder
		generic(
		AND_Delay:Time:=0 ns;
		XOR_Delay:Time:=0 ns;
		OR_Delay:Time:=0 ns
		);
		port(
		A,B,Carry_In:in bit;
		Sum,Carry_Out:out bit
		);
	end component;
	signal Temp_Carry:bit_vector(BitCount-1 downto 0);
begin
	Adder_1: FullAdder generic map(AND_Delay,XOR_Delay,OR_Delay) port map(A(0),B(0),Carry_In,Sum(0),Temp_Carry(0));
	Adder_2: for i in 1 to BitCount-2 generate
				 Adder_3: FullAdder generic map(AND_Delay,XOR_Delay,OR_Delay) port map(A(i),B(i),Temp_Carry(i-1),Sum(i),Temp_Carry(i));		
			 end generate;
	Adder_4: FullAdder generic map(AND_Delay,XOR_Delay,OR_Delay) port map(A(BitCount-1),B(BitCount-1),Temp_Carry(BitCount-2),Sum(BitCount-1),Carry_Out);
end Behaviour_Adder; 

-- Multi Plexer_2 Gate 1 Bit
entity MUX_2_1Bit is	 
	generic(
	MUX_2_Delay:Time:=0 ns
	);
	port(
	I0,I1:in bit;
	Sel:in bit;
	F:out bit
	);
end MUX_2_1Bit;
architecture Behaviour_MUX_2_1Bit of MUX_2_1Bit is
begin	 
	process(Sel)
	begin
		case Sel is
			when '0' => F <= I0 after MUX_2_Delay;
			when '1' => F <= I1 after MUX_2_Delay;
		end case;	
	end process;
end Behaviour_MUX_2_1Bit; 

-- Multi Plexer_2 Gate N Bit
entity MUX_2_nBit is	 
	generic(
	BitCount:natural:=0;
	MUX_2_Delay:Time:=0 ns
	);
	port(
	I0,I1:in bit_vector(BitCount-1 downto 0);
	Sel:in bit;
	F:out bit_vector(BitCount-1 downto 0)
	);
end MUX_2_nBit;
architecture Behaviour_MUX_2_nBit of MUX_2_nBit is
begin	 
	process(Sel)
	begin
		case Sel is
			when '0' => F <= I0 after MUX_2_Delay;
			when '1' => F <= I1 after MUX_2_Delay;
		end case;	
	end process;
end Behaviour_MUX_2_nBit; 

-- Multi Plexer_4 Gate N Bit
entity MUX_4_nBit is	 
	generic(
	BitCount:natural:=0;
	MUX_4_Delay:Time:=0 ns
	);
	port(
	I0,I1,I2,I3:in bit_vector(BitCount-1 downto 0);
	Sel:in bit_vector(1 downto 0);
	F:out bit_vector(BitCount-1 downto 0)
	);
end MUX_4_nBit;
architecture Behaviour_MUX_4_nBit of MUX_4_nBit is
begin
	process(Sel)
	begin
		case Sel is
			when "00" => F <= I0 after MUX_4_Delay;
			when "01" => F <= I1 after MUX_4_Delay;
			when "10" => F <= I2 after MUX_4_Delay;
			when "11" => F <= I3 after MUX_4_Delay;
		end case;	
	end process;	
end Behaviour_MUX_4_nBit;

-- Multi Plexer_8 Gate N Bit
entity MUX_8_nBit is	 
	generic(
	BitCount:natural:=0;
	MUX_8_Delay:Time:=0 ns
	);
	port(
	I0,I1,I2,I3,I4,I5,I6,I7:in bit_vector(BitCount-1 downto 0);
	Sel:in bit_vector(2 downto 0);
	F:out bit_vector(BitCount-1 downto 0)
	);
end MUX_8_nBit;
architecture Behaviour_MUX_8_nBit of MUX_8_nBit is
begin
	process(Sel)
	begin
		case Sel is	
			when "000" => F <= I0 after MUX_8_Delay;
			when "001" => F <= I1 after MUX_8_Delay;
			when "010" => F <= I2 after MUX_8_Delay;
			when "011" => F <= I3 after MUX_8_Delay;			
			when "100" => F <= I4 after MUX_8_Delay;
			when "101" => F <= I5 after MUX_8_Delay;
			when "110" => F <= I6 after MUX_8_Delay;
			when "111" => F <= I7 after MUX_8_Delay;
		end case;	
	end process;				 
end Behaviour_MUX_8_nBit;

-- Multi Plexer_32 Gate N Bit
entity MUX_32_nBit is	 
	generic(
	BitCount:natural:=0;
	MUX_32_Delay:Time:=0 ns
	);
	port(
	I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,
	I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,
	I21,I22,I23,I24,I25,I26,I27,I28,I29,I30,
	I31:in bit_vector(BitCount-1 downto 0);
	Sel:in bit_vector(4 downto 0);
	F:out bit_vector(BitCount-1 downto 0)
	);
end MUX_32_nBit;
architecture Behaviour_MUX_32_nBit of MUX_32_nBit is
begin
	process(Sel)
	begin
		case Sel is				
			when "00000" => F <= I0 after MUX_32_Delay;
			when "00001" => F <= I1 after MUX_32_Delay;
			when "00010" => F <= I2 after MUX_32_Delay;
			when "00011" => F <= I3 after MUX_32_Delay;
			when "00100" => F <= I4 after MUX_32_Delay;
			when "00101" => F <= I5 after MUX_32_Delay;
			when "00110" => F <= I6 after MUX_32_Delay;
			when "00111" => F <= I7 after MUX_32_Delay;	
			when "01000" => F <= I8 after MUX_32_Delay;
			when "01001" => F <= I9 after MUX_32_Delay;
			when "01010" => F <= I10 after MUX_32_Delay;
			when "01011" => F <= I11 after MUX_32_Delay;
			when "01100" => F <= I12 after MUX_32_Delay;
			when "01101" => F <= I13 after MUX_32_Delay;
			when "01110" => F <= I14 after MUX_32_Delay;
			when "01111" => F <= I15 after MUX_32_Delay;
			when "10000" => F <= I16 after MUX_32_Delay;
			when "10001" => F <= I17 after MUX_32_Delay;
			when "10010" => F <= I18 after MUX_32_Delay;
			when "10011" => F <= I19 after MUX_32_Delay;
			when "10100" => F <= I20 after MUX_32_Delay;
			when "10101" => F <= I21 after MUX_32_Delay;
			when "10110" => F <= I22 after MUX_32_Delay;
			when "10111" => F <= I23 after MUX_32_Delay;	
			when "11000" => F <= I24 after MUX_32_Delay;
			when "11001" => F <= I25 after MUX_32_Delay;
			when "11010" => F <= I26 after MUX_32_Delay;
			when "11011" => F <= I27 after MUX_32_Delay;
			when "11100" => F <= I28 after MUX_32_Delay;
			when "11101" => F <= I29 after MUX_32_Delay;
			when "11110" => F <= I30 after MUX_32_Delay;
			when "11111" => F <= I31 after MUX_32_Delay;			
		end case;	
	end process;				 
end Behaviour_MUX_32_nBit;

-- Decoder_5 Gate 1 Bit
entity Dec_5_1Bit is	 
	generic(
	Dec_5_Delay:Time:=0 ns
	);
	port(
	EN:in bit;
	I:in bit_vector(4 downto 0);
	O:out bit_vector(31 downto 0)
	);
end Dec_5_1Bit;
architecture Behaviour_Dec_5_1Bit of Dec_5_1Bit is
begin
	process(I,EN)
	begin
		if EN='1' then
			case I is
				when "00000" => O <= "00000000000000000000000000000001" after Dec_5_Delay;
				when "00001" => O <= "00000000000000000000000000000010" after Dec_5_Delay;
				when "00010" => O <= "00000000000000000000000000000100" after Dec_5_Delay;
				when "00011" => O <= "00000000000000000000000000001000" after Dec_5_Delay;
				when "00100" => O <= "00000000000000000000000000010000" after Dec_5_Delay;
				when "00101" => O <= "00000000000000000000000000100000" after Dec_5_Delay;
				when "00110" => O <= "00000000000000000000000001000000" after Dec_5_Delay;
				when "00111" => O <= "00000000000000000000000010000000" after Dec_5_Delay;	
				when "01000" => O <= "00000000000000000000000100000000" after Dec_5_Delay;
				when "01001" => O <= "00000000000000000000001000000000" after Dec_5_Delay;
				when "01010" => O <= "00000000000000000000010000000000" after Dec_5_Delay;
				when "01011" => O <= "00000000000000000000100000000000" after Dec_5_Delay;
				when "01100" => O <= "00000000000000000001000000000000" after Dec_5_Delay;
				when "01101" => O <= "00000000000000000010000000000000" after Dec_5_Delay;
				when "01110" => O <= "00000000000000000100000000000000" after Dec_5_Delay;
				when "01111" => O <= "00000000000000001000000000000000" after Dec_5_Delay;
				when "10000" => O <= "00000000000000010000000000000000" after Dec_5_Delay;
				when "10001" => O <= "00000000000000100000000000000000" after Dec_5_Delay;
				when "10010" => O <= "00000000000001000000000000000000" after Dec_5_Delay;
				when "10011" => O <= "00000000000010000000000000000000" after Dec_5_Delay;
				when "10100" => O <= "00000000000100000000000000000000" after Dec_5_Delay;
				when "10101" => O <= "00000000001000000000000000000000" after Dec_5_Delay;
				when "10110" => O <= "00000000010000000000000000000000" after Dec_5_Delay;
				when "10111" => O <= "00000000100000000000000000000000" after Dec_5_Delay;	
				when "11000" => O <= "00000001000000000000000000000000" after Dec_5_Delay;
				when "11001" => O <= "00000010000000000000000000000000" after Dec_5_Delay;
				when "11010" => O <= "00000100000000000000000000000000" after Dec_5_Delay;
				when "11011" => O <= "00001000000000000000000000000000" after Dec_5_Delay;
				when "11100" => O <= "00010000000000000000000000000000" after Dec_5_Delay;
				when "11101" => O <= "00100000000000000000000000000000" after Dec_5_Delay;
				when "11110" => O <= "01000000000000000000000000000000" after Dec_5_Delay;
				when "11111" => O <= "10000000000000000000000000000000" after Dec_5_Delay;			
			end case;
		else
			O <= "00000000000000000000000000000000" after Dec_5_Delay;
		end if;
	end process;	
end Behaviour_Dec_5_1Bit;

-- Sample Register For Sample Machine
entity Reg is	 
	generic(
	BitCount:natural:=0
	);
	port(
	Clk,Reset,LE,Inc:in bit;
	Input:in bit_vector(BitCount-1 downto 0);
	Output:out bit_vector(BitCount-1 downto 0)
	);
end Reg;
architecture Behaviour_Reg of Reg is 
	signal Zero_Value:bit_vector(BitCount-1 downto 0);
begin	 
	process (Clk,Reset)
	begin
		if Reset='0' then
			for i in BitCount-1 downto 0 loop
				Zero_Value(i) <= '0';
			end loop;
			Output <= Zero_Value;
		elsif (Clk'event)and(Clk='1') then
			if LE='1' then
				Output <= Input;
			end if;			
		end if;
	end process;
end Behaviour_Reg;

-- Increase
use work.Pack.all;
entity Inc is	 
	generic(
	BitCount:natural:=0
	);
	port(
	Input:in bit_vector(BitCount-1 downto 0);
	Output:out bit_vector(BitCount-1 downto 0)
	);
end Inc;
architecture Behaviour_Inc of Inc is 
begin	
	Inc_1:  if BitCount=8 generate 
					Output <= i2b_8Bit( b2i_8Bit(Input) + 1 );		
				end generate;
end Behaviour_Inc; 

-- Decrease	
use work.Pack.all;
entity Dec is	 
	generic(
	BitCount:natural:=0
	);
	port(
	Input:in bit_vector(BitCount-1 downto 0);
	Output:out bit_vector(BitCount-1 downto 0)
	);
end Dec;
architecture Behaviour_Dec of Dec is 
begin	
	Dec_Reg_1:  if BitCount=8 generate		
					Output <= i2b_8Bit( b2i_8Bit(Input) - 1 );		
				end generate;
end Behaviour_Dec; 

-- Multiple
use work.Pack.all;
entity Mul is	 
	generic(
	BitCount:natural:=0
	);
	port(
	Input1:in bit_vector(BitCount-1 downto 0);
	Input2:in bit_vector(BitCount-1 downto 0);
	Output:out bit_vector(BitCount-1 downto 0)
	);
end Mul;
architecture Behaviour_Mul of Mul is 
begin	
	Mul_Reg_1:  if BitCount=8 generate 
					Output <= i2b_8Bit( b2i_8Bit(Input1) * b2i_8Bit(Input2) );		
				end generate;
end Behaviour_Mul; 

-- D Flip-Flop
entity D_FF is	 
	port(
	D,Clk:in bit;
	Q:out bit
	);
	function Resing_Edge(Signal S:bit)return boolean is
	begin 
		if (S'event)and(S='1')and(S'last_value='0') then
			return True;
		else
			return False;
		end if;
	end function Resing_Edge;
end D_FF;
architecture Behaviour_D_FF of D_FF is 
begin	
	process(Clk)
	begin
		if Resing_Edge (Clk)then
			Q <= D;
		end if;
	end process;
end Behaviour_D_FF;

-- Combinational Read Write Port
entity Com_R_w is	 
	port(
	D,EN,Clk:in bit;
	Q:inout bit
	);
end Com_R_w;
architecture Behaviour_Com_R_w of Com_R_w is 
	component MUX_2_1Bit is	 
		generic(
		MUX_2_Delay:Time:=0 ns
		);
		port(
		I0,I1:in bit;
		Sel:in bit;
		F:out bit
		);
	end component;
	component D_FF is	 
		port(
		D,Clk:in bit;
		Q:out bit
		);
	end component;	
	signal Mux_Signal:bit;
begin
	Com_R_w_1: MUX_2_1Bit generic map(0 ns) port map(Q,D,EN,Mux_Signal);
	Com_R_w_2: D_FF port map(Mux_Signal,Clk,Q);
end Behaviour_Com_R_w;

-- Register
entity Register_Main is	 
	port(
	I:in bit_vector(31 downto 0);
	EN,Clk:in bit;
	O:inout bit_vector(31 downto 0)
	);
end Register_Main;
architecture Behaviour_Register_Main of Register_Main is 
	component Com_R_w is	 
		port(
		D,EN,Clk:in bit;
		Q:inout bit
		);
	end component;	
begin
	Register_Main_1: Com_R_w port map(I(31),EN,Clk,O(31));
	Register_Main_2: Com_R_w port map(I(30),EN,Clk,O(30));
	Register_Main_3: Com_R_w port map(I(29),EN,Clk,O(29));
	Register_Main_4: Com_R_w port map(I(28),EN,Clk,O(28));
	Register_Main_5: Com_R_w port map(I(27),EN,Clk,O(27));
	Register_Main_6: Com_R_w port map(I(26),EN,Clk,O(26));
	Register_Main_7: Com_R_w port map(I(25),EN,Clk,O(25));
	Register_Main_8: Com_R_w port map(I(24),EN,Clk,O(24));
	Register_Main_9: Com_R_w port map(I(23),EN,Clk,O(23));
	Register_Main_10: Com_R_w port map(I(22),EN,Clk,O(22));	
	Register_Main_11: Com_R_w port map(I(21),EN,Clk,O(21));
	Register_Main_12: Com_R_w port map(I(20),EN,Clk,O(20));
	Register_Main_13: Com_R_w port map(I(19),EN,Clk,O(19));
	Register_Main_14: Com_R_w port map(I(18),EN,Clk,O(18));
	Register_Main_15: Com_R_w port map(I(17),EN,Clk,O(17));
	Register_Main_16: Com_R_w port map(I(16),EN,Clk,O(16));
	Register_Main_17: Com_R_w port map(I(15),EN,Clk,O(15));
	Register_Main_18: Com_R_w port map(I(14),EN,Clk,O(14));
	Register_Main_19: Com_R_w port map(I(13),EN,Clk,O(13));
	Register_Main_20: Com_R_w port map(I(12),EN,Clk,O(12));
	Register_Main_21: Com_R_w port map(I(11),EN,Clk,O(11));
	Register_Main_22: Com_R_w port map(I(10),EN,Clk,O(10));
	Register_Main_23: Com_R_w port map(I(9),EN,Clk,O(9));
	Register_Main_24: Com_R_w port map(I(8),EN,Clk,O(8));
	Register_Main_25: Com_R_w port map(I(7),EN,Clk,O(7));
	Register_Main_26: Com_R_w port map(I(6),EN,Clk,O(6));
	Register_Main_27: Com_R_w port map(I(5),EN,Clk,O(5));
	Register_Main_28: Com_R_w port map(I(4),EN,Clk,O(4));	 
	Register_Main_29: Com_R_w port map(I(3),EN,Clk,O(3));
	Register_Main_30: Com_R_w port map(I(2),EN,Clk,O(2));	
	Register_Main_31: Com_R_w port map(I(1),EN,Clk,O(1));
	Register_Main_32: Com_R_w port map(I(0),EN,Clk,O(0));
end Behaviour_Register_Main;

-- Register File
entity RegisterFile is	 
	port(
	RA1,RA2,WA:in bit_vector(4 downto 0);
	WE,Clk:in bit;
	WD:in bit_vector(31 downto 0);
	RD1,RD2:out bit_vector(31 downto 0)
	);
end RegisterFile;
architecture Behaviour_RegisterFile of RegisterFile is 
	component Dec_5_1Bit is	 
		generic(
		Dec_5_Delay:Time:=0 ns
		);
		port(
		EN:in bit;
		I:in bit_vector(4 downto 0);
		O:out bit_vector(31 downto 0)
		);
	end component;
	component AND_2 is	 
		generic(
		AND_Delay:Time:=0 ns
		);
		port(
		A,B:in bit;
		F:out bit
		);
	end component;	
	component Register_Main is	 
		port(
		I:in bit_vector(31 downto 0);
		EN,Clk:in bit;
		O:inout bit_vector(31 downto 0)
		);
	end component;
	component MUX_32_nBit is	 
		generic(
		BitCount:natural:=0;
		MUX_32_Delay:Time:=0 ns
		);
		port(
		I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,
		I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,
		I21,I22,I23,I24,I25,I26,I27,I28,I29,I30,
		I31:in bit_vector(BitCount-1 downto 0);
		Sel:in bit_vector(4 downto 0);
		F:out bit_vector(BitCount-1 downto 0)
		);
	end component;

	signal Decoder_Output:bit_vector(31 downto 0);  
	type Mux_In_Type_Signal is array(31 downto 0) of bit_vector(31 downto 0); 
	signal Mux_In_Signal:Mux_In_Type_Signal;
begin
	RegisterFile_1: Dec_5_1Bit generic map(0 ns) port map(WE,WA,Decoder_Output); 
	
	RegisterFile_34: Register_Main port map(WD,Decoder_Output(31),Clk,Mux_In_Signal(31));	
	RegisterFile_35: Register_Main port map(WD,Decoder_Output(30),Clk,Mux_In_Signal(30));
	RegisterFile_36: Register_Main port map(WD,Decoder_Output(29),Clk,Mux_In_Signal(29));
	RegisterFile_37: Register_Main port map(WD,Decoder_Output(28),Clk,Mux_In_Signal(28));
	RegisterFile_38: Register_Main port map(WD,Decoder_Output(27),Clk,Mux_In_Signal(27));
	RegisterFile_39: Register_Main port map(WD,Decoder_Output(26),Clk,Mux_In_Signal(26));
	RegisterFile_40: Register_Main port map(WD,Decoder_Output(25),Clk,Mux_In_Signal(25));
	RegisterFile_41: Register_Main port map(WD,Decoder_Output(24),Clk,Mux_In_Signal(24));
	RegisterFile_42: Register_Main port map(WD,Decoder_Output(23),Clk,Mux_In_Signal(23));
	RegisterFile_43: Register_Main port map(WD,Decoder_Output(22),Clk,Mux_In_Signal(22));	
	RegisterFile_44: Register_Main port map(WD,Decoder_Output(21),Clk,Mux_In_Signal(21));
	RegisterFile_45: Register_Main port map(WD,Decoder_Output(20),Clk,Mux_In_Signal(20));
	RegisterFile_46: Register_Main port map(WD,Decoder_Output(19),Clk,Mux_In_Signal(19));
	RegisterFile_47: Register_Main port map(WD,Decoder_Output(18),Clk,Mux_In_Signal(18));
	RegisterFile_48: Register_Main port map(WD,Decoder_Output(17),Clk,Mux_In_Signal(17));
	RegisterFile_49: Register_Main port map(WD,Decoder_Output(16),Clk,Mux_In_Signal(16));
	RegisterFile_50: Register_Main port map(WD,Decoder_Output(15),Clk,Mux_In_Signal(15));
	RegisterFile_51: Register_Main port map(WD,Decoder_Output(14),Clk,Mux_In_Signal(14));
	RegisterFile_52: Register_Main port map(WD,Decoder_Output(13),Clk,Mux_In_Signal(13));
	RegisterFile_53: Register_Main port map(WD,Decoder_Output(12),Clk,Mux_In_Signal(12));
	RegisterFile_54: Register_Main port map(WD,Decoder_Output(11),Clk,Mux_In_Signal(11));
	RegisterFile_55: Register_Main port map(WD,Decoder_Output(10),Clk,Mux_In_Signal(10));
	RegisterFile_56: Register_Main port map(WD,Decoder_Output(9),Clk,Mux_In_Signal(9));
	RegisterFile_57: Register_Main port map(WD,Decoder_Output(8),Clk,Mux_In_Signal(8));
	RegisterFile_58: Register_Main port map(WD,Decoder_Output(7),Clk,Mux_In_Signal(7));
	RegisterFile_59: Register_Main port map(WD,Decoder_Output(6),Clk,Mux_In_Signal(6));
	RegisterFile_60: Register_Main port map(WD,Decoder_Output(5),Clk,Mux_In_Signal(5));
	RegisterFile_61: Register_Main port map(WD,Decoder_Output(4),Clk,Mux_In_Signal(4));	
	RegisterFile_62: Register_Main port map(WD,Decoder_Output(3),Clk,Mux_In_Signal(3));	
	RegisterFile_63: Register_Main port map(WD,Decoder_Output(2),Clk,Mux_In_Signal(2));	
	RegisterFile_64: Register_Main port map(WD,Decoder_Output(1),Clk,Mux_In_Signal(1));	
	RegisterFile_65: Register_Main port map(WD,Decoder_Output(0),Clk,Mux_In_Signal(0));
	
	RegisterFile_66: MUX_32_nBit generic map(32,0 ns) port map(
					 Mux_In_Signal(0),Mux_In_Signal(1),Mux_In_Signal(2),Mux_In_Signal(3),
					 Mux_In_Signal(4),Mux_In_Signal(5),Mux_In_Signal(6),Mux_In_Signal(7),
					 Mux_In_Signal(8),Mux_In_Signal(9),Mux_In_Signal(10),Mux_In_Signal(11),
					 Mux_In_Signal(12),Mux_In_Signal(13),Mux_In_Signal(14),Mux_In_Signal(15),
					 Mux_In_Signal(16),Mux_In_Signal(17),Mux_In_Signal(18),Mux_In_Signal(19),
					 Mux_In_Signal(20),Mux_In_Signal(21),Mux_In_Signal(22),Mux_In_Signal(23),
					 Mux_In_Signal(24),Mux_In_Signal(25),Mux_In_Signal(26),Mux_In_Signal(27),
					 Mux_In_Signal(28),Mux_In_Signal(29),Mux_In_Signal(30),Mux_In_Signal(21),
					 RA1,RD1);
	RegisterFile_67: MUX_32_nBit generic map(32,0 ns) port map(
					 Mux_In_Signal(0),Mux_In_Signal(1),Mux_In_Signal(2),Mux_In_Signal(3),
					 Mux_In_Signal(4),Mux_In_Signal(5),Mux_In_Signal(6),Mux_In_Signal(7),
					 Mux_In_Signal(8),Mux_In_Signal(9),Mux_In_Signal(10),Mux_In_Signal(11),
					 Mux_In_Signal(12),Mux_In_Signal(13),Mux_In_Signal(14),Mux_In_Signal(15),
					 Mux_In_Signal(16),Mux_In_Signal(17),Mux_In_Signal(18),Mux_In_Signal(19),
					 Mux_In_Signal(20),Mux_In_Signal(21),Mux_In_Signal(22),Mux_In_Signal(23),
					 Mux_In_Signal(24),Mux_In_Signal(25),Mux_In_Signal(26),Mux_In_Signal(27),
					 Mux_In_Signal(28),Mux_In_Signal(29),Mux_In_Signal(30),Mux_In_Signal(21),
					 RA2,RD2);				
					 

	
end Behaviour_RegisterFile;

-- Program Counter
entity PC is     
  	port(
	clk,LD:in bit;
    I:in bit_vector(31 downto 0);
    O:inout bit_vector(31 downto 0) 
	);
end PC; 
architecture Behaviour_PC of PC is 
	component Com_R_w is	 
		port(
		D,EN,Clk:in bit;
		Q:inout bit
		);
	end component;
begin
	PC_1: Com_R_w port map(I(31),LD,Clk,O(31));
	PC_2: Com_R_w port map(I(30),LD,Clk,O(30));
	PC_3: Com_R_w port map(I(29),LD,Clk,O(29));
	PC_4: Com_R_w port map(I(28),LD,Clk,O(28));
	PC_5: Com_R_w port map(I(27),LD,Clk,O(27));
	PC_6: Com_R_w port map(I(26),LD,Clk,O(26));
	PC_7: Com_R_w port map(I(25),LD,Clk,O(25));
	PC_8: Com_R_w port map(I(24),LD,Clk,O(24));
	PC_9: Com_R_w port map(I(23),LD,Clk,O(23));
	PC_10: Com_R_w port map(I(22),LD,Clk,O(22));	
	PC_11: Com_R_w port map(I(21),LD,Clk,O(21));
	PC_12: Com_R_w port map(I(20),LD,Clk,O(20));
	PC_13: Com_R_w port map(I(19),LD,Clk,O(19));
	PC_14: Com_R_w port map(I(18),LD,Clk,O(18));
	PC_15: Com_R_w port map(I(17),LD,Clk,O(17));
	PC_16: Com_R_w port map(I(16),LD,Clk,O(16));
	PC_17: Com_R_w port map(I(15),LD,Clk,O(15));
	PC_18: Com_R_w port map(I(14),LD,Clk,O(14));
	PC_19: Com_R_w port map(I(13),LD,Clk,O(13));
	PC_20: Com_R_w port map(I(12),LD,Clk,O(12));
	PC_21: Com_R_w port map(I(11),LD,Clk,O(11));
	PC_22: Com_R_w port map(I(10),LD,Clk,O(10));
	PC_23: Com_R_w port map(I(9),LD,Clk,O(9));
	PC_24: Com_R_w port map(I(8),LD,Clk,O(8));
	PC_25: Com_R_w port map(I(7),LD,Clk,O(7));
	PC_26: Com_R_w port map(I(6),LD,Clk,O(6));
	PC_27: Com_R_w port map(I(5),LD,Clk,O(5));
	PC_28: Com_R_w port map(I(4),LD,Clk,O(4));	 
	PC_29: Com_R_w port map(I(3),LD,Clk,O(3));
	PC_30: Com_R_w port map(I(2),LD,Clk,O(2));	
	PC_31: Com_R_w port map(I(1),LD,Clk,O(1));
	PC_32: Com_R_w port map(I(0),LD,Clk,O(0));				
end Behaviour_PC;	

-- Instruction Memory
entity Ins_Mem is     
  	port(
    Input:in bit_vector(31 downto 0);
    Output:out bit_vector(31 downto 0);
	R_c,R_a,R_b:out bit_vector(4 downto 0);
	Const:out bit_vector(31 downto 0)
	);
end Ins_Mem; 
architecture Behaviour_Ins_Mem of Ins_Mem is 
begin
	Output <= Input;
	
	R_c(4) <= Input(25); 
	R_c(3) <= Input(24);
	R_c(2) <= Input(23);
	R_c(1) <= Input(22); 
	R_c(0) <= Input(21);
	
	R_a(4) <= Input(20); 
	R_a(3) <= Input(19); 
	R_a(2) <= Input(18);
	R_a(1) <= Input(17);
	R_a(0) <= Input(16);	
	
	R_b(4) <= Input(15); 
	R_b(3) <= Input(14); 
	R_b(2) <= Input(13);
	R_b(1) <= Input(12);
	R_b(0) <= Input(11);
	
	Const(31) <= '0';
	Const(30) <= '0';
	Const(29) <= '0'; 
	Const(28) <= '0'; 
	Const(27) <= '0';
	Const(26) <= '0';
	Const(25) <= '0';
	Const(24) <= '0'; 
	Const(23) <= '0'; 
	Const(22) <= '0';
	Const(21) <= '0';
	Const(20) <= '0';
	Const(19) <= '0';
	Const(18) <= '0'; 
	Const(17) <= '0';
	Const(16) <= '0'; 	
	
	Const(15) <= Input(15); 
	Const(14) <= Input(14);
	Const(13) <= Input(13);
	Const(12) <= Input(12);
	Const(11) <= Input(11); 
	Const(10) <= Input(10); 
	Const(9) <= Input(9);
	Const(8) <= Input(8);
	Const(7) <= Input(7);
	Const(6) <= Input(6); 
	Const(5) <= Input(5); 
	Const(4) <= Input(4);
	Const(3) <= Input(3);
	Const(2) <= Input(2);
	Const(1) <= Input(1);
	Const(0) <= Input(0); 	
end Behaviour_Ins_Mem;

-- Control Logic
entity Control_Logic is     
  	port(
    Input:in bit_vector(31 downto 0);
	Z:in bit;
	PCSEL:out bit_vector(2 downto 0); 	
	RA2SEL,ASEL,BSEL,Wr,WERF:out bit;
	WDSEL:out bit_vector(1 downto 0);
	ALUFN:out bit_vector(5 downto 0)
	);
end Control_Logic; 
architecture Behaviour_Control_Logic of Control_Logic is 
-- Instructions OpCode
-- ADD:	  000000
-- SUB:	  000001
-- MUL:	  000010
-- DIV:	  000011
-- CMPEQ: 000100
-- CMPLT: 000101
-- CMPLE: 000110
-- AND:	  000111
-- OR:	  001000
-- XOR:	  001001
-- SHL:	  001010
-- SHR:	  001011
-- SRA:	  001100
-- ADDC:  001101
-- SUBC:  001110
-- MULC:  001111
-- DIVC:  010000
-- CMPEQC:010001 
-- CMPLTC:010010
-- CMPLEC:010011 
-- ANDC:  010100
-- ORC:	  010101
-- XORC:  010110
-- SHLC:  010111
-- SHRC:  011000
-- SRAC:  011001
-- BNE/BT:011010
-- BEQ/BF:011011 
-- JMP:   011100
-- LD:	  011101
-- ST:	  011110 
	signal OpCode_Signal:bit_vector(5 downto 0);
begin
	process(Input)
	begin
		if Input="00000000000000000000000000000000" then
			PCSEL <= "010";
		end if;
		
		OpCode_Signal(5) <= Input(31);
		OpCode_Signal(4) <= Input(30); 
		OpCode_Signal(3) <= Input(29);
		OpCode_Signal(2) <= Input(28);
		OpCode_Signal(1) <= Input(27); 
		OpCode_Signal(0) <= Input(26);
	
		Control_Logic_1: if (OpCode_Signal="011010")or(OpCode_Signal="011011") then
					 	 	 PCSEL <= "001";
					 	 elsif OpCode_Signal="011100" then 
						 	 PCSEL <= "010";
					 	 else
						 	 PCSEL <= "000";
					 	 end if;
	
		Control_Logic_2: if (OpCode_Signal="000000")or(OpCode_Signal="000001")or(OpCode_Signal="000010")or(OpCode_Signal="000011")or(OpCode_Signal="000100")or(OpCode_Signal="000101")or(OpCode_Signal="000110")or(OpCode_Signal="000111")or(OpCode_Signal="001000")or(OpCode_Signal="001001")or(OpCode_Signal="001010")or(OpCode_Signal="001011")or(OpCode_Signal="001100")or(OpCode_Signal="001101") then
					 	 	 WDSEL <= "01";
					 	 elsif OpCode_Signal="011100" then 
						 	 WDSEL <= "10";
					 	 else
						 	 WDSEL <= "00";
					 	 end if;
	end process;
end Behaviour_Control_Logic;

-- ALU
use work.Pack.all;
entity ALU is     	
	generic(
	ALU_Delay:Time:=0 ns
	);
	port(
    A,B:in bit_vector(31 downto 0);
	ALUFN:in bit_vector(5 downto 0);
	F:out bit_vector(31 downto 0)
	);
end ALU; 
architecture Behaviour_ALU of ALU is
begin
	process(A,B,ALUFN)
	begin
		case ALUFN is				
			when "000000" => F <= ADD_32Bit(A,B) after ALU_Delay;
			when "000001" => F <= SUB_32Bit(A,B) after ALU_Delay;
			when "000010" => F <= MUL_32Bit(A,B) after ALU_Delay;
			when "000011" => F <= DIV_32Bit(A,B) after ALU_Delay;
			when "000111" => F <= AND_32Bit(A,B) after ALU_Delay;
			when "001000" => F <= OR_32Bit(A,B)  after ALU_Delay;
			when "001001" => F <= XOR_32Bit(A,B) after ALU_Delay;
			when "001010" => F <= SHL_32Bit(A,B) after ALU_Delay;	
			when "001011" => F <= SHR_32Bit(A,B) after ALU_Delay;
			when others => F <= "00000000000000000000000000000000";
		end case;	
	end process;				 	
end Behaviour_ALU; 

-- Data Memory
use work.Pack.all;
entity Data_Memory is     
  	port(
    RW:in bit;
	WD,Adr:in bit_vector(31 downto 0);
	RD:out bit_vector(31 downto 0)
	);
end Data_Memory; 
architecture Behaviour_Data_Memory of Data_Memory is   
	type Ram_Type is array ((2**32-1) downto 0) of bit_vector(31 downto 0);
	signal Ram_Signal:Ram_Type;
begin
	process (RW)
	begin
		if RW='1' then
			Ram_Signal(b2i_32Bit(Adr)) <= WD;
		else
			RD <= Ram_Signal(b2i_32Bit(Adr));	
		end if;	 
	end process;
end Behaviour_Data_Memory;