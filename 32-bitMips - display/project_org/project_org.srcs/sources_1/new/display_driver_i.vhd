library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_driver is
  Port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    bin_input  : in  std_logic_vector(3 downto 0); -- Valor binário de 4 bits (0 a F)
    seg        : out std_logic_vector(6 downto 0); -- Segmentos a-g
    an         : out std_logic_vector(3 downto 0)  -- Anodos (4 displays)
  );
end display_driver;

architecture Behavioral of display_driver is

  -- Contador para alternar entre os displays
  signal display_counter : integer range 0 to 3 := 0;

begin

  -- Processo que alterna o display ativo a cada ciclo de clock
  process(clk, rst)
  begin
    if rst = '1' then
      display_counter <= 0;  -- Reset do contador
    elsif rising_edge(clk) then
      -- Incrementa o contador e faz a rotação
      if display_counter = 3 then
        display_counter <= 0;  -- Se chegou no final, volta ao primeiro display
      else
        display_counter <= display_counter + 1;
      end if;
    end if;
  end process;

  -- Atribuindo valor a "an" com base no contador
  process(display_counter)
  begin
    case display_counter is
      when 0 => an <= "1110"; -- Display 0 ativo
      when 1 => an <= "1101"; -- Display 1 ativo
      when 2 => an <= "1011"; -- Display 2 ativo
      when 3 => an <= "0111"; -- Display 3 ativo
      when others => an <= "1111"; -- Nenhum display ativo
    end case;
  end process;

  -- Conversão de 4 bits para 7 segmentos
  process(bin_input)
  begin
    case bin_input is
      when "0000" => seg <= "1000000"; -- 0
      when "0001" => seg <= "1111001"; -- 1
      when "0010" => seg <= "0100100"; -- 2
      when "0011" => seg <= "0110000"; -- 3
      when "0100" => seg <= "0011001"; -- 4
      when "0101" => seg <= "0010010"; -- 5
      when "0110" => seg <= "0000010"; -- 6
      when "0111" => seg <= "1111000"; -- 7
      when "1000" => seg <= "0000000"; -- 8
      when "1001" => seg <= "0010000"; -- 9
      when "1010" => seg <= "0001000"; -- A
      when "1011" => seg <= "0000011"; -- b
      when "1100" => seg <= "1000110"; -- C
      when "1101" => seg <= "0100001"; -- d
      when "1110" => seg <= "0000110"; -- E
      when "1111" => seg <= "0001110"; -- F
      when others => seg <= "1111111"; -- Apaga tudo
    end case;
  end process;

end Behavioral;
