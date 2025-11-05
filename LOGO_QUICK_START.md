# 🎨 Guía Rápida: Logo y Splash Screen

## 📋 Lo que necesitas crear

Solo necesitas **2 imágenes**:

### 1. **icon.png** - Icono de la App
- **Tamaño:** 1024x1024 px
- **Ubicación:** `assets/images/icon.png`
- **Diseño sugerido:** Logo cuadrado con el símbolo de crucigrama

### 2. **splash.png** - Logo para Splash Screen  
- **Tamaño:** 512x512 px (o mayor)
- **Ubicación:** `assets/images/splash.png`
- **Diseño sugerido:** Logo con fondo transparente

---

## 🚀 Opción 1: Crear con Canva (MÁS FÁCIL) ⭐

### Para el ICONO (icon.png):

1. Ve a [canva.com](https://canva.com)
2. Crea un diseño de **1024 x 1024 px**
3. Diseña un logo:
   ```
   Fondo: Azul #2196F3
   Centro: Cuadrícula de crucigrama (estilo tablero)
   Texto: "CW" o "CROSSWORD" en blanco
   Extra: Una estrella amarilla (#FFC107) como detalle
   ```
4. Descarga como PNG
5. Guárdalo como: `assets/images/icon.png`

### Para el SPLASH (splash.png):

1. En Canva, crea diseño de **512 x 512 px**
2. Fondo transparente
3. Solo el símbolo/logo (sin fondo azul)
4. Descarga como PNG
5. Guárdalo como: `assets/images/splash.png`

**🎥 Tutorial Canva:** https://www.youtube.com/watch?v=video_tutorial

---

## 🚀 Opción 2: Usar un Generador Online

### Usando [App Icon Generator](https://www.appicon.co/):
1. Abre https://www.appicon.co/
2. Sube una imagen o crea una simple
3. Genera todos los tamaños
4. Descarga el pack
5. Renombra la imagen 1024x1024 a `icon.png`
6. Crea una versión 512x512 para `splash.png`

### Usando [Favicon Generator](https://favicon.io/favicon-generator/):
1. Abre https://favicon.io/favicon-generator/
2. Configura:
   - Texto: "CW"
   - Fondo: #2196F3 (azul)
   - Fuente: Bold
3. Descarga y extrae
4. Usa el archivo más grande como base

---

## 🚀 Opción 3: Diseño Simple con Paint/GIMP

### Para icon.png (1024x1024):
1. Abre Paint / GIMP / Photoshop
2. Crea imagen de 1024x1024 px
3. Rellena con azul: #2196F3
4. Dibuja una cuadrícula 5x5 en blanco
5. Agrega letras grandes "CW" en el centro
6. Guarda como PNG en `assets/images/icon.png`

### Para splash.png (512x512):
1. Crea imagen de 512x512 px
2. Fondo transparente
3. Dibuja solo el símbolo/logo
4. Guarda como PNG en `assets/images/splash.png`

---

## 🎨 Diseño Sugerido (Descripción Visual)

### ICONO:
```
┌──────────────────┐
│ ■□■□■            │  Fondo: Azul #2196F3
│ □■□■□    CW      │  Cuadrícula: Blanca
│ ■□■□■            │  Texto: "CW" grande
│ □■□■□    ★       │  Estrella: Amarilla #FFC107
│ ■□■□■            │
└──────────────────┘
```

### SPLASH:
```
┌──────────────────┐
│                  │  Fondo: Transparente
│      ■□■         │  Solo el símbolo
│      □■□  CW     │  del crucigrama
│      ■□■         │
│                  │
└──────────────────┘
```

---

## 📦 Después de Crear las Imágenes

### 1. Verifica que los archivos existan:
```
assets/images/
├── icon.png   (1024x1024 px)
└── splash.png (512x512 px)
```

### 2. Ejecuta los comandos de Flutter:

```bash
# Generar el icono de la app
flutter pub run flutter_launcher_icons

# Generar el splash screen
flutter pub run flutter_native_splash:create

# Limpiar y ejecutar
flutter clean
flutter pub get
flutter run
```

### 3. ¡Listo! 🎉

Tu app ahora tendrá:
- ✅ Icono personalizado
- ✅ Splash screen con tu logo
- ✅ Soporte para Android adaptativo
- ✅ Compatibilidad con Android 12+

---

## 🎨 Paleta de Colores

| Color | Hex | Uso |
|-------|-----|-----|
| Azul Principal | `#2196F3` | Fondo del icono/splash |
| Azul Oscuro | `#1976D2` | Bordes/sombras |
| Amarillo | `#FFC107` | Acentos/estrella |
| Blanco | `#FFFFFF` | Texto/cuadrícula |

---

## ❓ Troubleshooting

### "No such file or directory: assets/images/icon.png"
→ Crea las imágenes en la ruta correcta

### "Image resolution too low"
→ Asegúrate de que icon.png sea mínimo 1024x1024 px

### "Transparent background not working"
→ Guarda como PNG (no JPG) con transparencia habilitada

---

## 🔗 Recursos Útiles

- **Canva:** https://canva.com (Recomendado)
- **Figma:** https://figma.com (Profesional)
- **GIMP:** https://gimp.org (Gratis, avanzado)
- **Photopea:** https://photopea.com (Photoshop online gratis)

---

## 📝 Notas

- El splash screen se muestra mientras la app carga
- El icono aparece en el launcher del teléfono
- Puedes actualizar las imágenes y volver a ejecutar los comandos
- Los comandos sobrescribirán los iconos anteriores

---

**¿Necesitas ayuda?** Consulta los ejemplos en `LOGO_DESIGN_GUIDE.md`
