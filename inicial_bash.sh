#!/bin/bash

# Atualiza o sistema operacional #
# Instalação de programas iniciais #

# Verifica se o usuário é root.
USUARIO=$(whoami)
if [ $USUARIO = "root" ];then
    clear ; echo "Bem vindo root!" ; echo 
else
    echo "Somente root!"
    echo "Tente \"sudo -i\" ou \"sudo $0\""
    exit 10
fi

# Verifica o gerenciador de pacotes.
if [ -f /usr/bin/rpm ]; then
    Pacote="yum"
elif [ -f /usr/bin/dpkg ]; then
    Pacote="apt"
else
    echo "Gerenciador de pacotes não encontrado!" ; exit 1
fi

[ -f /var/log/instalador.log ] || \
    sudo echo "    Data e Hora     | Pacote | Situação" \
    > /var/log/instalador.log

#Lista de programas.
Gedit=("gedit" "gedis" "gedit-plugin-text-size")
Windows=("wine" "q4wine")
Navegadores=("falkon")
Utilitarios=("vlc" "qbittorrent" "vim" "gparted" "thunderbird" "nautilus" \
             "nemo" "gnome-font-viewer" "gnome-tweaks" "gdebi" "evince" \
             "libreoffice")
Edicao=("gimp" "inkscape" "audacity" "shotcut" "obs-studio")
Idiomas=("libreoffice-l10n-pt-br" \
         "thunderbird-l10n-pt-br" \
         "firefox-esr-l10n-pt-br")

insta_programas () {
    Vetor=("$@")
    for p in ${Vetor[@]}; do
        sudo $Pacote install -y $p
        Status=$? ; Data=$(date "+%d-%m-%Y %H:%M:%S")
        if [ $Status = 0 ]; then
            echo "$Data | $p | Instalado" >> /var/log/instalador.log
        elif [ $Status = 1 ]; then
            echo "$Data | $p | Erro" >> /var/log/instalador.log
        fi
    done
}

insta_programas ${Gedit[@]}
insta_programas ${Windows[@]}
insta_programas ${Navegadores[@]}
insta_programas ${Utilitarios[@]}
insta_programas ${Edicao[@]}
insta_programas ${Idiomas[*]}
