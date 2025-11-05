#!/bin/bash

# Script para generar iconos y splash screen
# Ejecuta: bash setup_logo.sh

echo ""
echo "========================================"
echo " Configuración de Logo y Splash Screen"
echo "========================================"
echo ""

# Verificar si existen las imágenes
if [ -f "assets/images/icon.png" ]; then
    echo "✓ icon.png encontrado"
else
    echo "⚠ icon.png NO encontrado"
    echo ""
    echo "Para crear el logo:"
    echo "1. Abre Canva.com o usa el archivo SVG de plantilla"
    echo "2. Crea una imagen de 1024x1024 px"
    echo "3. Guárdala como: assets/images/icon.png"
    echo ""
    echo "Plantilla disponible: assets/images/icon_template.svg"
    echo ""
    exit 1
fi

if [ -f "assets/images/splash.png" ]; then
    echo "✓ splash.png encontrado"
else
    echo "⚠ splash.png NO encontrado"
    echo ""
    echo "Para crear el splash:"
    echo "1. Abre Canva.com o usa el archivo SVG de plantilla"
    echo "2. Crea una imagen de 512x512 px"
    echo "3. Guárdala como: assets/images/splash.png"
    echo ""
    echo "Plantilla disponible: assets/images/splash_template.svg"
    echo ""
    exit 1
fi

echo ""
echo "Imágenes encontradas! Generando iconos..."
echo ""

# Paso 1: Generar iconos de la app
echo "[1/3] Generando iconos de la app..."
flutter pub run flutter_launcher_icons
if [ $? -ne 0 ]; then
    echo "✗ Error al generar iconos"
    exit 1
fi
echo "✓ Iconos generados"

echo ""
echo "[2/3] Generando splash screen..."
flutter pub run flutter_native_splash:create
if [ $? -ne 0 ]; then
    echo "✗ Error al generar splash screen"
    exit 1
fi
echo "✓ Splash screen generado"

echo ""
echo "[3/3] Limpiando proyecto..."
flutter clean
flutter pub get
echo "✓ Proyecto limpio y actualizado"

echo ""
echo "========================================"
echo " ¡COMPLETADO!"
echo "========================================"
echo ""
echo "Tu app ahora tiene:"
echo " ✓ Icono personalizado"
echo " ✓ Splash screen con logo"
echo " ✓ Soporte Android adaptativo"
echo ""
echo "Ejecuta: flutter run"
echo ""
