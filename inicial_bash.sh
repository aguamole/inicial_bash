#!/bin/bash

## Descrição
# Instalação de programas iniciais.
# Criador : LUCIANO PEREIRA DE SOUZA
# REVISOR : LUCIANO PEREIRA DE SOUZA
# OBS : Esse programa instala vários programas de uma vez, através de vetores.

## GitHub
# https://github.com/lucianohanzo/inicial_bash

## versão: 1.00

## Funções
# Verifica se tem internet.
internet () {
    ping "$1" -c2 > /dev/null 2>&1 || return 100
}

# Limpador de log.
# Deixa o arquivo de log com máximo 1000 linhas.
limpa_logs () {
    local linhas

    [ -f "${ARQUIVO_LOG}" ] && \
    linhas=$(wc -l "${ARQUIVO_LOG}" | cut -d" " -f1) && \
    while [ "$linhas" -gt '1000' ]; do
        sed -i "2d" "${ARQUIVO_LOG}" > /dev/null
        linhas=$(wc -l "${ARQUIVO_LOG}" | cut -d" " -f1)
    done
}

# Função Principal
insta_programas () {
    local vetor
    local status
    local data
    local programas

    vetor=("$@")
    for programas in "${vetor[@]}"; do
        echo "Instalando : ${programas}"
        internet www.google.com
        if [ "$?" = 100 ]; then
            echo -e "\nPacote ${programas} não foi instalado."
            echo ">>> Sem acesso a internet ou sem DNS configurado. <<<"
            limpa_logs
            exit 2
        fi
        "${PACOTE}" install -y "${programas}" > /dev/null 2>&1
        status="$?" ; data=$(date "+%d-%m-%Y %H:%M:%S")
        if [ "${status}" = '0' ]; then
            echo "${data} | Instalado | > ${programas}" >> "${ARQUIVO_LOG}"
        else
            echo "${data} | Erro      | > ${programas}" >> "${ARQUIVO_LOG}"
        fi
    done
}

mostra_log () {
    echo -e "\n\nFinal do arquivo de log em ${ARQUIVO_LOG}"
    tail -n 100 "${ARQUIVO_LOG}"
}

instalar_navegador(){
if [[ "${NAVEGADOR_ESCOLHIDO}" != '2' ]]; then
    insta_programas "${NAVEGADORES[0]}"
else
    if [[ "${FLATPAK}" == '1' ]]; then
        flatpak install "${NAVEGADORES[1]}"
    else
        echo "Não foi encontrado Flatpak, será instalado o ${NAVEGADORES[0]}"
        insta_programas "${NAVEGADORES[0]}"
    fi
fi
}

#=============================================================================#

# Verifica se o usuário é root.
USUARIO="$(whoami)"
if [ "${USUARIO}" = 'root' ];then
    echo "Bem vindo root!" ; echo
else
    echo "Somente root!"
    echo "Tente \"sudo -i\" ou \"sudo $0\""
    exit 1
fi

# Verifica o gerenciador de pacotes.
if [[ "$(command -v rpm)" ]]; then
    PACOTE="yum"
elif [[ "$(command -v apt-get)" ]]; then
    PACOTE="apt-get"
elif [[ "$(command -v flatpak)" ]]; then
    FLATPAK='1'   # 1 é habilitado
else
    echo "Gerenciador de pacotes não encontrado!" ; exit 1
fi

# Cria o arquivo de log caso não exista.
ARQUIVO_LOG='/var/log/instalador.log'
[ -f "${ARQUIVO_LOG}" ] || \
    echo ">   Data e Hora    <| Situação  | > Pacote" \
    > "${ARQUIVO_LOG}"

read -r -p 'Qual navegador deseja?
1 - Falkon
2 - Firefox
Digite o numero: ' NAVEGADOR_ESCOLHIDO

# Lista de programas.
# Os programas aqui estão armazenados em vetores.
GEDIT=("gedit" "gedit-plugins" "gedit-plugin-text-size")
WINDOWS=("wine" "q4wine")
NAVEGADORES=( 'falkon' 'flathub org.mozilla.firefox' )
UTILITARIOS=("vlc" "qbittorrent" "vim" "gparted" "thunderbird" "nautilus" \
             "nemo" "gnome-font-viewer" "gnome-tweaks" "gdebi" "evince" \
             "libreoffice")
EDICAO=("gimp" "inkscape" "audacity" "shotcut" "obs-studio")
IDIOMAS=("libreoffice-l10n-pt-br" \
         "thunderbird-l10n-pt-br" \
         "firefox-esr-l10n-pt-br")

if [[ "${PACOTE}" == 'apt-get' ]]; then
    dpkg --configure -a
    "${PACOTE}" install -f
fi

# Chamada de funções
instalar_navegador
insta_programas "${GEDIT[@]}"
insta_programas "${WINDOWS[@]}"
insta_programas "${UTILITARIOS[@]}"
insta_programas "${EDICAO[@]}"
insta_programas "${IDIOMAS[*]}"

limpa_logs
mostra_log
