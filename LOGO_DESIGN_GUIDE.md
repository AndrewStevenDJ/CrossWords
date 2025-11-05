# Guía para Crear el Logo y Splash Screen

## 🎨 Diseño Propuesto

### Concepto del Logo:
**Crucigrama con letras formando "CW"**
- Fondo: Azul (#2196F3) 
- Diseño: Cuadrícula de crucigrama estilizada
- Letras: "C" y "W" destacadas en blanco
- Elementos: Estrellas/puntos decorativos

### Dimensiones Requeridas:

#### 1. **app_icon.png** (Icono Principal)
- Tamaño: **1024x1024 px**
- Formato: PNG con transparencia
- Uso: Icono de la app en launcher

#### 2. **app_icon_foreground.png** (Icono Adaptativo Android)
- Tamaño: **1024x1024 px**
- Formato: PNG con transparencia
- Contenido: Solo el símbolo central (sin fondo)
- Margen: 20% de padding alrededor

#### 3. **splash_logo.png** (Logo Splash Screen)
- Tamaño: **1242x2208 px** (o al menos 512x512 px)
- Formato: PNG con transparencia
- Uso: Logo que aparece al iniciar la app

## 🛠️ Opción 1: Crear con Herramientas Online (Rápido)

### Usando Canva (Gratis):
1. Ve a [canva.com](https://canva.com)
2. Crea un diseño de **1024x1024 px**
3. Busca plantillas de "app icon" o "game logo"
4. Diseño sugerido:
   ```
   ┌─────────────┐
   │  ■ C ■ ■ ■  │
   │  ■ ■ R ■ ■  │
   │  ■ ■ O ■ ■  │
   │  ■ W ■ ■ ★  │
   │  ■ ■ ■ D ■  │
   └─────────────┘
   ```
5. Elementos:
   - Fondo azul (#2196F3)
   - Cuadrícula blanca
   - Letras destacadas: C, R, O, W, D
   - Estrella amarilla (#FFC107) en esquina
6. Exporta como PNG

### Usando Figma (Profesional):
1. Ve a [figma.com](https://figma.com)
2. Crea frame de 1024x1024
3. Diseña el crucigrama
4. Exporta en múltiples tamaños

### Usando Favicon Generator (Automático):
1. Ve a [favicon.io](https://favicon.io/favicon-generator/)
2. Genera un icono con texto "CW"
3. Descarga y renombra los archivos

## 🛠️ Opción 2: Usar Logo Generado por IA

### Usando DALL-E o Midjourney:
**Prompt sugerido:**
```
"Modern crossword puzzle game app icon, blue background (#2196F3), 
white grid pattern, letters C and W highlighted, yellow star accent, 
minimalist flat design, 1024x1024, app store quality"
```

## 🛠️ Opción 3: Logo Placeholder Temporal

He creado un script Python simple para generar un logo básico:

```python
# Requiere: pip install pillow

from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size=1024):
    # Crear imagen con fondo azul
    img = Image.new('RGB', (size, size), color='#2196F3')
    draw = ImageDraw.Draw(img)
    
    # Calcular tamaños
    cell_size = size // 10
    margin = cell_size
    
    # Dibujar cuadrícula del crucigrama
    for i in range(5):
        for j in range(5):
            x = margin + j * cell_size * 1.5
            y = margin + i * cell_size * 1.5
            # Cuadrado blanco con borde
            draw.rectangle([x, y, x + cell_size, y + cell_size], 
                         fill='white', outline='#1976D2', width=3)
    
    # Agregar texto "CW" grande
    try:
        font = ImageFont.truetype("arial.ttf", size // 3)
    except:
        font = ImageFont.load_default()
    
    text = "CW"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    # Sombra
    draw.text((x+4, y+4), text, fill='#1565C0', font=font)
    # Texto principal
    draw.text((x, y), text, fill='white', font=font)
    
    # Agregar estrella amarilla
    star_size = size // 8
    star_x = size - star_size - 20
    star_y = 20
    draw.ellipse([star_x, star_y, star_x + star_size, star_y + star_size], 
                 fill='#FFC107')
    
    return img

# Crear los 3 archivos necesarios
os.makedirs('assets/images', exist_ok=True)

# 1. Icono principal
icon = create_icon(1024)
icon.save('assets/images/app_icon.png')

# 2. Icono foreground (con padding)
icon_fg = create_icon(1024)
icon_fg.save('assets/images/app_icon_foreground.png')

# 3. Splash logo (más grande)
splash = create_icon(1242)
splash.save('assets/images/splash_logo.png')

print("✓ Logos creados exitosamente!")
```

## 📦 Archivos a Crear Manualmente

Si prefieres crear los archivos tú mismo, guárdalos en:

```
assets/images/
├── app_icon.png              (1024x1024 px)
├── app_icon_foreground.png   (1024x1024 px, con transparencia)
└── splash_logo.png           (512x512 px mínimo)
```

### Diseño Simple con Editor de Imágenes:

1. **Fondo azul** (#2196F3)
2. **Cuadrícula 5x5** en blanco
3. **Letras**: 
   - C (esquina superior izquierda)
   - R (centro)
   - O (centro)
   - W (esquina inferior izquierda)
   - D (esquina inferior derecha)
4. **Estrella amarilla** (#FFC107) como acento

## 🚀 Después de Crear los Archivos

Una vez que tengas los archivos en `assets/images/`, ejecuta:

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Generar el icono
flutter pub run flutter_launcher_icons

# 3. Generar el splash screen
flutter pub run flutter_native_splash:create

# 4. Limpiar y reconstruir
flutter clean
flutter pub get
flutter run
```

## 🎨 Paleta de Colores Sugerida

- **Principal**: #2196F3 (Azul Material)
- **Oscuro**: #1976D2 (Azul oscuro)
- **Acento**: #FFC107 (Amarillo/Oro)
- **Texto**: #FFFFFF (Blanco)
- **Cuadrícula**: #E3F2FD (Azul muy claro)

## 📱 Vista Previa

El resultado será:
- ✅ Icono personalizado en el launcher
- ✅ Splash screen con tu logo al abrir la app
- ✅ Icono adaptativo en Android 8+
- ✅ Compatibilidad con Android 12+

## 🔗 Recursos Útiles

- [App Icon Generator](https://appicon.co/)
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)
- [Canva](https://canva.com)
- [Figma](https://figma.com)
- [GIMP](https://gimp.org) (Editor gratuito)
