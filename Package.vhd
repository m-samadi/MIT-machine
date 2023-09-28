library ieee;
use ieee.std_logic_1164.all;

-- Pack
package Pack is
	function b2i_8Bit(BitValue:bit_vector(7 downto 0)) return integer;
	function i2b_8Bit(DecimalValue:integer) return bit_vector; 
	function b2i_32Bit(BitValue:bit_vector(31 downto 0)) return integer;
	function i2b_32Bit(DecimalValue:integer) return bit_vector;
	function ADD_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function SUB_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function MUL_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function DIV_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function AND_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function OR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function XOR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function SHL_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;
	function SHR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector;	
end package Pack;
package body Pack is
	function b2i_8Bit(BitValue:bit_vector(7 downto 0)) return integer is
		variable Result:integer:=0;
	begin
		for i in 7 downto 0 loop
			if BitValue(i)='1' then
				Result:=Result+2**i;
			end if;	
		end loop;
		return Result;
	end function b2i_8Bit; 
	--
	function i2b_8Bit(DecimalValue:integer) return bit_vector is
		variable Result:bit_vector(7 downto 0);
		variable Temp_Value:integer:=0;
	begin
		Temp_Value:=DecimalValue;
		for i in 0 to 7 loop
			if (Temp_Value mod 2)=1 then
				Result(i):='1';
			else
				Result(i):='0';
			end if;	
			Temp_Value:=Temp_Value/2;
		end loop;
		return Result;
	end function i2b_8Bit;
	--
	function b2i_32Bit(BitValue:bit_vector(31 downto 0)) return integer is
		variable Result:integer:=0;
	begin
		for i in 31 downto 0 loop
			if BitValue(i)='1' then
				Result:=Result+2**i;
			end if;	
		end loop;
		return Result;
	end function b2i_32Bit; 
	--
	function i2b_32Bit(DecimalValue:integer) return bit_vector is
		variable Result:bit_vector(31 downto 0);
		variable Temp_Value:integer:=0;
	begin
		Temp_Value:=DecimalValue;
		for i in 0 to 31 loop
			if (Temp_Value mod 2)=1 then
				Result(i):='1';
			else
				Result(i):='0';
			end if;	
			Temp_Value:=Temp_Value/2;
		end loop;
		return Result;
	end function i2b_32Bit;	
	--
	function ADD_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
	begin
		return i2b_8Bit(b2i_32Bit(BitValue1)+b2i_32Bit(BitValue2));
	end function ADD_32Bit;	
	--
	function SUB_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
	begin
		return i2b_8Bit(b2i_32Bit(BitValue1)-b2i_32Bit(BitValue2));
	end function SUB_32Bit;
	--
	function MUL_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
	begin
		return i2b_8Bit(b2i_32Bit(BitValue1)*b2i_32Bit(BitValue2));
	end function MUL_32Bit;	
	--
	function DIV_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
	begin
		return i2b_8Bit(b2i_32Bit(BitValue1)/b2i_32Bit(BitValue2));
	end function DIV_32Bit;	
	--
	function AND_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
		variable Result:bit_vector(31 downto 0);
	begin
		for i in 31 downto 0 loop
			Result(i):=BitValue1(i) and BitValue1(i);
		end loop;	
		return Result;		
	end function AND_32Bit;	
	--
	function OR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is	
		variable Result:bit_vector(31 downto 0);
	begin
		for i in 31 downto 0 loop
			Result(i):=BitValue1(i) or BitValue1(i);
		end loop;	
		return Result;		
	end function OR_32Bit;	
	--
	function XOR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is	
		variable Result:bit_vector(31 downto 0);
	begin
		for i in 31 downto 0 loop
			Result(i):=BitValue1(i) xor BitValue1(i);
		end loop;	
		return Result;		
	end function XOR_32Bit;	
	--	
	function SHL_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
		variable Result:bit_vector(31 downto 0);
	begin
		Result:=BitValue1;
		for i in 1 to b2i_32Bit(BitValue2) loop
			for j in 31 downto 1 loop
            	Result(j):=Result(j-1);
			end loop;
			Result(0):='0';
		end loop;	
		return Result;
	end function SHL_32Bit;	
	--
	function SHR_32Bit(BitValue1,BitValue2:bit_vector(31 downto 0)) return bit_vector is
		variable Result:bit_vector(31 downto 0);
	begin
		Result:=BitValue1;
		for i in 1 to b2i_32Bit(BitValue2) loop
			for j in 0 to 30 loop
            	Result(j):=Result(j+1);
			end loop;
			Result(31):='0';
		end loop;	
		return Result;
	end function SHR_32Bit;			
end package body Pack;

-- Pack2
package Pack2 is
	type InstructionSet1_Record is
	record
		OpCode:bit_vector(5 downto 0);
		UnUsed:bit_vector(25 downto 0);
	end record;	
	type InstructionSet2_Record is
	record
		OpCode:bit_vector(5 downto 0);
		R_c:bit_vector(4 downto 0);
		R_a:bit_vector(4 downto 0);
		R_b:bit_vector(4 downto 0);
		UnUsed:bit_vector(10 downto 0);
	end record;	
	type InstructionSet3_Record is
	record
		OpCode:bit_vector(5 downto 0);
		R_c:bit_vector(4 downto 0);
		R_a:bit_vector(4 downto 0);
		UnUsed:bit_vector(15 downto 0);
	end record;	
end package Pack2;
package body Pack2 is
end package body Pack2;	
	