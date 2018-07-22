library ieee;
use ieee.std_logic_1164.all;

entity mainDummy is
end entity;

architecture mainDummyArch of mainDummy is
  component vending_machine_interface
  port (
    CLOCK            : in  std_logic;
    change_available : IN  std_logic_vector(4 downto 0);
    item_selected    : IN  std_logic_vector(11 downto 0);
    money_entered    : IN  std_logic_vector (4 downto 0);
    options          : IN  std_logic_vector(1 downto 0);
    x_coordinate: OUT std_logic_vector(3 downto 0);
    y_coordinate     : OUT std_logic_vector(7 downto 0);
    change_given     : out std_logic_vector(4 downto 0)
  );
  end component vending_machine_interface;

  signal money_entered, change_available, change_given: std_logic_vector(4 downto 0);
  signal options: std_logic_vector(1 downto 0);
  signal CLOCK: std_logic:= '0';
  signal item_selected: std_logic_vector(11 downto 0);
  signal x: std_logic_vector(3 downto 0);
  signal y: std_logic_vector(7 downto 0);

begin
  U0: vending_machine_interface port map(CLOCK, change_available, item_selected, money_entered, options, x, y, change_given);
  CLOCK <= not CLOCK after 2 ns;
  process begin
    wait for 1 ns;
    change_available <= "11111"; 
    
    -- Ideal case
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    wait for 10 ns; money_entered <= "00010"; wait for 4 ns; money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000101";
    options <= "ZZ";
    wait for 20 ns;
    
    -- Needs change 
    money_entered <= "00110"; wait for 4 ns; money_entered <= "00000"; 
    wait for 10 ns; money_entered <= "00010"; wait for 4 ns;
    money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000101";
    options <= "ZZ";
    wait for 4 ns;
    options <= "00";
    wait for 4 ns;
    options <= "ZZ";
    wait for 20 ns;
    
    -- Not enough money
    money_entered <= "00110"; wait for 4 ns; money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000011";
    options <= "ZZ";
    wait for 4 ns;
    money_entered <= "00010"; wait for 4 ns; money_entered <= "00000";
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000011";
    options <= "ZZ";
    wait for 20 ns;
    
    -- No change
    change_available <= "00000";
    
    -- Abort
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    wait for 10 ns; money_entered <= "00010"; wait for 4 ns;
    money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000110";
    options <= "ZZ";
    wait for 4 ns;
    options <= "00";
    wait for 4 ns;
    options <= "ZZ";
    wait for 20 ns;

    -- Neglect Change
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    wait for 10 ns; money_entered <= "00010"; wait for 4 ns;
    money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000110";
    options <= "ZZ";
    wait for 4 ns;
    options <= "01";
    wait for 4 ns;
    options <= "ZZ";
    wait for 20 ns;    
    
    -- Extra Item(s)
    -- Best Case
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000";
    money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000110";
    options <= "ZZ";
    wait for 20 ns; 
    
    -- Worst Case
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    wait for 10 ns; money_entered <= "00010"; wait for 4 ns;
    money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "001100000110";
    options <= "ZZ";
    wait for 4 ns;
    options <= "10";
    wait for 4 ns;
    item_selected <= "000100000001";
    options <= "ZZ";
    wait for 4 ns;
    money_entered <= "00010"; wait for 4 ns; money_entered <= "00000"; 
    options <= "11"; wait for 4 ns;
    item_selected <= "000100000001";
    options <= "ZZ";
    wait for 20 ns; 
    
        
    -- More than 5000
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    money_entered <= "00100"; wait for 4 ns; money_entered <= "00000"; 
    money_entered <= "01100"; wait for 4 ns; money_entered <= "00000";
    options <= "11";
    wait for 4 ns;
    item_selected <= "010100001000";
    options <= "ZZ";
    wait for 20 ns;
        
    wait;
  end process;

end architecture;
