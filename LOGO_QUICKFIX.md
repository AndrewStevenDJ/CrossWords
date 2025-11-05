# ⚡ SOLUCIÓN RÁPIDA - Crear PNG en 2 Minutos

## 🚨 Problema
Los archivos `icon.png` y `splash.png` NO existen. Flutter los necesita.

## ✅ SOLUCIÓN MÁS RÁPIDA (Recomendada)

### Opción 1: Usar Generador Online (2 minutos)

#### Paso 1: Crear icon.png
1. Ve a: https://favicon.io/favicon-generator/
2. Configura:
   - **Text**: CW
   - **Background**: Rounded
   - **Font Family**: Leckerli One (o cualquier Bold)
   - **Font Size**: 80
   - **Background Color**: #2196F3 (azul)
   - **Font Color**: #FFFFFF (blanco)
3. Click **Download**
4. Extrae el ZIP
5. Busca el archivo más grande (android-chrome-512x512.png o similar)
6. **Renómbralo a `icon.png`**
7. Cópialo a: `assets/images/icon.png`

#### Paso 2: Crear splash.png
1. Copia `icon.png` 
2. Renómbralo a `splash.png`
3. Guárdalo en: `assets/images/splash.png`

#### Paso 3: Ejecutar comandos
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
flutter clean
flutter run
```

---

## ✅ Opción 2: Descargar PNG Pre-hechos (1 minuto)

Usa un generador de placeholder:

1. **Para icon.png:**
   - Ve a: https://via.placeholder.com/1024x1024/2196F3/FFFFFF?text=CW
   - Haz clic derecho → Guardar imagen como
   - Guarda como: `assets/images/icon.png`

2. **Para splash.png:**
   - Ve a: https://via.placeholder.com/512x512/2196F3/FFFFFF?text=CROSSWORD
   - Haz clic derecho → Guardar imagen como
   - Guarda como: `assets/images/splash.png`

3. Ejecuta:
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
flutter clean
flutter run
```

---

## ✅ Opción 3: Usar Canva (5 minutos - Mejor calidad)

1. Ve a https://canva.com
2. Crea diseño **1024 x 1024 px**
3. Fondo azul (#2196F3)
4. Agrega texto "CW" grande en blanco
5. Descarga como PNG → `icon.png`
6. Guarda en `assets/images/`
7. Crea otro de 512x512 → `splash.png`

---

## 🎯 Verificar que Funciona

Después de crear los archivos, verifica:

```bash
# En PowerShell
dir assets\images

# Deberías ver:
# icon.png
# splash.png
```

Luego ejecuta:
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

Si ves mensajes de éxito, ¡ya está! 🎉

---

## ❌ Si sigue sin funcionar

### Error: "Cannot find image file"
→ Verifica que los archivos estén exactamente en:
- `assets/images/icon.png`
- `assets/images/splash.png`

### Error: "Image size too small"
→ icon.png debe ser mínimo 1024x1024 px
→ splash.png debe ser mínimo 512x512 px

### No se ve el splash
→ Ejecuta: `flutter clean` y vuelve a compilar

---

## 📝 Archivos Requeridos

```
assets/images/
├── icon.png      ← Mínimo 1024x1024 px (REQUERIDO)
└── splash.png    ← Mínimo 512x512 px (REQUERIDO)
```

---

**🎯 Resumen Ultra-Rápido:**

1. Abre https://via.placeholder.com/1024x1024/2196F3/FFFFFF?text=CW
2. Guarda como `assets/images/icon.png`
3. Abre https://via.placeholder.com/512x512/2196F3/FFFFFF?text=CW
4. Guarda como `assets/images/splash.png`
5. Ejecuta:
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
flutter clean
flutter run
```

¡Listo! 🚀
