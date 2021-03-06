library ieee;
use ieee.std_logic_1164.all;


entity itemToPriceDummy is
end entity;

architecture itemToPriceDummyArch of itemToPriceDummy is
  component itemToPrice
  port (
    itemNumber : in  std_logic_vector(9 downto 0);
    price      : out std_logic_vector(4 downto 0)
  );
  end component itemToPrice;

  signal num: std_logic_vector(9 downto 0);
  signal price: std_logic_vector(4 downto 0);
begin
  U0: itemToPrice port map(num, price);
  process is
    begin
      wait for 0 ns;
        num <= "0001100101"; wait for 10 ns;
        num <= "0001100110"; wait for 10 ns;
        num <= "0001100100"; wait for 10 ns;
        num <= "0001110101"; wait for 10 ns;
        num <= "0100101111"; wait for 10 ns;
        num <= "0101100100"; wait for 10 ns;
      wait;
    end process;

end architecture;
