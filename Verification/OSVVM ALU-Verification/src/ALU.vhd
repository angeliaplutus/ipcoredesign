library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
            clk_i       : in  STD_LOGIC;
            rstn_i      : in  STD_LOGIC;
            A_i         : in  STD_LOGIC_VECTOR(3 downto 0);
            B_i         : in  STD_LOGIC_VECTOR(3 downto 0);
            SEL_i       : in  STD_LOGIC_VECTOR(2 downto 0);
            RES_o       : out STD_LOGIC_VECTOR(3 downto 0)
		);
end alu;

architecture Behavioral of alu is

begin

CLK_PROC : process(clk_i, rstn_i) begin
	
	if rising_edge(clk_i) then 
		if(rstn_i = '0') then
			RES_o <= "0000";
		else
            case SEL_i is
                when "000" =>
                    RES_o <= A_i + B_i;
                when "001" =>
                    RES_o <= A_i - B_i;
                when "010" =>
                    RES_o <= A_i - 1;
                when "011" =>
                    RES_o <= A_i + 1;
                when "100" =>
                    RES_o <= A_i and B_i;
                when "101" =>
                    RES_o <= A_i or B_i;
                when "110" =>
                    RES_o <= not A_i ;
                when "111" =>
                    RES_o <= A_i xor B_i;
                when others =>
                NULL;
            end case;
		end if;
	end if;


end process;

end Behavioral;