# 🎨 Setup Logo y Splash Screen - Guía Paso a Paso

## 📝 Resumen

Esta guía te ayudará a configurar el icono y splash screen de tu app de crucigramas.

## 🎯 Lo que necesitas

Solo **2 archivos PNG**:
1. `assets/images/icon.png` (1024x1024 px) - Icono de la app
2. `assets/images/splash.png` (512x512 px) - Logo del splash screen

---

## 🚀 Método Rápido (Recomendado)

### Paso 1: Convierte las plantillas SVG a PNG

Tienes 2 plantillas SVG listas:
- `assets/images/icon_template.svg`
- `assets/images/splash_template.svg`

**Opción A: Usar un conversor online**
1. Ve a https://svgtopng.com/ o https://cloudconvert.com/svg-to-png
2. Sube `icon_template.svg`
3. Configura tamaño: **1024x1024 px**
4. Descarga como `icon.png` y guárdalo en `assets/images/`
5. Repite con `splash_template.svg` (tamaño: **512x512 px**)
6. Descarga como `splash.png` y guárdalo en `assets/images/`

**Opción B: Usar Inkscape (si lo tienes instalado)**
```bash
inkscape assets/images/icon_template.svg --export-filename=assets/images/icon.png --export-width=1024
inkscape assets/images/splash_template.svg --export-filename=assets/images/splash.png --export-width=512
```

**Opción C: Abrir en navegador y hacer captura**
1. Abre `icon_template.svg` en Chrome/Edge
2. Haz clic derecho → Guardar imagen como
3. Guárdala como PNG (puede requerir ajustar tamaño después)

### Paso 2: Ejecuta el script de setup

**Windows:**
```bash
setup_logo.bat
```

**Linux/Mac:**
```bash
bash setup_logo.sh
```

### Paso 3: ¡Listo!

El script ejecutará automáticamente:
1. `flutter pub run flutter_launcher_icons` - Genera el icono
2. `flutter pub run flutter_native_splash:create` - Genera el splash
3. `flutter clean && flutter pub get` - Limpia el proyecto

---

## 🎨 Método Personalizado (Diseño Propio)

Si quieres crear tu propio diseño:

### Opción 1: Usar Canva (Más Fácil)

1. Ve a [canva.com](https://canva.com)
2. Crea diseño de **1024 x 1024 px**
3. Diseña tu logo con tema de crucigrama:
   - Fondo azul (#2196F3)
   - Cuadrícula de crucigrama
   - Letras "CW" o "CROSSWORD"
   - Decoraciones (estrellas, etc.)
4. Descarga como PNG → `icon.png`
5. Repite para splash (512x512 px) → `splash.png`
6. Guarda ambos en `assets/images/`

### Opción 2: Usar Figma (Profesional)

1. Ve a [figma.com](https://figma.com)
2. Crea frame de 1024x1024 px
3. Diseña el logo
4. Exporta como PNG @ 1x
5. Guarda como `icon.png` en `assets/images/`
6. Repite para splash

### Opción 3: Usar GIMP/Photoshop

1. Abre GIMP o Photoshop
2. Nuevo archivo: 1024x1024 px
3. Diseña el logo
4. Exporta como PNG
5. Guarda en `assets/images/icon.png`

---

## 🔧 Comandos Manuales

Si prefieres ejecutar los comandos tú mismo:

```bash
# 1. Instalar dependencias (si no lo hiciste)
flutter pub get

# 2. Generar iconos
flutter pub run flutter_launcher_icons

# 3. Generar splash screen
flutter pub run flutter_native_splash:create

# 4. Limpiar y reconstruir
flutter clean
flutter pub get
flutter run
```

---

## ✅ Verificar que Funciona

Después de ejecutar los comandos:

1. **Icono:** Verás el nuevo icono en el launcher de tu dispositivo
2. **Splash:** Al abrir la app, verás el splash screen con tu logo

---

## 📋 Requisitos de los Archivos

### icon.png
- ✅ Tamaño: Mínimo 1024x1024 px
- ✅ Formato: PNG
- ✅ Puede tener fondo de color
- ✅ Diseño centrado

### splash.png
- ✅ Tamaño: Mínimo 512x512 px (recomendado 1242x2208)
- ✅ Formato: PNG
- ✅ Preferiblemente con fondo transparente
- ✅ Logo centrado

---

## 🎨 Paleta de Colores

| Color | Código | Uso |
|-------|--------|-----|
| Azul Principal | `#2196F3` | Fondo icono/splash |
| Azul Oscuro | `#1976D2` | Bordes y detalles |
| Amarillo/Oro | `#FFC107` | Acentos (estrellas) |
| Blanco | `#FFFFFF` | Texto y cuadrícula |

---

## ❓ Solución de Problemas

### "Cannot find image: assets/images/icon.png"
→ Asegúrate de crear los archivos PNG primero

### "Image resolution too small"
→ El icono debe ser mínimo 1024x1024 px

### "Splash screen not showing"
→ Haz un `flutter clean` y vuelve a ejecutar

### Los archivos SVG no se convierten
→ Usa un conversor online como svgtopng.com

---

## 📂 Estructura de Archivos

```
assets/images/
├── icon_template.svg      # Plantilla SVG para el icono
├── splash_template.svg    # Plantilla SVG para el splash
├── icon.png              # Tu icono final (1024x1024)
└── splash.png            # Tu splash final (512x512)
```

---

## 🔗 Recursos

- **Convertidor SVG → PNG:** https://svgtopng.com/
- **Canva:** https://canva.com
- **Figma:** https://figma.com  
- **GIMP:** https://gimp.org
- **Photopea:** https://photopea.com (Photoshop online gratis)

---

## 📝 Notas

- Los archivos SVG son solo plantillas visuales
- Necesitas convertirlos a PNG para usar con Flutter
- Puedes editar los SVG en cualquier editor de texto
- El color de fondo del splash se configura en `pubspec.yaml`

---

**¿Listo?** 
1. Convierte los SVG a PNG o crea tus propios diseños
2. Ejecuta `setup_logo.bat` (Windows) o `bash setup_logo.sh` (Linux/Mac)
3. ¡Disfruta tu nueva app con logo personalizado! 🎉
