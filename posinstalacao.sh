#!/bin/bash

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    echo "Desculpe, notei que esse script não está sendo executado em modo root."
    echo "Por favor, feche e abra no terminal como root."
    exit 1
else
    echo "Script executado como root. Procedendo com os procedimentos..."
fi

# Etapa 1 - Configuração do sources.list
clear

echo "Você deseja fazer a configuração do sources.list?"
echo "1. Sim"
echo "2. Não"

read -p "Digite o número da opção desejada: " option

if [[ $option -eq 1 ]]; then
    clear
    echo "Fazendo a configuração do sources.list, por favor aguarde."
    sleep 2

    # Faz o backup do arquivo original
    cp /etc/apt/sources.list /etc/apt/sources.list.bkp
    echo "Backup do sources.list efetuado com sucesso!"

    clear
    echo "Realizando a nova configuração, aguarde..."
    sleep 2

    # Verifica se o nano está instalado, caso contrário, instala sem interação do usuário
    if ! command -v nano &> /dev/null; then
        apt-get install -y nano
    fi

    # Cria um arquivo temporário com o conteúdo desejado
    cat <<EOT > /tmp/sources_list_temp
# Repositórios Oficiais - Debian 12 'Bookworm'

## Para habilitar os repos de código fonte (deb-src) e Backports basta retirar a # da linha correspondente ##

deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
# deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware

## Debian Bookworm Backports
deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
# deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
EOT

    # Substitui o arquivo sources.list pelo arquivo temporário
    mv /tmp/sources_list_temp /etc/apt/sources.list

    echo "Configuração feita com sucesso! Agora vamos para as outras etapas."
else
    clear
    echo "Continuando para as próximas etapas do script."
fi

# Teste de conexão com a internet
clear
echo "Estou verificando sua conexão com a internet..."
ping -c 1 google.com > /dev/null

if [[ $? -ne 0 ]]; then
    clear
    echo "Não podemos continuar, pois você está sem internet."
    exit 1
fi

# Atualização do sistema
clear
echo "Estou verificando o seu sistema e realizando uma atualização completa!"
apt-get update

# Exibição da barra de status da atualização
status_bar_length=20

echo -n "["
for ((i=0; i<=${status_bar_length}; i++)); do
    sleep 0.2
    echo -n "="
done
echo "]"
clear
read -p "Você deseja instalar o 'sudo'? (1- Sim, 2- Não): " option

if [[ $option -eq 1 ]]; then
    # Instalação do sudo
    apt-get install -y sudo

    # Configuração do sudo para o usuário atual
    current_user=$(whoami)
    echo "$current_user ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null

    # Verificação de outros usuários
    other_users=$(awk -F'[/:]' '{if ($3 >= 1000 && $1 != "nobody") print $1}' /etc/passwd)

    if [[ -n $other_users ]]; then
        echo "Usuários detectados:"

        # Listagem de usuários em ordem alfabética
        sorted_users=$(echo "$other_users" | sort)
        echo "$sorted_users"

        read -p "Deseja fazer a configuração para esses usuários? (1- Sim, 2- Não): " config_option

        if [[ $config_option -eq 1 ]]; then
            for user in $sorted_users; do
                echo "$user ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
            done
        fi
    fi
fi
echo "Você deseja instalar codecs no Debian?"
echo "Iremos instalar uma seleção de codecs e ferramentas de áudio e vídeo, incluindo o suporte para formatos como AAC, MP3, FLAC, Vorbis e outros."
echo "Esses codecs são amplamente utilizados e permitem a reprodução e manipulação de diferentes tipos de arquivos de mídia."
read -p "Opções: 1- Sim, 2- Não: " option

if [[ $option -eq 1 ]]; then
    # Instalação dos codecs
    echo "Instalando codecs..."
    sleep 1

    # Pacotes de codecs a serem instalados
    codecs="faad ffmpeg gstreamer1.0-fdkaac gstreamer1.0-libav gstreamer1.0-vaapi gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly lame libavcodec-extra libavcodec-extra59 libavdevice59 libgstreamer1.0-0 sox twolame vorbis-tools"

    # Instalação dos codecs com barra animada
    echo -n "["
    for ((i=0; i<=100; i+=10)); do
        echo -n "="
        sleep 0.1
    done
    echo -n "]"
    sleep 4
    echo "Configuração de codecs concluída!"
    sleep 1

    # Instalação do VLC
    clear
    read -p "Você deseja instalar o VLC? (1- Sim, 2- Não): " vlc_option

    if [[ $vlc_option -eq 1 ]]; then
        echo "Instalando o VLC..."
        sleep 1

        # Instalação do VLC com barra animada
        echo -n "["
        for ((i=0; i<=100; i+=10)); do
            echo -n "="
            sleep 0.1
        done
        echo -n "]"
        sleep 4
        echo "Instalação do VLC concluída!"
        sleep 1

        # Atualização do sistema após a instalação do VLC
        echo "Atualizando o sistema..."
        sleep 1

        # Atualização do sistema com barra animada
        echo -n "["
        for ((i=0; i<=100; i+=10)); do
            echo -n "="
            sleep 0.1
        done
        echo -n "]"
        sleep 4
        echo "Atualização do sistema concluída!"
        sleep 1

        # Limpeza da tela e continuação do script
        clear
        echo "Continuando o script..."
        sleep 4
        clear
    else
        # Limpeza da tela e continuação do script
        clear
    fi
else
    # Mensagem de continuação do script
    echo "Entendo, continuando o script..."
    sleep 4
    clear
fi
clear
echo "===================="
echo "Nessa etapa vamos realizar instalações e configurações diversas"
echo "===================="
sleep 2
clear

# Instalação de insumos necessários
echo "Instalando insumos necessários..."
sleep 1
apt install wget curl dpkg htop neofetch build-essential git-all
clear

# Instalação de pacotes para gerir arquivos compactados
echo "Você deseja instalar pacotes necessários para gerir arquivos compactados?"
read -p "Opções: 1- Sim, 2- Não: " compact_option

if [[ $compact_option -eq 1 ]]; then
    echo "Instalando pacotes para gerir arquivos compactados..."
    sleep 1
    apt install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip
    clear
else
    clear
fi

# Instalação de navegadores
echo "Deseja realizar a instalação de algum navegador abaixo?"
echo "Opções: 1- Google Chrome, 2- Microsoft Edge, 3- Brave"
echo "Ou se deseja instalar mais de um, responda com os números desejados separados por vírgula. Exemplo: 1,2,3."
read -p "Opções: " browser_options

if [[ $browser_options == *"1"* ]]; then
    echo "Instalando o Google Chrome..."
    sleep 1
    cd /tmp && wget -O google-chrome-stable.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
    apt install ./google-chrome-stable.deb && cd $HOME
fi

if [[ $browser_options == *"2"* ]]; then
    echo "Instalando o Microsoft Edge..."
    sleep 1
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
    cd ..
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
    sudo apt install microsoft-edge-stable
fi

if [[ $browser_options == *"3"* ]]; then
    echo "Instalando o Brave..."
    sleep 1
    sudo apt install curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
fi

clear

# Instalação do Wine
echo "Você deseja instalar o Wine?"
read -p "Opções: 1- Sim, 2- Não: " wine_option

if [[ $wine_option -eq 1 ]]; then
    echo "Instalando o Wine..."
    sleep 1
    sudo dpkg --add-architecture i386 && sudo mkdir -pm755 /etc/apt/keyrings && sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
    sudo apt install --install-recommends winehq-stable
fi

clear

# Instalação da Steam
echo "Deseja instalar a Steam?"
read -p "Opções: 1- Sim, 2- Não: " steam_option

if [[ $steam_option -eq 1 ]]; then
    echo "Instalando a Steam..."
    sleep 1
    dpkg --add-architecture i386 && apt update && apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386 && apt install steam
fi

clear

# Atualização do firmware do processador
echo "Deseja atualizar o firmware do seu processador?"
read -p "Opções: 1- Sim, 2- Não: " firmware_option

if [[ $firmware_option -eq 1 ]]; then
    echo "Qual processador você está usando?"
    read -p "Opções: 1- Intel, 2- AMD: " processor_option

    if [[ $processor_option -eq 1 ]]; then
        echo "Instalando o firmware do processador Intel..."
        sleep 1
        apt install intel-microcode
    elif [[ $processor_option -eq 2 ]]; then
        echo "Instalando o firmware do processador AMD..."
        sleep 1
        apt install amd64-microcode
    fi
fi

clear

# Instalação de softwares de edição/produção
echo "Você deseja instalar softwares de edição/produção no Debian?"
read -p "Opções: 1- Sim, 2- Não: " editing_option

if [[ $editing_option -eq 1 ]]; then
    echo "Abaixo selecione quais softwares você deseja instalar, se for mais de um, digite os números separados por vírgula."
    echo "Opções:"
    echo "1- Audacity"
    echo "2- Blender"
    echo "3- GIMP"
    echo "4- Inkscape"
    echo "5- Kdenlive"
    echo "6- Krita"
    echo "7- OBS Studio"
    echo "8- OpenShot-qt"
    read -p "Opções: " software_options

    if [[ $software_options == *"1"* ]]; then
        echo "Instalando o Audacity..."
        sleep 1
        apt install audacity
    fi

    if [[ $software_options == *"2"* ]]; then
        echo "Instalando o Blender..."
        sleep 1
        apt install blender
    fi

    if [[ $software_options == *"3"* ]]; then
        echo "Instalando o GIMP..."
        sleep 1
        apt install gimp
    fi

    if [[ $software_options == *"4"* ]]; then
        echo "Instalando o Inkscape..."
        sleep 1
        apt install inkscape
    fi

    if [[ $software_options == *"5"* ]]; then
        echo "Instalando o Kdenlive..."
        sleep 1
        apt install kdenlive
    fi

    if [[ $software_options == *"6"* ]]; then
        echo "Instalando o Krita..."
        sleep 1
        apt install krita
    fi

    if [[ $software_options == *"7"* ]]; then
        echo "Instalando o OBS Studio..."
        sleep 1
        apt install obs-studio
    fi

    if [[ $software_options == *"8"* ]]; then
        echo "Instalando o OpenShot-qt..."
        sleep 1
        apt install openshot-qt
    fi
fi

clear

# Instalação do Telegram
echo "Deseja instalar o Telegram?"
read -p "Opções: 1- Sim, 2- Não: " telegram_option

if [[ $telegram_option -eq 1 ]]; then
    echo "Instalando o Telegram..."
    sleep 1
    apt install telegram-desktop
fi

clear

# Instalação do Mozilla Thunderbird
echo "Deseja instalar o Mozilla Thunderbird?"
read -p "Opções: 1- Sim, 2- Não: " thunderbird_option

if [[ $thunderbird_option -eq 1 ]]; then
    echo "Instalando o Mozilla Thunderbird..."
    sleep 1
    apt install thunderbird thunderbird-l10n-pt-br
fi

clear

# Instalação das Fontes da Microsoft
echo "Deseja instalar as Fontes da Microsoft?"
read -p "Opções: 1- Sim, 2- Não: " font_option

if [[ $font_option -eq 1 ]]; then
    echo "Instalando as Fontes da Microsoft..."
    sleep 1
    apt install cabextract curl fontconfig xfonts-utils
    ttf-mscorefonts-installer
fi

clear

# Instalação do GDebi
echo "Deseja instalar o GDebi?"
read -p "Opções: 1- Sim, 2- Não: " gdebi_option

if [[ $gdebi_option -eq 1 ]]; then
    echo "Instalando o GDebi..."
    sleep 1
    apt install gdebi
fi

clear

# Instalação do qBittorrent
echo "Deseja instalar o qBittorrent?"
read -p "Opções: 1- Sim, 2- Não: " qbittorrent_option

if [[ $qbittorrent_option -eq 1 ]]; then
    echo "Instalando o qBittorrent..."
    sleep 1
    apt install qbittorrent
fi

clear

# Instalação e configuração do Flatpak + Flathub
echo "Deseja instalar e configurar o Flatpak + Flathub?"
read -p "Opções: 1- Sim, 2- Não: " flatpak_option

if [[ $flatpak_option -eq 1 ]]; then
    echo "Instalando o Flatpak..."
    sleep 1
    apt install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

clear

clear
echo "===================="
echo "Informações de Contato"
echo "===================="
echo "Nome: Luís Eduardo"
echo "Email: contato@luiseduardodias.com"
echo "Instagram: luiseduardo.dcd"
echo "Se ver algum valor no script e querer ajudar, pix: 9784adf1-2cab-46f2-a1c7-fb340b0f4d5d"
echo "Youtube: luiseduardodo-TioKill"



