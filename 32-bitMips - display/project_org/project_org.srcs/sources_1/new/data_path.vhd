----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Arthur Rinaldi de Oliveira
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity data_path is
  Port (
    -- Entradas do datapath
    clk                 : in  std_logic;
    rst_n               : in  std_logic;
    -- Registradores
    ir_enable           : in  std_logic;    -- Permite alterar RI
    pc_enable           : in  std_logic;    -- Permite alterar o PC
    flags_enable        : in  std_logic;    -- Permite alterar as flags
    write_reg_en        : in  std_logic;    -- Permite escrita no banco de registradores
    -- Multiplexadores
    load_mux            : in  std_logic;
    adress_mux          : in  std_logic;
    new_pc_sel          : in  std_logic;    -- Seletor da entrada de PC, desvio ou soma um
    branch_mux          : in  std_logic;
    -- Saidas do datapath
    decoded_inst        : out decoded_instruction_type;   -- O sinal da instrução que vai para a maquina de estados
    flag_zero           : out std_logic;
    flag_neg            : out std_logic;
    flag_overflow       : out std_logic;
    flag_sig_overflow   : out std_logic;
    -- Saida e entrada da memoria
    adress_pc           : out std_logic_vector (8 downto 0);
    data_in             : in  std_logic_vector (15 downto 0);       
    data_out            : out std_logic_vector (15 downto 0)        
    
  );
end data_path;

architecture rtl of data_path is

signal instruction          : std_logic_vector (15 downto 0);   -- Saida do registrador de instruções
signal pc_out               : std_logic_vector (8  downto 0);   -- Saida do PC 
signal pc_in                : std_logic_vector (8  downto 0);   -- Entrada do PC 

-- Sinais que saem do decoder
signal ULA_OP               : std_logic_vector (2  downto 0);   -- Seta a operação da ula
signal adress               : std_logic_vector (8  downto 0);   -- Endereço de jump, load e store
signal store_adress         : std_logic_vector (8  downto 0);   -- Endereço de store e load
signal REG_A                : std_logic_vector (3  downto 0);   -- 
signal REG_B                : std_logic_vector (3  downto 0);   --
signal REG_DEST             : std_logic_vector (3  downto 0);   -- Seta o registrador destino
--Sai do multiplexador
signal pc_desvio            : std_logic_vector (8  downto 0);   -- Escolhe entre branch e jump
    
-- Registradores
signal reg0                : std_logic_vector (15 downto 0);
signal reg1                : std_logic_vector (15 downto 0);
signal reg2                : std_logic_vector (15 downto 0);
signal reg3                : std_logic_vector (15 downto 0);
signal reg4                : std_logic_vector (15 downto 0);
signal reg5                : std_logic_vector (15 downto 0);
signal reg6                : std_logic_vector (15 downto 0);
signal reg7                : std_logic_vector (15 downto 0);
signal reg8                : std_logic_vector (15 downto 0);
signal reg9                : std_logic_vector (15 downto 0);
signal reg10               : std_logic_vector (15 downto 0);
signal reg11               : std_logic_vector (15 downto 0);
signal reg12               : std_logic_vector (15 downto 0);
signal reg13               : std_logic_vector (15 downto 0);
signal reg14               : std_logic_vector (15 downto 0);
signal reg15               : std_logic_vector (15 downto 0);
signal regx                : std_logic_vector (15 downto 0);
signal regt                : std_logic_vector (15 downto 0);

-- Sinais da ULA  
signal ula_out      : STD_LOGIC_VECTOR (15 downto 0);

-- Sinais do banc de registradores
signal bus_a        : STD_LOGIC_VECTOR (15 downto 0);
signal bus_a_in     : STD_LOGIC_VECTOR (15 downto 0);
signal bus_b        : STD_LOGIC_VECTOR (15 downto 0);
signal bus_c        : STD_LOGIC_VECTOR (15 downto 0);

-- FLAGS
signal zero         : std_logic;
signal neg          : std_logic;
signal overflow     : std_logic;
signal sig_overflow : std_logic;

-- SOMA SEQUENCIAL
signal nova_base_b  : STD_LOGIC_VECTOR (15 downto 0);
signal nova_base_c  : STD_LOGIC_VECTOR (15 downto 0);
signal multiplo     : STD_LOGIC_VECTOR (15 downto 0);
signal mult_0       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_1       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_2       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_3       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_4       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_5       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_6       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_7       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_8       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_9       : STD_LOGIC_VECTOR (15 downto 0);
signal mult_10      : STD_LOGIC_VECTOR (15 downto 0);
signal mult_11      : STD_LOGIC_VECTOR (15 downto 0);  
signal mult_12      : STD_LOGIC_VECTOR (15 downto 0);
signal mult_13      : STD_LOGIC_VECTOR (15 downto 0);
signal mult_14      : STD_LOGIC_VECTOR (15 downto 0);


--display
signal display_data_counter : std_logic_vector(1 downto 0) := "00";




begin
    
    PC : process (clk)
    begin
    if (rst_n = '1' AND rising_edge(clk)) then
        pc_out <= "000000000";
    elsif (pc_enable = '1' AND rising_edge(clk)) then
        pc_out <= pc_in;
    end if;
    end process PC;

    RI : process (clk)
    begin
        if (ir_enable = '1' AND rising_edge(clk)) then
            instruction <= data_in;
        end if;
    end process RI;

    FLAGS :    process (clk)
    begin
        if (flags_enable = '1' AND rising_edge(clk)) then
            flag_zero         <= zero;
            flag_neg          <= neg;
            flag_overflow     <= overflow;
            flag_sig_overflow <= sig_overflow;
    end if;
    end process flags;

    BANCO_DE_REGISTRADORES : process (clk) --Banco de registradores
    begin    
       data_out <= bus_a;
     if (rising_edge(clk)) then
            if (write_reg_en = '1') then
                case REG_DEST is
                     when "0000" => reg0  <= bus_a_in;
                     when "0001" => reg1  <= bus_a_in;
                     when "0010" => reg2  <= bus_a_in;
                     when "0011" => reg3  <= bus_a_in;
                     when "0100" => reg4  <= bus_a_in;
                     when "0101" => reg5  <= bus_a_in;
                     when "0110" => reg6  <= bus_a_in;
                     when "0111" => reg7  <= bus_a_in;
                     when "1000" => reg8  <= bus_a_in;
                     when "1001" => reg9  <= bus_a_in;
                     when "1010" => reg10 <= bus_a_in;
                     when "1011" => reg11 <= bus_a_in;
                     when "1100" => reg12 <= bus_a_in;
                     when "1101" => reg13 <= bus_a_in;
                     when "1110" => reg14 <= bus_a_in;
                     when others => reg15 <= bus_a_in;
                 end case;   
            else
                if (rst_n = '1') then
                    reg0 <= "0000000000000000";
                    reg1 <= "0000000000000000";
                    reg2 <= "0000000000000000";
                    reg3 <= "0000000000000000";
                    reg4 <= "0000000000000000"; 
                    reg5 <= "0000000000000000"; 
                    reg6 <= "0000000000000000"; 
                    reg7 <= "0000000000000000"; 
                    reg8 <= "0000000000000000"; 
                    reg9 <= "0000000000000000"; 
                    reg10<= "0000000000000000"; 
                    reg11<= "0000000000000000"; 
                    reg12<= "0000000000000000"; 
                    reg13<= "0000000000000000"; 
                    reg14<= "0000000000000000"; 
                    reg15<= "0000000000000000"; 
                 end if;
             end if;
    end if;
    end process BANCO_DE_REGISTRADORES;
    
    bus_a_wire : 
    bus_a <= reg0 when REG_DEST = "0000" else
    reg1  when REG_DEST = "0001" else
    reg2  when REG_DEST = "0010" else
    reg3  when REG_DEST = "0011" else
    reg4  when REG_DEST = "0100" else
    reg5  when REG_DEST = "0101" else
    reg6  when REG_DEST = "0110" else
    reg7  when REG_DEST = "0111" else
    reg8  when REG_DEST = "1000" else
    reg9  when REG_DEST = "1001" else
    reg10 when REG_DEST = "1010" else
    reg11 when REG_DEST = "1011" else
    reg12 when REG_DEST = "1100" else
    reg13 when REG_DEST = "1101" else
    reg14 when REG_DEST = "1110" else
    reg15;
    
    bus_b_wire : 
    bus_b <= reg0 when REG_A = "0000" else
    reg1  when REG_A = "0001" else
    reg2  when REG_A = "0010" else
    reg3  when REG_A = "0011" else
    reg4  when REG_A = "0100" else
    reg5  when REG_A = "0101" else
    reg6  when REG_A = "0110" else
    reg7  when REG_A = "0111" else
    reg8  when REG_A = "1000" else
    reg9  when REG_A = "1001" else
    reg10 when REG_A = "1010" else
    reg11 when REG_A = "1011" else
    reg12 when REG_A = "1100" else
    reg13 when REG_A = "1101" else
    reg14 when REG_A = "1110" else
    reg15;
    
    bus_c_wire :
    bus_c <= reg0 when REG_B = "0000" else
    reg1  when REG_B = "0001" else
    reg2  when REG_B = "0010" else
    reg3  when REG_B = "0011" else
    reg4  when REG_B = "0100" else
    reg5  when REG_B = "0101" else
    reg6  when REG_B = "0110" else
    reg7  when REG_B = "0111" else
    reg8  when REG_B = "1000" else
    reg9  when REG_B = "1001" else
    reg10 when REG_B = "1010" else
    reg11 when REG_B = "1011" else
    reg12 when REG_B = "1100" else
    reg13 when REG_B = "1101" else
    reg14 when REG_B = "1110" else
    reg15;
        
    ULA : process(bus_b, bus_c, ULA_OP,multiplo,nova_base_b,nova_base_c)
        begin
        overflow <= '0';
        sig_overflow <= '0';
        --multiplo <= "0000000000000000";
        mult_0   <= "0000000000000000";
        mult_1   <= "0000000000000000";
        mult_2   <= "0000000000000000";
        mult_3   <= "0000000000000000";
        mult_4   <= "0000000000000000";
        mult_5   <= "0000000000000000";
        mult_6   <= "0000000000000000";
        mult_7   <= "0000000000000000";
        mult_8   <= "0000000000000000";
        mult_9   <= "0000000000000000";
        mult_10  <= "0000000000000000";
        mult_11  <= "0000000000000000";
        mult_12  <= "0000000000000000";
        mult_13  <= "0000000000000000";
        mult_14  <= "0000000000000000";
        if  (ula_out = "0000000000000000") then
        zero <= '1';
        else
        zero <= '0';
        end if;
        if  (ula_out(15) = '1') then
        neg <= '1';
        else
        neg <= '0';
        end if;
        if(ULA_OP = "000") then --SOMA
            ula_out <= bus_b + bus_c;
            if (bus_b(15) = '0' AND bus_c(15) = '0') AND ula_out(15) = '1' then
                sig_overflow <= '1'; 
            elsif (bus_b(15) = '1' AND bus_c(15) = '1') AND ula_out(15) = '0' then
                sig_overflow <= '1';
            elsif (bus_b(15) = '0' AND bus_c(15) = '1') AND (bus_b >= (NOT bus_c) - "1") then
               overflow <= '1';
            elsif (bus_b(15) = '1' AND bus_c(15) = '0') AND ((NOT bus_b) - "1" <= bus_c) then
               overflow <= '1';
            elsif (bus_b(15)='1' and bus_c(15)='1') then
               overflow <= '1';
            end if;
        elsif(ULA_OP = "001") then -- SUB
            ula_out <= bus_b - bus_c;
            if(bus_b(15) = '0' AND bus_c(15) = '1') AND ula_out(15) = '1' then 
            sig_overflow <= '1';     
            elsif (bus_b(15) = '1' AND bus_c(15) = '0') AND ula_out(15) = '0' then
            sig_overflow <= '1';    
            elsif (bus_b(15) = '1' and bus_c(15) = '1') and ((not bus_b) - "1" <= (not bus_c)-1) then
            overflow <= '1';
            elsif (bus_b(15)='1' and bus_c(15)='0') then
            overflow <= '1'; 
            end if;
        elsif(ULA_OP = "010") then --AND   
            ula_out <= bus_b AND bus_c;
        elsif(ULA_OP = "011") then --OR   
            ula_out <= bus_b OR bus_c;
        elsif(ULA_OP = "100")  then -- MULTIPLICAÇÃO  
             if (bus_c(15)='1') then
                nova_base_c <= (not bus_c)+1;
             else
                nova_base_c <= bus_c;
             end if;
             if (bus_b(15)='1') then
                nova_base_b <= (not bus_b)+1;
             else
                nova_base_b <= bus_b;
             end if;
	         if (nova_base_b(0) = '1') then
	             mult_0 <= nova_base_c;
	         end if;     
	         if (nova_base_b(1) = '1') then
	             mult_1(15 downto 1) <= nova_base_c(14 downto 0);
	         end if;  
	         if (nova_base_b(2) = '1') then
	             mult_2(15 downto 2) <= nova_base_c(13 downto 0);
	         end if;  
	         if (nova_base_b(3) = '1') then
	             mult_3(15 downto 3)<= nova_base_c(12 downto 0);
	         end if;  
	         if (nova_base_b(4) = '1') then
	             mult_4(15 downto 4) <= nova_base_c(11 downto 0);
	         end if;  
	         if (nova_base_b(5) = '1') then
	             mult_5(15 downto 5) <= nova_base_c(10 downto 0);
	         end if;  
	         if (nova_base_b(6) = '1') then
	             mult_6(15 downto 6) <= nova_base_c(9 downto 0);
	         end if;  
	         if (nova_base_b(7) = '1') then
	             mult_7(15 downto 7) <= nova_base_c(8 downto 0);
	         end if;  
	         if (nova_base_b(8) = '1') then
	             mult_8(15 downto 8) <= nova_base_c(7 downto 0);
	         end if;  
	         if (nova_base_b(9) = '1') then
	             mult_9(15 downto 9) <= nova_base_c(6 downto 0);
	         end if;  
	         if (nova_base_b(10) = '1') then
	             mult_10(15 downto 10) <= nova_base_c(5 downto 0);
	         end if;  
	         if (nova_base_b(11) = '1') then
	             mult_11(15 downto 11) <= nova_base_c(4 downto 0);
	         end if;  
	         if (nova_base_b(12) = '1') then
	             mult_12(15 downto 12) <= nova_base_c(3 downto 0);
	         end if;  
	         if (nova_base_b(13) = '1') then
	             mult_13(15 downto 13) <= nova_base_c(2 downto 0);
	         end if;  
	         if (nova_base_b(14) = '1') then
	             mult_14(15 downto 14) <= nova_base_c(1 downto 0);
	         end if;  
	         ula_out <= multiplo;              
	         ula_out(15) <= bus_b(15) xor bus_c(15);
	    elsif(ULA_OP = "101")  then -- AO QUADRADO 
	       if (bus_c(15)='1') then
                nova_base_c <= (not bus_c)+1;
             else
                nova_base_c <= bus_c;
             end if; 
             if (nova_base_c(0) = '1') then
	             mult_0 <= nova_base_c;
	         end if;     
	         if (nova_base_c(1) = '1') then
	             mult_1(15 downto 1) <= nova_base_c(14 downto 0);
	         end if;  
	         if (nova_base_c(2) = '1') then
	             mult_2(15 downto 2) <= nova_base_c(13 downto 0);
	         end if;  
	         if (nova_base_c(3) = '1') then
	             mult_3(15 downto 3)<= nova_base_c(12 downto 0);
	         end if;  
	         if (nova_base_c(4) = '1') then
	             mult_4(15 downto 4) <= nova_base_c(11 downto 0);
	         end if;  
	         if (nova_base_c(5) = '1') then
	             mult_5(15 downto 5) <= nova_base_c(10 downto 0);
	         end if;  
	         if (nova_base_c(6) = '1') then
	             mult_6(15 downto 6) <= nova_base_c(9 downto 0);
	         end if;  
	         if (nova_base_c(7) = '1') then
	             mult_7(15 downto 7) <= nova_base_c(8 downto 0);
	         end if;  
	         if (nova_base_c(8) = '1') then
	             mult_8(15 downto 8) <= nova_base_c(7 downto 0);
	         end if;  
	         if (nova_base_c(9) = '1') then
	             mult_9(15 downto 9) <= nova_base_c(6 downto 0);
	         end if;  
	         if (nova_base_c(10) = '1') then
	             mult_10(15 downto 10) <= nova_base_c(5 downto 0);
	         end if;  
	         if (nova_base_c(11) = '1') then
	             mult_11(15 downto 11) <= nova_base_c(4 downto 0);
	         end if;  
	         if (nova_base_c(12) = '1') then
	             mult_12(15 downto 12) <= nova_base_c(3 downto 0);
	         end if;  
	         if (nova_base_c(13) = '1') then
	             mult_13(15 downto 13) <= nova_base_c(2 downto 0);
	         end if;  
	         if (nova_base_c(14) = '1') then
	             mult_14(15 downto 14) <= nova_base_c(1 downto 0);
	         end if;
	         ula_out <= multiplo;
	         ula_out(15) <= '0';
        end if;                                                             -- AQUI PODE SER POSTO MAIS OPERAÇÕES PARA A ULA
    end process ULA;
    
    Saida_Multiplo:
    multiplo<= mult_0+mult_1+mult_2+mult_3+mult_4+mult_5+mult_6+mult_7+mult_8+mult_9+mult_10+mult_11+mult_12+mult_13+mult_14;
    
    MUX_LOAD : process (load_mux,data_in,ula_out) --Multiplexador da função LOAD
    begin
    if (load_mux = '1') then
        bus_a_in <= data_in; 
    else
        bus_a_in <= ula_out(15 downto 0);
    end if;
    end process MUX_LOAD;
    
    MUX_MEM_ADRESS : process (adress_mux,pc_out,store_adress) --Multiplexador do endereço de memoria
    begin
    if (adress_mux = '1') then
        adress_pc <= store_adress; -- Recebe o endereço escrito na instrução
    else
        adress_pc <= pc_out; -- Recebe o valor de PC
    end if;
    end process MUX_MEM_ADRESS;
    
    PC_ADD : process (pc_desvio,pc_out,new_pc_sel ) --Multiplexador da entrada do pc
    begin
    if (new_pc_sel = '1') then     -- Nesse caso ocorre o desvio
        pc_in <= adress;
    else
        pc_in <= pc_out + 1; -- Não ocorre desvio
    end if;
    end process PC_ADD;
    
    DECODER : process (instruction)
    begin
        REG_A         <= instruction(7 downto 4);
        REG_B         <= instruction(3 downto 0);
        REG_DEST      <= instruction(11 downto 8);
        ULA_OP        <= instruction(14 downto 12);
        adress        <= instruction(8 downto 0);
        store_adress(8) <= instruction(12);
        store_adress(7 downto 0) <= instruction(7 downto 0);
        if instruction(15 downto 15) = "1" then                 -- Operação de ULA
            case instruction(14 downto 12) is
            when "000"=>
                decoded_inst <= I_ADD;
            when "001"=>
                decoded_inst <= I_SUB;
            when "010"=>
                decoded_inst <= I_AND;
            when "011"=>
                decoded_inst <= I_OR;
            when "100"=>
                decoded_inst <= I_MULT;
            when "101"=>
                decoded_inst <= I_SQR;
            when  others=>                  -- AQUI PODE POR MAIS FUNÇÕES DE ULA
                decoded_inst <= I_NOP;
            end case;
         else
            if instruction(14 downto 14) = "1" then             -- Operação de memoria
                if instruction(13 downto 13) = "0" then --LOAD
                    decoded_inst <= I_LOAD;
                else
                    decoded_inst <= I_STORE;
                end if;
            else                                                -- Instuções de desvio
                case instruction(13 downto 12) is
                when "00"=>
                    decoded_inst <= I_NOP;
                when "01"=>
                    case instruction(11 downto 9) is
                        when "000"=>                    --Branch forçado
                            decoded_inst <= I_BRANCH;
                        when "001"=>                    -- Branch zero
                            decoded_inst <= I_BZERO;
                        when "010"=>                    -- Branch negado
                            decoded_inst <= I_BNE;
                        when others =>                  -- Aqui pode ser adicionado novos tipos de branch
                        decoded_inst <= I_BRANCH;
                    end case;
                 when "10"=>
                     decoded_inst <= I_JMP;
                 when  "11"=> 
                     decoded_inst <= I_HALT;
                 when others =>
                     decoded_inst <= I_NOP;
                 end case;
            end if;
         end if; 
    end process DECODER;
  
end rtl;

--SINAL BINÁRIO QUE SERÁ EXIBIDO NO DISPLAY
Display_Counter_Process : process (clk, rst_n)

begin
  if rst_n = '1' then
    display_data_counter <= 0;
  elsif rising_edge(clk) then
    if display_data_counter = "11" then
    display_data_counter <= "00";
  else
     display_data_counter <= std_logic_vector(unsigned(display_data_counter) + 1);
  end if;

end process Display_Counter_Process;

-- Atualiza bin_input com base no valor atual do contador
Update_Display_Data : process(display_data_counter, adress_pc_s, data_out_s, data_in_s)
begin
  case display_data_counter is
  when "00" => bin_input <= adress_pc_s(3 downto 0);
  when "01" => bin_input <= data_out_s(3 downto 0);
  when "10" => bin_input <= data_in_s(3 downto 0);
  when "11" => bin_input <= "1101";
  when others => bin_input <= "0000";
end case;

end process Update_Display_Data;
