# 🖥️ Server Stats — Linux Server Performance Monitoring Script

Un script Bash simple, portable et professionnel permettant d’analyser rapidement l’état de santé d’un serveur Linux.

Ce projet est conçu comme **un premier projet DevOps / SysAdmin Linux**, mettant en pratique les bases du monitoring système, de l’automatisation et des bonnes pratiques Bash.

---

## 🎯 Objectifs du projet

Le script `server-stats.sh` fournit les statistiques essentielles pour évaluer les performances d’un serveur Linux :

* Utilisation totale du **CPU**
* Utilisation de la **mémoire** (utilisée vs libre, en pourcentage)
* Utilisation du **disque** (utilisé vs libre)
* Les **5 processus les plus gourmands en CPU**
* Les **5 processus les plus gourmands en mémoire**

### 🎁 Bonus (informations supplémentaires)

* Version du système d’exploitation
* Version du kernel
* Durée de fonctionnement (uptime)
* Load average
* Nombre d’utilisateurs connectés

---

## 🛠️ Technologies utilisées

* **Bash scripting**
* Commandes Linux standards :

  * `top`, `ps`, `free`, `df`, `uptime`, `who`, `uname`
  * `awk`, `grep`, `cut`

👉 Le script fonctionne sur la majorité des distributions Linux modernes.

---

## 📁 Structure du projet

```bash
server-stats/
│
├── server-stats.sh   # Script principal
├── README.md         # Documentation
└── LICENSE           # (optionnel)
```

---

## 🚀 Installation

Clone le dépôt ou copie simplement le script :

```bash
git clone https://github.com/devakowakou/server-stats.git
cd server-stats
```

Rends le script exécutable :

```bash
chmod +x server-stats.sh
```

---

## ▶️ Utilisation

Lance simplement le script :

```bash
./server-stats.sh
```

Aucune configuration n’est requise.

---

## 📊 Exemple de sortie

```text
==========================================
 SERVER PERFORMANCE STATISTICS
==========================================

CPU Usage:
 - Total CPU Used: 18%

Memory Usage:
 - Used: 3200MB / 8000MB (40%)
 - Free: 4800MB

Disk Usage:
 - Used: 22GB / 50GB (44%)

Top 5 CPU consuming processes:
 PID   COMMAND     %CPU
 1234  nginx       12.3
 ...

Additional System Info:
 - OS       : Ubuntu 22.04 LTS
 - Kernel   : 6.5.0
 - Uptime   : up 3 days, 4 hours
 - Load Avg : 0.23, 0.45, 0.60
 - Users    : 2
```

---

## 🧠 Bonnes pratiques appliquées

* Script structuré par **fonctions**
* Variables explicites
* Gestion des erreurs avec `set -euo pipefail`
* Sortie lisible avec couleurs
* Commandes standards (portabilité)

---

## 🔒 Sécurité

* Le script ne nécessite pas de privilèges `root`
* Aucune modification système
* Lecture seule des informations système

---

## 📌 Cas d’usage

* Diagnostic rapide d’un serveur
* Vérification avant déploiement
* Monitoring manuel
* Projet d’apprentissage DevOps
* Démonstration de compétences Linux en entretien

---

## 🔮 Améliorations possibles

* Ajout d’alertes (CPU / RAM / Disk)
* Sortie au format JSON
* Intégration avec `cron`
* Export des métriques vers Prometheus
* Mode silencieux / verbose

---

## 👤 Auteur

**Amour Akowakou**
Junior DevOps / Backend Developer

🔗 **Projet :** https://github.com/devakowakou/server-stats

---

## 📄 Licence

Ce projet est sous licence MIT. Libre à vous de l’utiliser, le modifier et le distribuer.
