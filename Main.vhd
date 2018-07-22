library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_interface is
	port(	change_available: IN std_logic_vector(4 downto 0);
		item_selected: IN std_logic_vector(9 downto 0);
		money_entered: IN std_logic_vector (4 downto 0);
		options: IN std_logic_vector(1 downto 0);
		--display: OUT s
		coordinates_xy: OUT std_logic_vector(6 downto 0) ); 
end vending_machine_interface;