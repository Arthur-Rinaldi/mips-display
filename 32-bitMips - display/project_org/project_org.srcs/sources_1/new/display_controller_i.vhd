library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_controller_i is
    Port (
        clk             : in std_logic;            -- Clock
        rst             : in std_logic;            -- Reset
        btn_mem         : in std_logic;            -- Botão para alternar para memória
        btn_reg         : in std_logic;            -- Botão para alternar para registradores
        mem_data_in     : in std_logic_vector(15 downto 0);  -- Dados da memória
        reg_data_in     : in std_logic_vector(15 downto 0);  -- Dados dos registradores
        seg_mem         : out std_logic_vector(6 downto 0);  -- Controle do display de 7 segmentos (memória)
        seg_reg         : out std_logic_vector(6 downto 0)   -- Controle do display de 7 segmentos (registradores)
    );
end display_controller_i;

architecture Behavioral of display_controller_i is
    signal mem_display_data : std_logic_vector(15 downto 0);  -- Dados para exibir no display de memória
    signal reg_display_data : std_logic_vector(15 downto 0);  -- Dados para exibir no display de registradores
    signal display_sel      : std_logic := '0';               -- Seleção entre memória e registrador

    -- Definir os sinais para os displays de 7 segmentos
    signal seg_display      : std_logic_vector(6 downto 0);   -- Saída para um único display de 7 segmentos
    signal digit_sel        : std_logic_vector(3 downto 0);   -- Seleção dos 4 dígitos (cada dígito será controlado por um display)

begin
    -- Alterna entre os displays de memória e registradores
    process(clk, rst)
    begin
        if rst = '1' then
            display_sel <= '0';
        elsif rising_edge(clk) then
            if btn_mem = '1' then
                display_sel <= '0';  -- Exibir dados da memória
            elsif btn_reg = '1' then
                display_sel <= '1';  -- Exibir dados dos registradores
            end if;
        end if;
    end process;

    -- Seleção de dados a exibir nos displays
    process(display_sel, mem_data_in, reg_data_in)
    begin
        if display_sel = '0' then
            mem_display_data <= mem_data_in;  -- Dados da memória
        else
            reg_display_data <= reg_data_in;  -- Dados dos registradores
        end if;
    end process;

    -- Função para converter o valor binário em um código de 7 segmentos (usando um caso simples para os números de 0 a 9)
    function to_7_segment (input : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(6 downto 0);
    begin
        case input is
            when "0000" => result := "0000001"; -- 0
            when "0001" => result := "1001111"; -- 1
            when "0010" => result := "0010010"; -- 2
            when "0011" => result := "0000110"; -- 3
            when "0100" => result := "1001100"; -- 4
            when "0101" => result := "0100100"; -- 5
            when "0110" => result := "0100000"; -- 6
            when "0111" => result := "0001111"; -- 7
            when "1000" => result := "0000000"; -- 8
            when "1001" => result := "0000100"; -- 9
            when others => result := "1111111"; -- Default (all segments off)
        end case;
        return result;
    end function;

    -- Controlando os displays de 7 segmentos
    process(clk)
    begin
        if rising_edge(clk) then
            -- Multiplexação dos 4 displays
            if display_sel = '0' then  -- Exibindo dados de memória
                -- Seleciona o dígito da memória para exibição no display
                digit_sel <= mem_display_data(15 downto 12);  -- Digito 1
                seg_mem <= to_7_segment(digit_sel);
                
                -- Alterar os outros dígitos para exibir a memória em sequência (fazer o mesmo para outros 3 dígitos)
                -- Aqui está o exemplo para o primeiro dígito, siga a mesma lógica para os outros 3
                -- Exemplo: 
                -- digit_sel <= mem_display_data(11 downto 8); -- Digito 2
                -- seg_mem <= to_7_segment(digit_sel);
                -- Repita para todos os outros dígitos
            else
                -- Exibindo dados dos registradores
                digit_sel <= reg_display_data(15 downto 12);  -- Digito 1
                seg_reg <= to_7_segment(digit_sel);
                
                -- Alterar os outros dígitos para exibir os registradores em sequência
                -- Repita a mesma lógica para os outros dígitos
            end if;
        end if;
    end process;

end Behavioral;
