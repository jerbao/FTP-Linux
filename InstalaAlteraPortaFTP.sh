#!/bin/bash

# Verificar se o vsftpd está instalado
if ! command -v vsftpd &> /dev/null; then
    echo "O vsftpd não está instalado."
    read -p "Deseja instalar o vsftpd agora? (s/n): " INSTALAR_VSFTPD

    if [[ "$INSTALAR_VSFTPD" =~ ^[Ss]$ ]]; then
        sudo apt update
        sudo apt install vsftpd
    else
        echo "Foi escolhido não instalar o vsftpd. Script finalizado."
        exit 1
    fi
fi

# Perguntar se deseja alterar a porta do FTP
read -p "Deseja alterar a porta padrão do servidor FTP? (s/n): " ALTERAR_PORTA

if [[ "$ALTERAR_PORTA" =~ ^[Ss]$ ]]; then
    # Parar o vsftpd
    sudo systemctl stop vsftpd

    # Solicitar a nova porta desejada
    read -p "Insira a nova porta para o servidor FTP: " NOVA_PORTA

    # Atualizar o arquivo de configuração
    sudo sed -i "s/^listen_port=.*/listen_port=$NOVA_PORTA/" /etc/vsftpd.conf

    # Iniciar o vsftpd novamente para aplicar as mudanças
    sudo systemctl start vsftpd

    echo "A porta do servidor FTP foi alterada para $NOVA_PORTA"
else
    echo "Nenhuma alteração foi feita na porta do servidor FTP."
fi
