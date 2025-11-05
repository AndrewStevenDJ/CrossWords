@echo off
REM Script para generar iconos y splash screen
REM Ejecuta: setup_logo.bat

echo.
echo ========================================
echo  Configuracion de Logo y Splash Screen
echo ========================================
echo.

REM Verificar si existen las imagenes
if exist "assets\images\icon.png" (
    echo [OK] icon.png encontrado
) else (
    echo [AVISO] icon.png NO encontrado
    echo.
    echo Para crear el logo:
    echo 1. Abre Canva.com o usa el archivo SVG de plantilla
    echo 2. Crea una imagen de 1024x1024 px
    echo 3. Guardala como: assets\images\icon.png
    echo.
    echo Plantilla disponible: assets\images\icon_template.svg
    echo.
    pause
    exit /b 1
)

if exist "assets\images\splash.png" (
    echo [OK] splash.png encontrado
) else (
    echo [AVISO] splash.png NO encontrado
    echo.
    echo Para crear el splash:
    echo 1. Abre Canva.com o usa el archivo SVG de plantilla
    echo 2. Crea una imagen de 512x512 px
    echo 3. Guardala como: assets\images\splash.png
    echo.
    echo Plantilla disponible: assets\images\splash_template.svg
    echo.
    pause
    exit /b 1
)

echo.
echo Imagenes encontradas! Generando iconos...
echo.

REM Paso 1: Generar iconos de la app
echo [1/3] Generando iconos de la app...
call flutter pub run flutter_launcher_icons
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Fallo al generar iconos
    pause
    exit /b 1
)
echo [OK] Iconos generados

echo.
echo [2/3] Generando splash screen...
call flutter pub run flutter_native_splash:create
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Fallo al generar splash screen
    pause
    exit /b 1
)
echo [OK] Splash screen generado

echo.
echo [3/3] Limpiando proyecto...
call flutter clean
call flutter pub get
echo [OK] Proyecto limpio y actualizado

echo.
echo ========================================
echo  COMPLETADO!
echo ========================================
echo.
echo Tu app ahora tiene:
echo  - Icono personalizado
echo  - Splash screen con logo
echo  - Soporte Android adaptativo
echo.
echo Ejecuta: flutter run
echo.
pause
