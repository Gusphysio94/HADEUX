# HADEUX — mise en ligne (accès à deux, synchronisé)

App de budget de foyer. Un seul fichier : `index.html`.
En **local**, elle marche telle quelle (double-clic). Pour l'**accès à deux depuis n'importe quel appareil** avec données synchronisées, suivre les étapes ci-dessous (~15 min).

Stack : **Vercel** (hébergement statique) + **Supabase** (données + connexion par mot de passe partagé).

---

## 1) Supabase — créer la base

1. Sur [supabase.com](https://supabase.com) → **New project** (note le mot de passe de la base, garde-le de côté).
2. Menu **SQL Editor** → **New query** → colle le contenu de `supabase.sql` → **Run**.
3. Menu **Authentication → Users → Add user** :
   - crée **un utilisateur partagé** (ex. `foyer@tonmail.be` + un mot de passe solide) ;
   - coche **Auto Confirm User** (pas de mail de confirmation à valider).
   - > C'est ce couple email + mot de passe que Gus **et** Ju taperont pour se connecter.
4. (Recommandé) **Authentication → Providers → Email** → désactive **"Allow new users to sign up"** pour que personne d'autre ne puisse créer de compte.
5. Menu **Project Settings → API** → copie :
   - **Project URL** (ex. `https://abcd1234.supabase.co`)
   - **anon public** key (longue chaîne, publique — normal)

## 2) Renseigner les clés dans l'app

Ouvre `index.html`, tout en haut du `<script>`, remplis :

```js
const CLOUD = {
  url:     'https://TON-PROJET.supabase.co',
  anonKey: 'TA_CLE_ANON_PUBLIC',
  table:   'hadeux',
  rowId:   'shared'
};
```

(Si tu laisses `url` vide, l'app reste 100 % locale.)

## 3) GitHub + Vercel — déployer

1. Crée un repo GitHub et pousse `index.html` (à la racine).
2. Sur [vercel.com](https://vercel.com) → **Add New → Project** → importe ce repo.
   - Framework Preset : **Other** — pas de build, pas de commande. Deploy.
3. Vercel te donne une URL (ex. `https://hadeux.vercel.app`).
4. Dans Supabase → **Authentication → URL Configuration** → mets cette URL dans **Site URL**.

## 4) Première utilisation

- Ouvre l'URL sur **ton** appareil (celui qui a déjà tes données locales) → connecte-toi.
  → l'app **envoie tes données locales** vers le cloud (première synchro).
- Ouvre la même URL sur le **téléphone de Ju** → même email/mot de passe → elle voit les mêmes données.
- Tout changement d'un côté apparaît chez l'autre en quelques secondes (pastille de synchro en haut : 🟢 synchronisé).

> 💡 Astuce : « Ajouter à l'écran d'accueil » depuis le navigateur du téléphone → HADEUX se lance comme une appli.

---

## Notes
- **Sauvegarde** : bouton *Exporter* (Réglages) télécharge un `.json` de secours à tout moment.
- **Sécurité** : les données ne sont lisibles qu'après connexion (RLS Supabase). Utilise un mot de passe solide.
- **Hors-ligne** : si le réseau saute, l'app continue en local et resynchronise au retour.
- **Conflits** : en cas d'édition simultanée des deux côtés, la dernière écriture gagne (rare pour un couple).
