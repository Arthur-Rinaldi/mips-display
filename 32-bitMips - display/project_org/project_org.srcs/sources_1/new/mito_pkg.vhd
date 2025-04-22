----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Newton Jr
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



package mito_pkg is
                                                                                                                                                            --NOVAS
  type decoded_instruction_type is (I_LOAD, I_LOADI, I_STORE, I_ADD, I_SUB, I_AND, I_OR, I_ADDI, I_SUBI, I_MOV, I_MULI, I_JMP,I_BRANCH, I_BEQ,I_BZERO, I_BNE, I_HALT, I_NOP, I_ADDSTORE, I_ADDLOAD, I_SUBSTORE, I_SUBLOAD, I_LUILW, I_LIS, I_LDS, I_MULT,I_SQR);
  
  component data_path
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
  end component;

  component control_unit
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
  end component;
  
  component memory is
		port(        
        clk                 : in  std_logic;
        escrita             : in  std_logic;
        rst_n               : in  std_logic;        
        data_out            : in  std_logic_vector(15 downto 0); --Entrada da memoria
        adress_pc           : in  std_logic_vector(8  downto 0);
        data_in             : out std_logic_vector(15 downto 0)  --Saida da memoria
		 );
   end component;

  component mito
  port (
    rst_n        			: in  std_logic;
    clk          			: in  std_logic;
    adress_pc    			: in  std_logic_vector (8  downto 0);
    data_in 			    : in  std_logic_vector (15 downto 0);  
    data_out 		        : out std_logic_vector (15 downto 0)
    --write_enable 			: out std_logic
  );
  end component;
  
 component testbench is
  port (
       signal clk 				: in  std_logic := '0';
       signal reset 			: in  std_logic;
       signal data_in 	        : in  std_logic_vector (15 downto 0);
       signal data_out       	: out std_logic_vector (15 downto 0)
  ); 
  
  end component;   

end mito_pkg;

package body mito_pkg is
end mito_pkg;