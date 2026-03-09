# Bug : Caractères invisibles Windows (CRLF) dans les fichiers bash/env

## Contexte

Je travaille sur ce projet de site web pour une entreprise de rénovation BTP.
J'ai un nom de domaine `iamcristinadev.xyz` acheté sur **Unstoppable Domains** et je voulais
créer un sous-domaine `btp.iamcristinadev.xyz` pour ce projet sans acheter un nouveau domaine.

### Pourquoi Cloudflare ?

**Cloudflare** est un service qui gère le DNS de mon domaine — c'est lui qui fait le lien
entre un nom de domaine et une adresse IP. En pointant les nameservers de mon domaine
vers Cloudflare, c'est Cloudflare qui décide où pointe `iamcristinadev.xyz` et tous ses
sous-domaines. C'est gratuit et ça offre en plus :
- Protection DDoS
- SSL automatique
- CDN
- Gestion facile des sous-domaines via interface ou API

### Ce que je voulais faire

Créer automatiquement le sous-domaine `btp.iamcristinadev.xyz` pointant vers mon instance
EC2 AWS, via un script bash qui appelle l'**API Cloudflare** — sans passer par l'interface
graphique manuellement.

J'ai donc créé un fichier `.env` avec mes credentials Cloudflare :
```bash
CLOUDFLARE_TOKEN="mon_token_api"
ZONE_ID="mon_zone_id"
```

Et un script qui fait un appel curl à l'API Cloudflare pour créer l'enregistrement DNS.

---

## Ce que j'ai vécu

Je travaille sur Windows avec WSL. J'ai créé le fichier `.env` via VS Code et quand
j'ai essayé de l'utiliser dans mon script bash, j'ai eu ce comportement bizarre :

```bash
echo "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"
# Au lieu d'afficher l'URL complète, j'obtenais :
/dns_recordscloudflare.com/client/v4/zones/....
```

Le début de l'URL était mangé. J'ai aussi eu cette erreur sur mes scripts `.sh` :


## Pourquoi ça arrive

Windows utilise **CRLF** (`\r\n`) comme fin de ligne, Linux utilise **LF** (`\n`).

Quand je crée un fichier sur Windows (via VS Code) et que je l'exécute dans WSL,
les `\r` invisibles sont interprétés comme faisant partie de la valeur de mes variables.
Le `\r` fait revenir le curseur au début de la ligne — tout ce qui était avant
est écrasé, ce qui explique pourquoi le début de l'URL disparaissait.

---

## Comment j'ai réglé le problème

### Fix rapide — corriger un fichier existant

```bash
# Corriger le .env
sed -i 's/\r//' .env

# Corriger un script .sh
sed -i 's/\r//' script.sh
```

### Vérifier si un fichier est affecté

```bash
cat -A .env | head -5
# Si je vois des ^M en fin de ligne → présence de \r
# CLOUDFLARE_TOKEN="abc123"^M  ← problème
# CLOUDFLARE_TOKEN="abc123"    ← correct
```

### Fix permanent — forcer LF dans VS Code

En bas à droite de VS Code, je clique sur `CRLF` → je sélectionne `LF`.

Ou j'ajoute un `.editorconfig` à la racine du projet pour que ce soit automatique :

```ini
root = true

[*]
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

### Créer le .env directement depuis WSL

Pour éviter le problème dès le départ, je crée le `.env` directement dans le terminal Linux :

```bash
cat > .env << 'EOF'
CLOUDFLARE_TOKEN="mon_token"
ZONE_ID="mon_zone_id"
EOF
```

---

## Résumé

| | Windows | Linux/WSL |
|---|---|---|
| Fin de ligne | `\r\n` (CRLF) | `\n` (LF) |
| Crée le bug | ✅ oui | ❌ non |
| Fix rapide | `sed -i 's/\r//' fichier` | — |
| Fix permanent | `.editorconfig` ou VS Code → LF | — |

> ⚠️ Réflexe à avoir dès qu'un script se comporte bizarrement sous WSL :
> `sed -i 's/\r//' mon_fichier`