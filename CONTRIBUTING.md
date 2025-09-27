# Guide de Contribution - SwipeWipe6

Merci de votre intérêt pour contribuer à SwipeWipe6 ! Ce guide vous aidera à comprendre comment participer efficacement au développement du projet.

## 🤝 Comment Contribuer

### Types de Contributions

Nous accueillons tous types de contributions :

- 🐛 **Corrections de bugs** : Signalement et correction d'erreurs
- ✨ **Nouvelles fonctionnalités** : Ajout de nouvelles capacités
- 📚 **Documentation** : Amélioration de la documentation
- 🎨 **Design/UI** : Améliorations de l'interface utilisateur
- 🧪 **Tests** : Ajout ou amélioration des tests
- 🌍 **Traductions** : Ajout de nouvelles langues
- ♿ **Accessibilité** : Améliorations d'accessibilité
- 🚀 **Performance** : Optimisations de performance

## 🚀 Démarrage Rapide

### 1. Fork et Clone

```bash
# Fork le repository sur GitHub, puis :
git clone https://github.com/VOTRE_USERNAME/swipewipe6.git
cd swipewipe6
```

### 2. Configuration de l'Environnement

```bash
# Installer les dépendances
flutter pub get

# Vérifier que tout fonctionne
flutter doctor
flutter analyze
flutter test
```

### 3. Créer une Branche

```bash
# Créer une branche pour votre contribution
git checkout -b feature/ma-nouvelle-fonctionnalite
# ou
git checkout -b fix/correction-bug-important
```

## 📋 Standards de Code

### Conventions de Nommage

```dart
// Classes : PascalCase
class ThemeProvider extends ChangeNotifier {}

// Variables et fonctions : camelCase
bool isDarkMode = false;
void toggleTheme() {}

// Constantes : camelCase avec const
static const Color primaryColor = Color(0xFF32F094);

// Fichiers : snake_case
theme_provider.dart
animated_button.dart
```

### Structure des Fichiers

```dart
// 1. Imports Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 2. Imports de packages tiers
import 'package:provider/provider.dart';

// 3. Imports locaux - Core
import '../../../../core/services/haptic_service.dart';

// 4. Imports locaux - Shared
import '../../../../shared/widgets/animated_button.dart';

// 5. Imports locaux - Features
import '../../../home/presentation/widgets/navigation_arrows.dart';

class MonWidget extends StatelessWidget {
  // Constructeur
  const MonWidget({super.key});
  
  // Méthodes publiques
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // Méthodes privées
  void _maMethodePrivee() {}
}
```

### Documentation du Code

```dart
/// Service de gestion du feedback utilisateur.
/// 
/// Centralise tous les types de feedback (haptique, visuel, audio)
/// pour une expérience utilisateur cohérente.
class FeedbackService {
  /// Déclenche un feedback léger pour les interactions simples.
  /// 
  /// Utilisé pour les taps sur boutons, navigation, etc.
  static Future<void> onTap() async {
    await HapticService.lightImpact();
  }
  
  /// Déclenche un feedback de succès.
  /// 
  /// [message] - Message optionnel à afficher
  static Future<void> onSuccess([String? message]) async {
    // Implementation
  }
}
```

## 🧪 Tests

### Écriture des Tests

Chaque contribution doit inclure des tests appropriés :

```dart
// test/widgets/animated_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipewipe6/shared/widgets/animated_button.dart';

void main() {
  group('AnimatedButton', () {
    testWidgets('should display text correctly', (tester) async {
      // Arrange
      const buttonText = 'Test Button';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      bool wasPressed = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Test',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(AnimatedButton));
      
      // Assert
      expect(wasPressed, true);
    });
  });
}
```

### Couverture de Tests

- **Minimum requis** : 80% de couverture
- **Tests unitaires** : Logique métier, providers, services
- **Tests de widgets** : Composants UI
- **Tests d'intégration** : Flux utilisateur complets

```bash
# Lancer les tests avec couverture
flutter test --coverage

# Générer le rapport HTML
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## ♿ Accessibilité

### Checklist d'Accessibilité

Chaque widget doit respecter ces critères :

- [ ] **Labels sémantiques** : Tous les éléments interactifs ont des labels
- [ ] **Hints appropriés** : Instructions claires pour les actions
- [ ] **Contraste suffisant** : Ratio de contraste ≥ 4.5:1
- [ ] **Taille des cibles** : Minimum 44x44 points
- [ ] **Navigation clavier** : Accessible au clavier/switch control
- [ ] **Lecteurs d'écran** : Testé avec TalkBack/VoiceOver

```dart
// Exemple d'implémentation accessible
Semantics(
  label: 'Basculer entre thème clair et sombre',
  hint: 'Appuyez pour changer le thème de l\'application',
  button: true,
  enabled: true,
  child: GestureDetector(
    onTap: () {
      // Action
    },
    child: Container(
      width: 44, // Taille minimum
      height: 44,
      child: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: Colors.white, // Contraste suffisant
      ),
    ),
  ),
)
```

## 🎨 Design System

### Couleurs

```dart
// Palette principale
static const Color primaryColor = Color(0xFF32F094);      // Vert néon
static const Color darkBackground = Color(0xFF191E21);     // Fond sombre
static const Color lightBackground = Color(0xFFE8E6E6);    // Fond clair
static const Color darkText = Color(0xFFE8E6E6);          // Texte sur fond sombre
static const Color lightText = Color(0xFF191E21);         // Texte sur fond clair

// Couleurs sémantiques
static const Color successColor = Color(0xFF4CAF50);
static const Color warningColor = Color(0xFFFF9800);
static const Color errorColor = Color(0xFFF44336);
```

### Espacements

```dart
// Système d'espacement basé sur 8px
class Spacing {
  static const double xs = 4.0;   // 0.5 unité
  static const double sm = 8.0;   // 1 unité
  static const double md = 16.0;  // 2 unités
  static const double lg = 24.0;  // 3 unités
  static const double xl = 32.0;  // 4 unités
  static const double xxl = 48.0; // 6 unités
}
```

### Typographie

```dart
// Utilisation des styles de thème
Text(
  'Titre Principal',
  style: Theme.of(context).textTheme.headlineLarge,
)

Text(
  'Sous-titre',
  style: Theme.of(context).textTheme.headlineMedium,
)

Text(
  'Corps de texte',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

## 🌍 Internationalisation

### Ajouter une Nouvelle Langue

1. **Créer le fichier de traduction**
```bash
# Exemple pour l'espagnol
touch l10n/app_es.arb
```

2. **Ajouter les traductions**
```json
{
  "@@locale": "es",
  "appTitle": "SwipeWipe",
  "homeTitle": "Inicio",
  "startSorting": "Comenzar clasificación",
  "albums": "Álbumes",
  "swipeScreen": "Pantalla de deslizamiento"
}
```

3. **Mettre à jour la configuration**
```yaml
# l10n.yaml
arb-dir: l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
supported-locales:
  - en
  - fr
  - es  # Nouvelle langue
```

4. **Générer les fichiers**
```bash
flutter gen-l10n
```

## 🐛 Signalement de Bugs

### Template d'Issue

```markdown
## 🐛 Description du Bug
Description claire et concise du problème.

## 🔄 Étapes pour Reproduire
1. Aller à '...'
2. Cliquer sur '...'
3. Faire défiler vers '...'
4. Voir l'erreur

## ✅ Comportement Attendu
Description de ce qui devrait se passer.

## 📱 Environnement
- OS: [iOS/Android]
- Version: [ex. iOS 16.0]
- Appareil: [ex. iPhone 14]
- Version de l'app: [ex. 1.0.0]

## 📸 Captures d'Écran
Si applicable, ajoutez des captures d'écran.

## 📋 Informations Supplémentaires
Tout autre contexte utile.
```

## ✨ Proposer une Fonctionnalité

### Template de Feature Request

```markdown
## 🚀 Fonctionnalité Proposée
Description claire de la fonctionnalité souhaitée.

## 💡 Motivation
Pourquoi cette fonctionnalité serait-elle utile ?

## 📋 Solution Proposée
Description détaillée de l'implémentation suggérée.

## 🎨 Maquettes/Wireframes
Si applicable, ajoutez des maquettes visuelles.

## 🔄 Alternatives Considérées
Autres solutions envisagées.
```

## 📝 Process de Review

### Checklist avant Soumission

- [ ] **Code** : Respecte les conventions de style
- [ ] **Tests** : Couverture suffisante et tests passants
- [ ] **Documentation** : Code documenté et README mis à jour si nécessaire
- [ ] **Accessibilité** : Standards respectés
- [ ] **Performance** : Pas de régression de performance
- [ ] **Responsive** : Fonctionne sur toutes les tailles d'écran
- [ ] **Commits** : Messages de commit clairs et descriptifs

### Messages de Commit

Utilisez le format [Conventional Commits](https://www.conventionalcommits.org/) :

```bash
# Nouvelles fonctionnalités
feat: add responsive design system

# Corrections de bugs
fix: resolve theme toggle animation issue

# Documentation
docs: update contributing guidelines

# Refactoring
refactor: extract feedback service from haptic service

# Tests
test: add unit tests for theme provider

# Performance
perf: optimize animation performance

# Style/Formatting
style: fix linting issues in animated_button.dart
```

### Process de Review

1. **Soumission** : Créer une Pull Request avec description détaillée
2. **CI/CD** : Vérification automatique (tests, linting, build)
3. **Review** : Examen par les mainteneurs
4. **Feedback** : Corrections demandées si nécessaire
5. **Approbation** : Validation finale
6. **Merge** : Intégration dans la branche principale

## 🏆 Reconnaissance

### Hall of Fame

Les contributeurs sont reconnus dans :
- README principal
- Page de crédits dans l'application
- Releases notes
- Réseaux sociaux du projet

### Types de Contributions Reconnues

- 💻 Code
- 📖 Documentation
- 🎨 Design
- 🐛 Bug reports
- 💡 Idées
- 🌍 Traductions
- 📢 Promotion
- 💬 Support communautaire

## 📞 Support

### Canaux de Communication

- **Issues GitHub** : Bugs et feature requests
- **Discussions GitHub** : Questions générales
- **Discord** : Chat en temps réel (lien à venir)
- **Email** : contact@swipewipe6.com

### Temps de Réponse

- **Issues critiques** : 24-48h
- **Pull Requests** : 3-5 jours ouvrés
- **Questions générales** : 1 semaine

## 📄 Licence

En contribuant à SwipeWipe6, vous acceptez que vos contributions soient sous licence MIT, la même que le projet principal.

---

Merci de contribuer à SwipeWipe6 ! Ensemble, créons une application de tri de photos exceptionnelle. 🚀✨