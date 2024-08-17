#!/bin/bash

# Atualiza o sistema operacional #
# Instalação de programas iniciais #

clear
# Verifica se o usuário é root.
USUARIO=$(whoami)
if [ $USUARIO = "root" ];then
    clear ; echo "Bem vindo root!" ; echo 
else
    echo "Somente root!"
    echo "Tente \"sudo -i\" ou \"sudo $0\""
    exit 10
fi


echo "Atualizando o sistema..." ; sleep 4
apt update && apt list --upgradable && apt upgrade -y && apt autoremove -y && apt autoclean -y


# Complementos do Gedit
clear ; echo "Instalando o Gedit completo..." ; sleep 4
apt install -y \
gedit gedit-plugins gedit-plugin-text-size > /dev/null 2>&1

# Instalação do Wine.
clear ; echo "Instalando o Wine completo..." ; sleep 4
apt install -y wine q4wine > /dev/null 2>&1

# Instalação de Navegadores.
clear ; echo "Instalando o navegador web básico..." ; sleep 4
apt install -y falkon > /dev/null 2>&1

# Programas utilitários
clear ; echo "Instalando o utilitários..." ; sleep 4
apt install -y \
vlc qbittorrent vim gparted thunderbird nautilus \
nemo gnome-font-viewer gdebi gnome-tweaks evince > /dev/null 2>&1

# programas de Edição.
clear ; echo "Instalando programas de imagem e som..." ; sleep 4
apt install -y \
gimp inkscape audacity shotcut obs-studio > /dev/null 2>&1

# Colocando idioma em português dos aplicativos.
clear ; echo "Instalando idioma em português dos aplicativos..."
echo "Libre Office, ThunderBird e Firefox." ; sleep 4
apt install -y \
libreoffice-l10n-pt-br \
thunderbird-l10n-pt-br \
firefox-esr-l10n-pt-br > /dev/null 2>&1

# programas de Jogos
clear ; echo "Instalando programas de Jogos." ; sleep 4
apt install -y steam && apt install -y lutris

clear ; echo "Fim da execução do script."
