##################################################
# Arquivo XDC para configurar os pinos de controle
# do display de 7 segmentos e bot�es na placa Nexys 4 DDR
##################################################

# =========================================================================
# CONEX�O DOS DISPLAY DE 7 SEGMENTOS
# =========================================================================
# Neste arquivo, voc� deve mapear os sinais do seu c�digo VHDL para os pinos
# f�sicos da placa Nexys 4 DDR. Certifique-se de configurar corretamente 
# os pinos dos displays de 7 segmentos e o sinal de controle dos displays.

# =========================================================================
# 1. Pinos de Anodo (Controle de qual display est� ativo)
# =========================================================================
# Os displays de 7 segmentos t�m pinos de anodo que controlam qual display
# estar� ativo. Aqui, estamos associando os pinos da placa aos sinais 
# de controle dos displays de 7 segmentos.

# Display 0 (primeiro display)
set_property PACKAGE_PIN A7 [get_ports an[0]]  # Display 0

# Display 1
set_property PACKAGE_PIN B7 [get_ports an[1]]  # Display 1

# Display 2
set_property PACKAGE_PIN C7 [get_ports an[2]]  # Display 2

# Display 3
set_property PACKAGE_PIN D7 [get_ports an[3]]  # Display 3

# =========================================================================
# 2. Pinos dos Segmentos (Controle dos segmentos A-G)
# =========================================================================
# Agora, voc� precisa conectar os pinos de controle dos segmentos de A a G
# do display de 7 segmentos, que s�o os pinos que definem quais segmentos
# s�o acesos para formar os n�meros.

# Segmento A (pino A7)
set_property PACKAGE_PIN G17 [get_ports seg[0]]  # Segmento A

# Segmento B (pino B7)
set_property PACKAGE_PIN G16 [get_ports seg[1]]  # Segmento B

# Segmento C (pino C7)
set_property PACKAGE_PIN F15 [get_ports seg[2]]  # Segmento C

# Segmento D (pino D7)
set_property PACKAGE_PIN F14 [get_ports seg[3]]  # Segmento D

# Segmento E (pino E7)
set_property PACKAGE_PIN E16 [get_ports seg[4]]  # Segmento E

# Segmento F (pino F7)
set_property PACKAGE_PIN E15 [get_ports seg[5]]  # Segmento F

# Segmento G (pino G7)
set_property PACKAGE_PIN D16 [get_ports seg[6]]  # Segmento G

# =========================================================================
# 3. Configura��o do Clock
# =========================================================================
# Para que o design funcione corretamente, voc� tamb�m precisar� configurar 
# o clock da placa. A Nexys 4 DDR tem um clock de 100 MHz, que ser� utilizado
# no design. O sinal de clock pode ser mapeado para um dos pinos de entrada de
# clock da placa.

# Mapeando o pino do clock (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN E3 [get_ports clk]  # Pino de clock (ajuste conforme o seu projeto)

# =========================================================================
# 4. Configura��o do Reset (opcional)
# =========================================================================
# Se voc� estiver utilizando um sinal de reset (rst) no seu c�digo VHDL,
# voc� pode conectar o pino de reset da placa ao sinal de reset.

# Mapeando o pino de reset (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN D2 [get_ports rst]  # Pino de reset (ajuste conforme o seu projeto)

# =========================================================================
# 5. Configura��o dos Bot�es
# =========================================================================
# A Nexys 4 DDR possui 4 bot�es de entrada que podem ser utilizados no seu design.
# Aqui, vamos mapear os bot�es para as entradas adequadas no seu c�digo.

# Bot�o "Cima" (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN J17 [get_ports btn_up]  # Bot�o Cima

# Bot�o "Baixo" (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN H17 [get_ports btn_down]  # Bot�o Baixo

# Bot�o "Esquerda" (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN G18 [get_ports btn_left]  # Bot�o Esquerda

# Bot�o "Direita" (exemplo, ajuste conforme necess�rio):
set_property PACKAGE_PIN F18 [get_ports btn_right]  # Bot�o Direita

# =========================================================================
# ATEN��O:
# Certifique-se de ajustar os pinos e a configura��o de clock de acordo com 
# o manual da sua placa Nexys 4 DDR. Os pinos mencionados acima s�o apenas 
# exemplos, e voc� deve verificar os pinos reais utilizados para as conex�es 
# dos displays, bot�es e outros sinais no manual ou na documenta��o da Nexys 4 DDR.
# =========================================================================
