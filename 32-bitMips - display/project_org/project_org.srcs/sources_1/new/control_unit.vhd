----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Arthur Rinaldi de Oliveira
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity control_unit is
    Port ( 
        -- Entradas do controle
        clk                 : in  std_logic;
        rst_n               : in  std_logic;
        flag_zero           : in  std_logic;
        flag_neg            : in std_logic;
        flag_overflow       : in std_logic;
        flag_sig_overflow   : in std_logic;
        decoded_inst        : in decoded_instruction_type;
        -- Saidas do controle
        --Registradores
        ir_enable           : out  std_logic;    -- Permite alterar RI                                     
        pc_enable           : out  std_logic;    -- Permite alterar o PC                              
        flags_enable        : out  std_logic;    -- Permite alterar as flags                          
        write_reg_en        : out  std_logic;    -- Permite escrita no banco de registradores         
        -- Multiplexadores
        load_mux            : out  std_logic;
        adress_mux          : out  std_logic;
        new_pc_sel          : out  std_logic;    -- Seletor da entrada de PC, desvio ou soma um
        branch_mux          : out  std_logic;
        halt_signal         : out std_logic;
        -- Controle da memoria
        escrita             : out  std_logic
        );
end control_unit;


architecture rtl of control_unit is

        type state_type is (FETCH,DECODE,NEXT1,NEXT2,ULA_1,STORE,STORE2,LOAD,LOAD2,BRANCH,BZERO,BNEG,JUMP,NOP,HALT);
        signal state : state_type;
        
begin

    MAQUINA_DE_ESTADO:    process(clk, rst_n,state)
    begin
    if rst_n = '1' and rising_edge(clk) then
        ir_enable <= '1';
        state <= FETCH;
    elsif(rising_edge(clk)) then
        ir_enable     <= '0';
        pc_enable     <= '0';
        flags_enable  <= '0';
        write_reg_en  <= '0';
        load_mux      <= '0';
        adress_mux    <= '0';
        new_pc_sel    <= '0';
        branch_mux    <= '0';
        escrita       <= '0';
        case state is
            when FETCH=>
                state <= DECODE;
            when DECODE=> 
                if decoded_inst = I_LOAD then
                    state <= LOAD;
                elsif decoded_inst = I_STORE then
                    escrita       <= '1';
                    state <= STORE;
                elsif decoded_inst = I_ADD then
                    state <= ULA_1;
                elsif decoded_inst = I_SUB then
                    state <= ULA_1;
                elsif decoded_inst = I_AND then
                    state <= ULA_1;
                elsif decoded_inst = I_OR then
                    state <= ULA_1;
                elsif decoded_inst = I_BRANCH then
                    state <= BRANCH;
                elsif decoded_inst = I_BZERO then
                    state <= BZERO;
                elsif decoded_inst = I_BNE then
                    state <= BNEG;    
                elsif decoded_inst = I_JMP then
                    state <= JUMP;
                elsif decoded_inst = I_NOP then
                    state <= NOP;
                elsif decoded_inst = I_MULT then
                    state <= ULA_1;
                elsif decoded_inst = I_SQR then
                    state <= ULA_1;
                else -- HALT
                    state <= HALT;
                end if; 
            when LOAD=>
                write_reg_en  <= '1';
                load_mux      <= '1'; 
                adress_mux    <= '1';
                state<=LOAD2;      
            when LOAD2=>
                load_mux      <= '1'; 
                pc_enable     <= '1';
                adress_mux    <= '1';
                state<=NEXT1;  
            when STORE=>
               adress_mux    <= '1'; 
               state<=STORE2;       
            when STORE2=>
               adress_mux    <= '1'; 
               escrita<= '1';
               pc_enable     <= '1';
               state<=NEXT1;
            when ULA_1=>
                load_mux      <= '0';
                write_reg_en  <= '1';
                flags_enable  <= '1';
                pc_enable     <= '1';
                state<=NEXT1;
            when JUMP =>
                branch_mux    <= '1';
                new_pc_sel    <= '1';
                pc_enable     <= '1';
                state <= NEXT1;
            when BRANCH=>
                branch_mux    <= '0';
                new_pc_sel    <= '1';
                pc_enable     <= '1';
                state <= NEXT1;
            when BZERO=>
                if flag_zero = '1' then
                    branch_mux    <= '1';
                    new_pc_sel    <= '1';
                end if;
                pc_enable     <= '1';
                state <= NEXT1;
            when BNEG=>
                if flag_neg = '1' then
                    branch_mux    <= '1';
                    new_pc_sel    <= '1';
                end if;
                pc_enable     <= '1';
                state <= NEXT1;
            when NEXT1=>            -- 
                ir_enable <= '1';
                flags_enable  <= '0';
                escrita <= '0';
                write_reg_en  <= '0';   
                state <= NEXT2;
            when NEXT2=>            --  
                state <= FETCH;
            when NOP=>
                ir_enable <= '1';
                state <= FETCH;
            when HALT=>
                halt_signal <= '1';
            when others=>
                 state <= HALT;     
           end case;
     end if;


end process MAQUINA_DE_ESTADO;

end rtl;
