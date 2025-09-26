# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-26

### Ajouté
- 🎉 Version initiale de SwipeWipe
- 📱 Écran d'accueil avec indicateur d'espace disque
- 👆 Système de tri par swipe (4 directions)
- 📚 Gestion de 3 albums personnalisables
- 🎨 Thèmes sombre et clair avec couleur d'accent #32F094
- 🌍 Support de 6 langues (FR, EN, UK, DE, CN, FI)
- ✨ Animations fluides et effets visuels
- 🔐 Gestion intelligente des permissions photos
- 📸 Détection automatique des photos similaires
- 🗂️ Mode mosaïque pour tri multiple
- 🎯 Navigation par flèches (pas de bottom nav)
- 📱 Design responsive et accessible
- 🚀 Architecture modulaire Flutter

### Fonctionnalités principales
- **Tri par swipe** : Droite (supprimer), Gauche (garder), Haut (restaurer), Bas (albums)
- **Albums personnalisés** : Renommage, visualisation, ajout par swipe
- **Interface moderne** : Minimaliste avec effets de glow et dégradés
- **Accessibilité** : Support lecteurs d'écran, contraste WCAG AA
- **Performance** : Lazy loading, cache optimisé, animations 60fps

### Technique
- Flutter SDK 3.0.0+
- Architecture features/core/shared
- Gestion d'état avec Provider
- Internationalisation avec ARB
- Permissions avec permission_handler
- Accès photos avec photo_manager

[1.0.0]: https://github.com/qsfesvqsvrqs/swipewipe6/releases/tag/v1.0.0