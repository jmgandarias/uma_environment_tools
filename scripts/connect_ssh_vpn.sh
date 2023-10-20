#!/bin/bash

# questo script apre una connessione SSH verso un server remoto

# chiede all'utente di inserire l'indirizzo IP o il nome del server
echo "Insert the IP or the name of the remote server: "
read server

# chiede all'utente di inserire il nome dell'utente
echo "Insert the remote username: "
read remoteuser
# esegue la connessione SSH
ssh -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15 -X $remoteuser@$server
