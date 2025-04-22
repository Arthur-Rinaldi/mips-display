##################################################
# Arquivo XDC para configurar os pinos de controle
# do display de 7 segmentos e botões na placa Nexys 4 DDR
##################################################

# =========================================================================
# CONEXÃO DOS DISPLAY DE 7 SEGMENTOS
# =========================================================================
# Neste arquivo, você deve mapear os sinais do seu código VHDL para os pinos
# físicos da placa Nexys 4 DDR. Certifique-se de configurar corretamente 
# os pinos dos displays de 7 segmentos e o sinal de controle dos displays.

# =========================================================================
# 1. Pinos de Anodo (Controle de qual display está ativo)
# =========================================================================
# Os displays de 7 segmentos têm pinos de anodo que controlam qual display
# estará ativo. Aqui, estamos associando os pinos da placa aos sinais 
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
# Agora, você precisa conectar os pinos de controle dos segmentos de A a G
# do display de 7 segmentos, que são os pinos que definem quais segmentos
# são acesos para formar os números.

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
# 3. Configuração do Clock
# =========================================================================
# Para que o design funcione corretamente, você também precisará configurar 
# o clock da placa. A Nexys 4 DDR tem um clock de 100 MHz, que será utilizado
# no design. O sinal de clock pode ser mapeado para um dos pinos de entrada de
# clock da placa.

# Mapeando o pino do clock (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN E3 [get_ports clk]  # Pino de clock (ajuste conforme o seu projeto)

# =========================================================================
# 4. Configuração do Reset (opcional)
# =========================================================================
# Se você estiver utilizando um sinal de reset (rst) no seu código VHDL,
# você pode conectar o pino de reset da placa ao sinal de reset.

# Mapeando o pino de reset (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN D2 [get_ports rst]  # Pino de reset (ajuste conforme o seu projeto)

# =========================================================================
# 5. Configuração dos Botões
# =========================================================================
# A Nexys 4 DDR possui 4 botões de entrada que podem ser utilizados no seu design.
# Aqui, vamos mapear os botões para as entradas adequadas no seu código.

# Botão "Cima" (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN J17 [get_ports btn_up]  # Botão Cima

# Botão "Baixo" (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN H17 [get_ports btn_down]  # Botão Baixo

# Botão "Esquerda" (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN G18 [get_ports btn_left]  # Botão Esquerda

# Botão "Direita" (exemplo, ajuste conforme necessário):
set_property PACKAGE_PIN F18 [get_ports btn_right]  # Botão Direita

# =========================================================================
# ATENÇÃO:
# Certifique-se de ajustar os pinos e a configuração de clock de acordo com 
# o manual da sua placa Nexys 4 DDR. Os pinos mencionados acima são apenas 
# exemplos, e você deve verificar os pinos reais utilizados para as conexões 
# dos displays, botões e outros sinais no manual ou na documentação da Nexys 4 DDR.
# =========================================================================
