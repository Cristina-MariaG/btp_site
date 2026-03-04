# Pro Renovation - Site Web

Site web vitrine pour Pro Renovation, entreprise de rénovation BTP spécialisée dans les travaux intérieurs et extérieurs.

## 🚀 Technologies

- **Vue 3** avec Composition API
- **TypeScript** pour le typage
- **Tailwind CSS** pour le styling
- **Vue Router** pour la navigation
- **Vite** comme bundler

## 📦 Installation

```bash
# Installer les dépendances
npm install

# Lancer le serveur de développement
npm run dev

# Build pour la production
npm run build

# Preview du build
npm run preview
```
# Docker


docker compose up 
docker compose up --build

docker compose down 

docker-compose -f docker-compose.prod.yml up --build 

## 🎨 Structure du projet

```
src/
├── assets/          # Styles globaux
├── components/      # Composants réutilisables
│   ├── Header.vue   # Header sticky
│   └── Footer.vue   # Footer amélioré
├── views/           # Pages
│   ├── Home.vue     # Page d'accueil
│   ├── Contact.vue  # Page contact avec formulaire
│   ├── Devis.vue    # Page devis (formulaire progressif)
│   ├── Services.vue # Page services détaillée
│   ├── Realisations.vue # Portfolio/réalisations
│   └── About.vue    # À propos
├── router/          # Configuration Vue Router
├── App.vue          # Composant principal
└── main.ts          # Point d'entrée
```

## 🎯 Fonctionnalités

### Pages
- ✅ **Accueil** - Hero, services, réalisations, témoignages
- ✅ **Contact** - 3 options de contact + formulaire
- ✅ **Devis** - Formulaire progressif en 3 étapes
- ✅ **Services** - Détails des prestations (Cuisine, Salle de bain, Aménagement)
- ✅ **Réalisations** - Portfolio avec filtres et modal
- ✅ **À propos** - Histoire, valeurs, expertise

### Composants
- ✅ **Header sticky** - Visible au scroll sur toutes les pages
- ✅ **Footer** - Amélioré avec liens, contact, réseaux sociaux
- ✅ **Composants réutilisables** - Cards, buttons, forms

### Design
- ✅ **Responsive** - Mobile, tablet, desktop
- ✅ **Variables de couleurs** - Jaune (primary-500: #eab308)
- ✅ **Animations** - Transitions fluides, hover effects
- ✅ **Typography** - Playfair Display (titres) + Inter (texte)

## 🎨 Palette de couleurs

Les couleurs sont définies dans `tailwind.config.js` :

```javascript
primary: {
  500: '#eab308', // Jaune principal
  600: '#ca8a04',
  // ...
}
```

Utilisation dans les composants :
```vue
<div class="bg-primary-500 text-black">...</div>
```

## 📝 Personnalisation

### Modifier les couleurs
Éditez `tailwind.config.js` dans la section `theme.extend.colors`

### Modifier les polices
Éditez `tailwind.config.js` dans la section `theme.extend.fontFamily`

### Ajouter une page
1. Créer le fichier dans `src/views/`
2. Ajouter la route dans `src/router/index.ts`
3. Ajouter le lien dans le Header

## 🚀 Déploiement

### AWS (recommandé)
```bash
npm run build
# Upload le dossier dist/ vers S3 + CloudFront
```

Pour toute question : arcusi_cristina@yahoo.com
