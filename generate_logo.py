#!/usr/bin/env python3
"""
Generador de Logo para Crossword Puzzle App
Crea los iconos y splash screen necesarios para la aplicación
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
except ImportError:
    print("❌ Error: Pillow no está instalado")
    print("   Instala con: pip install pillow")
    exit(1)

def create_crossword_icon(size=1024, with_background=True):
    """Crea un icono con diseño de crucigrama"""
    
    # Colores
    bg_color = '#2196F3' if with_background else (0, 0, 0, 0)
    grid_color = 'white'
    text_color = 'white'
    star_color = '#FFC107'
    border_color = '#1976D2'
    
    # Crear imagen
    mode = 'RGB' if with_background else 'RGBA'
    img = Image.new(mode, (size, size), color=bg_color)
    draw = ImageDraw.Draw(img)
    
    # Calcular dimensiones
    cell_size = size // 12
    grid_size = 5
    total_grid_size = cell_size * grid_size
    margin = (size - total_grid_size) // 2
    
    # Dibujar cuadrícula del crucigrama 5x5
    for i in range(grid_size):
        for j in range(grid_size):
            x = margin + j * cell_size
            y = margin + i * cell_size
            
            # Dibujar celda
            draw.rectangle(
                [x, y, x + cell_size - 2, y + cell_size - 2],
                fill=grid_color,
                outline=border_color,
                width=2
            )
    
    # Agregar letras formando CROSSWORD
    letters = [
        ('C', 0, 0), ('R', 1, 0), ('O', 2, 0), ('S', 3, 0), ('S', 4, 0),
        ('R', 0, 1),
        ('O', 0, 2), ('W', 2, 2),
        ('S', 0, 3),
        ('S', 0, 4), ('W', 1, 4), ('O', 2, 4), ('R', 3, 4), ('D', 4, 4),
    ]
    
    # Intentar cargar fuente
    try:
        font_size = cell_size // 2
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", cell_size // 2)
        except:
            font = ImageFont.load_default()
    
    # Dibujar letras
    for letter, col, row in letters:
        x = margin + col * cell_size + cell_size // 4
        y = margin + row * cell_size + cell_size // 6
        
        # Sombra
        draw.text((x + 2, y + 2), letter, fill=border_color, font=font)
        # Letra principal
        draw.text((x, y), letter, fill=text_color, font=font)
    
    # Agregar estrella decorativa
    star_size = cell_size // 2
    star_x = margin + grid_size * cell_size - star_size // 2
    star_y = margin - star_size // 2
    
    # Dibujar estrella simple (círculo)
    draw.ellipse(
        [star_x, star_y, star_x + star_size, star_y + star_size],
        fill=star_color
    )
    
    return img

def create_splash_logo(size=1242):
    """Crea el logo para splash screen"""
    
    bg_color = (0, 0, 0, 0)  # Transparente
    text_color = 'white'
    grid_color = 'white'
    border_color = '#E3F2FD'
    
    img = Image.new('RGBA', (size, size), color=bg_color)
    draw = ImageDraw.Draw(img)
    
    # Tamaño del logo (más pequeño para splash)
    logo_size = size // 2
    margin = (size - logo_size) // 2
    
    cell_size = logo_size // 6
    
    # Dibujar cuadrícula
    for i in range(6):
        for j in range(6):
            if (i + j) % 2 == 0:  # Patrón alternado
                x = margin + j * cell_size
                y = margin + i * cell_size
                draw.rectangle(
                    [x, y, x + cell_size - 2, y + cell_size - 2],
                    fill=grid_color,
                    outline=border_color,
                    width=2
                )
    
    # Texto grande "CW" centrado
    try:
        font_size = logo_size // 3
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", logo_size // 3)
        except:
            font = ImageFont.load_default()
    
    text = "CW"
    
    # Calcular posición centrada
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    # Sombra
    draw.text((x + 4, y + 4), text, fill='#1565C0', font=font)
    # Texto principal
    draw.text((x, y), text, fill=text_color, font=font)
    
    return img

def main():
    """Generar todos los archivos de logo necesarios"""
    
    print("🎨 Generando logos para Crossword Puzzle App...")
    print()
    
    # Crear directorio si no existe
    os.makedirs('assets/images', exist_ok=True)
    
    try:
        # 1. Icono principal (con fondo)
        print("📱 Creando app_icon.png (1024x1024)...")
        icon = create_crossword_icon(1024, with_background=True)
        icon.save('assets/images/app_icon.png', 'PNG', quality=100)
        print("   ✓ app_icon.png creado")
        
        # 2. Icono foreground (sin fondo, para adaptive icon)
        print("📱 Creando app_icon_foreground.png (1024x1024)...")
        icon_fg = create_crossword_icon(1024, with_background=False)
        icon_fg.save('assets/images/app_icon_foreground.png', 'PNG', quality=100)
        print("   ✓ app_icon_foreground.png creado")
        
        # 3. Splash logo
        print("🌟 Creando splash_logo.png (1242x1242)...")
        splash = create_splash_logo(1242)
        splash.save('assets/images/splash_logo.png', 'PNG', quality=100)
        print("   ✓ splash_logo.png creado")
        
        # Crear también una versión 512x512 para compatibilidad
        print("🌟 Creando splash_logo_512.png (512x512)...")
        splash_small = create_splash_logo(512)
        splash_small.save('assets/images/splash_logo_512.png', 'PNG', quality=100)
        print("   ✓ splash_logo_512.png creado")
        
        print()
        print("✅ ¡Todos los logos fueron creados exitosamente!")
        print()
        print("📂 Archivos generados en assets/images/:")
        print("   - app_icon.png")
        print("   - app_icon_foreground.png")
        print("   - splash_logo.png")
        print("   - splash_logo_512.png")
        print()
        print("🚀 Próximos pasos:")
        print("   1. flutter pub get")
        print("   2. flutter pub run flutter_launcher_icons")
        print("   3. flutter pub run flutter_native_splash:create")
        print("   4. flutter clean && flutter run")
        
    except Exception as e:
        print(f"❌ Error al crear logos: {e}")
        return 1
    
    return 0

if __name__ == '__main__':
    exit(main())
