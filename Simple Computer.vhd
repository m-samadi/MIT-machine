library ieee;
use ieee.std_logic_1164.all;  
use work.Pack.all;

entity SimpleComputer is
	generic(
	BitCount:natural:=8
	);
	port(
	Clk:bit;
	A_Sel,A_LE,B_Sel,B_LE:bit;
	N:in bit_vector(7 downto 0);
	Output:out bit_vector(7 downto 0)
	);
end SimpleComputer;
architecture Behaviour_SimpleComputer of SimpleComputer is
	component MUX_2_nBit is	 
		generic(
		BitCount:natural:=0;
		MUX_2_Delay:Time:=0 ns
		);
		port(
		I0,I1:in bit_vector(BitCount-1 downto 0);
		Sel:in bit;
		F:out bit_vector(BitCount-1 downto 0)
		);
	end component;
	component Reg is	 
		generic(
		BitCount:natural:=0
		);
		port(
		Clk,Reset,LE,Inc:in bit;
		Input:in bit_vector(BitCount-1 downto 0);
		Output:out bit_vector(BitCount-1 downto 0)
		);
	end component;	
	component Mul is
		generic(
		BitCount:natural:=0
		);
		port(
		Input1:in bit_vector(BitCount-1 downto 0);
		Input2:in bit_vector(BitCount-1 downto 0);
		Output:out bit_vector(BitCount-1 downto 0)
		);	
	end component;
	component Dec is	 
		generic(
		BitCount:natural:=0
		);
		port(
		Input:in bit_vector(BitCount-1 downto 0);
		Output:out bit_vector(BitCount-1 downto 0)
		);
	end component;	
	Signal Mul_Signal,Dec_Signal,Mux0_Signal,Mux1_Signal,A_Signal,B_Signal:bit_vector(7 downto 0);
begin	   
	SimpleComputer_1: MUX_2_nBit generic map(8,0 ns) port map (Mul_Signal,"00000001",A_Sel,Mux0_Signal);  
	SimpleComputer_2: MUX_2_nBit generic map(8,0 ns) port map (N,Dec_Signal,B_Sel,Mux1_Signal);  
	SimpleComputer_3: Reg generic map(8) port map (Clk,'1',A_LE,'0',Mux0_Signal,A_Signal);  
	SimpleComputer_4: Reg generic map(8) port map (Clk,'1',B_LE,'0',Mux1_Signal,B_Signal); 
	Output <= A_Signal;
	SimpleComputer_5: Mul generic map(8) port map (A_Signal,B_Signal,Mul_Signal); 
	SimpleComputer_6: Dec generic map(8) port map (B_Signal,Dec_Signal);
	
end Behaviour_SimpleComputer;