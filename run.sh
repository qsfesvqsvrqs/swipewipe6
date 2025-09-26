#!/bin/bash

# SwipeWipe - Script de lancement
echo "🚀 SwipeWipe - Photo Sorting App"
echo "================================="

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    echo "📥 Téléchargement de Flutter..."
    
    # Télécharger Flutter si pas présent
    if [ ! -d "flutter" ]; then
        curl -o flutter_linux.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
        tar xf flutter_linux.tar.xz
        rm flutter_linux.tar.xz
    fi
    
    # Ajouter Flutter au PATH
    export PATH="$PATH:$(pwd)/flutter/bin"
fi

echo "✅ Flutter détecté"

# Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# Générer les fichiers de localisation
echo "🌍 Génération des fichiers de localisation..."
flutter gen-l10n

# Vérifier les appareils connectés
echo "📱 Vérification des appareils..."
flutter devices

echo ""
echo "🎯 Pour lancer l'application :"
echo "   flutter run"
echo ""
echo "🔧 Autres commandes utiles :"
echo "   flutter analyze    # Analyser le code"
echo "   flutter test       # Lancer les tests"
echo "   flutter doctor     # Vérifier l'installation"
echo ""
echo "📚 Documentation complète dans README.md"