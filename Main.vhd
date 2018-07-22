library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_interface is
	port(
		CLOCK: in std_logic;
		change_available: IN std_logic_vector(4 downto 0);
		item_selected: IN std_logic_vector(11 downto 0);
		money_entered: IN std_logic_vector (4 downto 0);
		options: in std_logic_vector(1 downto 0); --select options coded: 00 -> Abort, 01 -> Neglect, 10 -> Extra, 11 -> OK
		x_coordinate: OUT std_logic_vector(3 downto 0);
		y_coordinate: OUT std_logic_vector(7 downto 0);
		change_given: out std_logic_vector(4 downto 0));
end vending_machine_interface;


architecture vm_arch of vending_machine_interface is
	component itemToPrice
		port (
		  itemNumber : in  std_logic_vector(11 downto 0);
		  price      : out std_logic_vector(4 downto 0)
		);
end component itemToPrice;

	type STATE is (ENTER_MONEY, SELECT_ITEM, NOCHANGE);
	signal s: STATE:= ENTER_MONEY;
	signal itemPrice: std_logic_vector(4 downto 0);
	signal money_available: unsigned(4 downto 0):= "00000";
	begin
		U0: itemToPrice port map(item_selected, itemPrice);

		process(CLOCK)
			begin
				if CLOCK'event and CLOCK = '1' then
					case( s ) is
						when ENTER_MONEY =>       --reset state
						change_given <= "00000";
						x_coordinate <= "0000";
						y_coordinate <= "00000000";
						if money_available + unsigned(money_entered) > "010100" then --reject if entered money makes available money > 5000LL
						  change_given <= money_entered;
						else
						  money_available <= money_available + unsigned(money_entered); --update value of available money
						end if;
						if options = "11" then
							s <= SELECT_ITEM; -- OK is pressed
						end if;
						
						when SELECT_ITEM =>
							if options = "00" then s <= ENTER_MONEY; -- Abort
							change_given <= std_logic_vector(money_available); --return all money available
							money_available <= "00000";  --reset money available
							elsif money_available >= unsigned(itemPrice) then -- Enough Money
								if unsigned(change_available) >= (unsigned(money_available)-unsigned(itemPrice)) then
									x_coordinate <= item_selected(11 downto 8);  --since our input is BCD we take the 4 MSB to represent the rows
									y_coordinate <= item_selected(7 downto 0);   --here we take the last 8 bits to represent the columns
									money_available <= unsigned(money_available) - unsigned(itemPrice);  --update value of money available by subtracting used money
									if money_available > "00000" then
									  	if options = "10" then  -- Extra Items
									     	s <= SELECT_ITEM;
									  	elsif options = "00" then -- Abort
									     	s <= ENTER_MONEY;
							       		change_given <= std_logic_vector(money_available);  --return all available money
							       		money_available <= "00000";
									   end if;
									  else
									    change_given <= std_logic_vector(money_available);
									    s <= ENTER_MONEY;
							   end if;
								else
									s <= NOCHANGE;
								end if;
							else -- Not Enough Money
							  s <= ENTER_MONEY;
							end if;
						when NOCHANGE =>
							if options = "00" then -- Abort
							  money_available <= "00000";
								s <= ENTER_MONEY;
								change_given <= std_logic_vector(money_available);
							elsif options = "01" then -- Neglect change and dispense item
							  money_available <= "00000";
								x_coordinate <= item_selected(11 downto 8);
								y_coordinate <= item_selected(7 downto 0);
								change_given <= "00000";
								s <= ENTER_MONEY;
							elsif options = "10" then -- Dispense and select extra item
								x_coordinate <= item_selected(11 downto 8);
								y_coordinate <= item_selected(7 downto 0);
								s <= SELECT_ITEM;
								money_available <= unsigned(money_available) - unsigned(itemPrice); --update money available
							end if;
						when others => s <= ENTER_MONEY;

					end case;
			end if;
			end process;

end vm_arch;
