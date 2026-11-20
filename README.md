# Speed Dépannage — Énergie & Maintenance

Site vitrine (HTML/CSS/JS, sans build) : location, vente, coffrets sur mesure, forfaits de maintenance, pièces détachées, avec un espace d'administration caché.

## Structure

```
index.html                  Le site complet
config.js                   URL + clé publique Supabase
.nojekyll                   Désactive Jekyll sur GitHub Pages
supabase/schema.sql         Tables, bucket d'images, règles de lecture
supabase/seed.sql           Contenu initial du site
supabase/open_access.sql    Autorise l'écriture sans identification (temporaire)
supabase/make_admin.sql     (optionnel, pour une future version sécurisée)
```

## Accès à l'administration

Cliquez **7 fois de suite sur le logo** (moins de 2,5 s entre deux clics). Aucun lien visible, aucun code, aucun email.

- Onglets : Forfaits, Location, Vente, Pièces, Slides Accueil, Images SpeedConnect.
- Chaque modification est enregistrée automatiquement ; ajout, duplication, déplacement et suppression sont disponibles.

## Deux modes de fonctionnement

**Mode local (par défaut)** : tant que `config.js` ne contient pas de vraie clé, les modifications sont enregistrées dans le navigateur de la personne qui les fait. Pratique pour tester, mais les visiteurs ne les voient pas.

**Mode Supabase (modifications visibles par tous)** :
1. Supabase > SQL Editor : exécutez `schema.sql`, puis `seed.sql`, puis `open_access.sql`.
2. Renseignez l'URL et la clé `anon` dans `config.js` (Project Settings > API).

> ⚠️ Avec `open_access.sql`, n'importe qui peut modifier le contenu en connaissant l'adresse Supabase et la clé publique (visibles dans `config.js`). La sécurité n'est pas assurée tant que ce script est actif : les instructions pour revenir en arrière sont à la fin du fichier. Ne publiez jamais la clé `service_role`.

Les messages du formulaire de contact sont enregistrés dans la table `sd_contacts` : lisez-les dans Supabase > Table Editor.

## Publication sur GitHub Pages

1. Envoyez ces fichiers dans un dépôt.
2. Settings > Pages : *Deploy from a branch*, branche `main`, dossier `/ (root)`.
3. Test en local : `python3 -m http.server 8000`, puis http://localhost:8000.
