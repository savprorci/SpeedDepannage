# Speed Dépannage — Énergie & Maintenance

Site vitrine (HTML/CSS/JS, sans build) pour Speed Dépannage, Côte d'Ivoire : location, vente, coffrets sur mesure, forfaits de maintenance, pièces détachées, avec un espace d'administration.

Les contenus (slides, forfaits, location, vente, pièces, images) sont stockés dans **Supabase** et modifiables depuis la page *Administration* du site. Les visiteurs voient les modifications immédiatement.

## Structure

```
index.html              Le site complet
config.js               URL + clé publique Supabase
.nojekyll               Désactive Jekyll sur GitHub Pages
supabase/schema.sql     Tables, règles de sécurité (RLS), bucket d'images
supabase/seed.sql       Contenu initial du site
supabase/make_admin.sql Donne les droits admin à un compte
```

## Mise en place de Supabase (une seule fois)

1. Dans Supabase, ouvrez **SQL Editor** et exécutez, dans cet ordre :
   1. `supabase/schema.sql`
   2. `supabase/seed.sql`
2. **Authentication → Users → Add user** : créez le compte administrateur (e-mail + mot de passe long, « Auto Confirm User » coché).
3. Exécutez `supabase/make_admin.sql` après avoir remplacé `VOTRE_EMAIL_ADMIN` par cet e-mail.
4. **Authentication → Sign In / Providers** : désactivez *Allow new users to sign up* (seul l'admin créé à la main peut se connecter).
5. **Project Settings → API** : copiez l'URL et la clé `anon` (publique) dans `config.js`.

> La clé `anon` est faite pour être publique : la sécurité repose sur les règles RLS de `schema.sql`. Ne publiez **jamais** la clé `service_role`.

## Publication sur GitHub Pages

1. Créez un dépôt et envoyez-y ces fichiers (`index.html`, `config.js`, `.nojekyll`, `.gitignore`, `README.md`, dossier `supabase/`).
2. **Settings → Pages** : *Deploy from a branch*, branche `main`, dossier `/ (root)`.
3. Le site est en ligne à `https://<compte>.github.io/<depot>/`.

Test en local : `python3 -m http.server 8000` puis http://localhost:8000.

## Utiliser l'administration

Accès caché : cliquez **7 fois de suite sur le logo** (en moins de 2,5 s entre deux clics), puis connectez-vous avec le compte admin. Il n'y a aucun lien visible vers l'administration.

Si `ADMIN_EMAIL` est renseigné dans `config.js`, seul le code (mot de passe) est demandé.

- Chaque champ modifié est enregistré automatiquement.
- Les images sont réduites (1200 px max) puis envoyées dans le bucket `sd-images`.
- Onglets : Forfaits, Location, Vente, Pièces (ajout / suppression), Slides Accueil, Images SpeedConnect, Messages (formulaire de contact).

## Tester en local avec le code 2208

Avant de brancher Supabase, `config.local.js` active un **mode test** : 7 clics sur le logo, puis le code `2208` (sans email).

- Les modifications (articles, images, messages) sont enregistrées dans le navigateur uniquement.
- Le mode ne fonctionne que depuis un fichier ouvert directement ou `http://localhost`, et seulement si la clé Supabase n'est pas renseignée.
- `config.local.js` est dans `.gitignore` : ne l'envoyez pas sur GitHub (supprimez-le avant le déploiement).

## Sans Supabase configuré

Si `config.js` garde ses valeurs `VOTRE_…`, le site s'affiche avec les données par défaut intégrées à `index.html`. L'administration et le formulaire de contact sont alors désactivés.

## Sécurité — à retenir

- Aucun mot de passe n'est stocké dans le code : l'authentification passe par Supabase Auth.
- Les droits d'écriture dépendent de la table `sd_admins`, modifiable uniquement depuis le SQL Editor.
- Le formulaire de contact accepte des messages anonymes (limités en taille, avec un champ anti-spam). Pour un trafic important, ajoutez un captcha (Cloudflare Turnstile).
