library ieee;
use ieee.std_logic_1164.all;  
use work.Pack.all;

entity Machine is	 
	port(
	Clk:in bit
	);
end Machine;
architecture Behaviour_Machine of Machine is
	component Control_Logic is     
  		port(
    	Input:in bit_vector(31 downto 0);
		Z:in bit;
		PCSEL:out bit_vector(2 downto 0); 	
		RA2SEL,ASEL,BSEL,Wr,WERF:out bit;
		WDSEL:out bit_vector(1 downto 0);
		ALUFN:out bit_vector(5 downto 0)
		);
	end component;
	component MUX_8_nBit is	 
		generic(
		BitCount:natural:=0;
		MUX_8_Delay:Time:=0 ns
		);
		port(
		I0,I1,I2,I3,I4,I5,I6,I7:in bit_vector(BitCount-1 downto 0);
		Sel:in bit_vector(2 downto 0);
		F:out bit_vector(BitCount-1 downto 0)
		);
	end component;
	component PC is     
  		port(
		clk,LD:in bit;
    	I:in bit_vector(31 downto 0);
    	O:inout bit_vector(31 downto 0) 
		);
	end component;
	component Ins_Mem is     
  		port(
    	Input:in bit_vector(31 downto 0);
    	Output:out bit_vector(31 downto 0);
		R_c,R_a,R_b:out bit_vector(4 downto 0);
		Const:out bit_vector(31 downto 0)
		);
	end component; 
	component Adder is	 
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
	end component;
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
	component RegisterFile is	 
		port(
		RA1,RA2,WA:in bit_vector(4 downto 0);
		WE,Clk:in bit;
		WD:in bit_vector(31 downto 0);
		RD1,RD2:out bit_vector(31 downto 0)
		);
	end component;
	component ALU is     
  		port(
    	A,B:in bit_vector(31 downto 0);
		ALUFN:in bit_vector(5 downto 0);
		F:out bit_vector(31 downto 0)
		);
	end component; 
	component MUX_4_nBit is	 
		generic(
		BitCount:natural:=0;
		MUX_4_Delay:Time:=0 ns
		);
		port(
		I0,I1,I2,I3:in bit_vector(BitCount-1 downto 0);
		Sel:in bit_vector(1 downto 0);
		F:out bit_vector(BitCount-1 downto 0)
		);
	end component;
	component Data_Memory is     
  		port(
    	RW:in bit;
		WD,Adr:in bit_vector(31 downto 0);
		RD:out bit_vector(31 downto 0)
		);
	end component;	

	signal Z_Signal,Carry_Signal_1,Carry_Signal_2,RA2SEL_Signal,ASEL_Signal,BSEL_Signal,Wr_Signal,WERF_Signal:bit;
	signal Zero_Signal,Ins_Mem_Main_Output_Signal,PCSEL_Mux_In_1_Signal,PCSEL_Mux_In_2_Signal,PCSEL_Mux_Out_Signal,PC_Out_Signal,Const_Signal,PC_Inc4_Out_Signal,WD_Signal,RD1_Signal,RD2_Signal,ASEL_Mux_Out_Signal,BSEL_Mux_Out_Signal,ALU_Out_Signal,Mem_RD_Signal:bit_vector(31 downto 0);
	signal PCSEL_Signal:bit_vector(2 downto 0);	
	signal WDSEL_Signal:bit_vector(1 downto 0);
	signal ALUFN_Signal:bit_vector(5 downto 0);	
	signal R_c_Signal,R_a_Signal,R_b_Signal,RA1_Signal,RA2_Signal:bit_vector(4 downto 0);	
begin
	Machine_1:  Control_Logic port map(Ins_Mem_Main_Output_Signal,Z_Signal,PCSEL_Signal,RA2SEL_Signal,ASEL_Signal,BSEL_Signal,Wr_Signal,WERF_Signal,WDSEL_Signal,ALUFN_Signal);
	Zero_Signal <= "00000000000000000000000000000000";
	Machine_2:  MUX_8_nBit generic map(32,0 ns) port map(PCSEL_Mux_In_1_Signal,PCSEL_Mux_In_2_Signal,Zero_Signal,Zero_Signal,Zero_Signal,Zero_Signal,Zero_Signal,Zero_Signal,PCSEL_Signal,PCSEL_Mux_Out_Signal);
	Machine_3:  PC port map(Clk,'1',PCSEL_Mux_Out_Signal,PC_Out_Signal);
	Machine_4:  Ins_Mem port map(PC_Out_Signal,Ins_Mem_Main_Output_Signal,R_c_Signal,R_a_Signal,R_b_Signal,Const_Signal);
	Machine_5:  Adder generic map(32,0 ns,0 ns,0 ns) port map(PC_Out_Signal,"00000000000000000000000000000100",Carry_Signal_1,PC_Inc4_Out_Signal,Carry_Signal_1);
	Machine_6:  Adder generic map(32,0 ns,0 ns,0 ns) port map(PC_Inc4_Out_Signal,Ins_Mem_Main_Output_Signal,Carry_Signal_1,PCSEL_Mux_In_2_Signal,Carry_Signal_2);
	Machine_7:  MUX_2_nBit generic map(5,0 ns) port map(R_b_Signal,R_c_Signal,RA2SEL_Signal,RA2_Signal);
	RA1_Signal <= R_a_Signal; 
	Machine_8:  RegisterFile port map(RA1_Signal,RA2_Signal,R_a_Signal,WERF_Signal,Clk,WD_Signal,RD1_Signal,RD2_Signal);
	Machine_9:  MUX_2_nBit generic map(32,0 ns) port map(RD1_Signal,Const_Signal,BSEL_Signal,ASEL_Mux_Out_Signal);
	Machine_10: MUX_2_nBit generic map(32,0 ns) port map(RD2_Signal,Const_Signal,BSEL_Signal,BSEL_Mux_Out_Signal);
	Machine_11: ALU port map(ASEL_Mux_Out_Signal,BSEL_Mux_Out_Signal,ALUFN_Signal,ALU_Out_Signal);
	Machine_12: MUX_4_nBit generic map(32,0 ns) port map(PC_Inc4_Out_Signal,ALU_Out_Signal,Mem_RD_Signal,Zero_Signal,WDSEL_Signal,WD_Signal);
	Machine_13: Data_Memory port map(Wr_Signal,RD2_Signal,ALU_Out_Signal,Mem_RD_Signal);	
end Behaviour_Machine;