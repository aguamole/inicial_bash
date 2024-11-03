#!/bin/bash

# Instalação de programas iniciais.
# Criador : LUCIANO PEREIRA DE SOUZA
# REVISOR : LUCIANO PEREIRA DE SOUZA
# OBS : Esse programa instala vários programas de uma vez, através de vetores.

# Verifica se o usuário é root.
USUARIO=$(whoami)
if [ $USUARIO = "root" ];then
    echo "Bem vindo root!" ; echo 
else
    echo "Somente root!"
    echo "Tente \"sudo -i\" ou \"sudo $0\""
    exit 1
fi

# Verifica se tem internet.
internet () {
    ping $1 -c2 > /dev/null 2>&1
    if [ $? != 0 ]; then
        return 100
    fi
}

# Verifica o gerenciador de pacotes.
if [ -f /usr/bin/rpm ]; then
    Pacote="yum"
elif [ -f /usr/bin/dpkg ]; then
    Pacote="apt"
else
    echo "Gerenciador de pacotes não encontrado!" ; exit 1
fi

# Cria o arquivo de log caso não exista.
ArquivoLog=/var/log/instalador.log
[ -f $ArquivoLog ] || \
    sudo echo ">   Data e Hora    <| Situação  | > Pacote" \
    > $ArquivoLog

# Lista de programas.
# Os programas aqui estão armazenados em vetores.
Gedit=("gedit" "gedit-plugins" "gedit-plugin-text-size")
Windows=("wine" "q4wine")
Navegadores=("falkon")
Utilitarios=("vlc" "qbittorrent" "vim" "gparted" "thunderbird" "nautilus" \
             "nemo" "gnome-font-viewer" "gnome-tweaks" "gdebi" "evince" \
             "libreoffice")
Edicao=("gimp" "inkscape" "audacity" "shotcut" "obs-studio")
Idiomas=("libreoffice-l10n-pt-br" \
         "thunderbird-l10n-pt-br" \
         "firefox-esr-l10n-pt-br")

# Limpador de log.
# Deixa o arquivo de log com no máximo 1000 linhas.
limpa_logs () {
    [ -f $ArquivoLog ] && \
    Linhas=$(wc -l $ArquivoLog | cut -d" " -f1) && \
    while [ $Linhas -gt 1000 ]; do
        sed -i "2d" $ArquivoLog > /dev/null
        Linhas=$(wc -l $ArquivoLog | cut -d" " -f1)
    done
}

# Função Principal
insta_programas () {
    Vetor=("$@")
    for p in ${Vetor[@]}; do
        echo "Instalando : $p"
        internet www.google.com
        if [ $? = 100 ]; then
            echo -e "\nPacote $p não foi instalado."
            echo ">>> Sem acesso a internet ou sem DNS configurado. <<<"
            limpa_logs
            exit 2
        fi
        sudo $Pacote install -y $p > /dev/null 2>&1
        Status=$? ; Data=$(date "+%d-%m-%Y %H:%M:%S")
        if [ $Status = 0 ]; then
            echo "$Data | Instalado | > $p" >> $ArquivoLog
        else
            echo "$Data | Erro      | > $p" >> $ArquivoLog
        fi
    done
}

mostra_log () {
echo -e "\n\nFinal do arquivo de log em $ArquivoLog"
tail -n 100 $ArquivoLog
}

# Chamada de funções
insta_programas ${Gedit[@]}
insta_programas ${Windows[@]}
insta_programas ${Navegadores[@]}
insta_programas ${Utilitarios[@]}
insta_programas ${Edicao[@]}
insta_programas ${Idiomas[*]}

limpa_logs
mostra_log
