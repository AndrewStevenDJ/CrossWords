# Sopa de Letras - Crossword Puzzle Game 🎮

Una aplicación Flutter completa de crucigramas con sistema de puntuación, leaderboard y múltiples categorías.

## ✨ Características

- 🧩 **Generación dinámica de crucigramas** con algoritmo optimizado
- 🏆 **Sistema de puntuación completo** con bonificaciones por tiempo y precisión
- 📊 **Top 5 Leaderboard** con filtros por categoría
- 🎯 **Múltiples categorías** (Animales, Países, Deportes, etc.)
- ⏱️ **Temporizador en tiempo real** durante el juego
- 💾 **Persistencia en Supabase** para puntajes y categorías personalizadas
- 📱 **Diseño responsivo** para móviles en orientación vertical y horizontal
- 🌙 **Interfaz moderna** con Material Design

## 🚀 Instalación

### 1. Clona el repositorio

```bash
git clone https://github.com/AndrewStevenDJ/CrossWords.git
cd generate_crossword
```

### 2. Instala las dependencias

```bash
flutter pub get
```

### 3. Configura las variables de entorno

```bash
# Copia el archivo de ejemplo
cp .env.example .env

# Edita .env con tus credenciales de Supabase
# SUPABASE_URL=https://tu-proyecto.supabase.co
# SUPABASE_ANON_KEY=tu_clave_aqui
```

📖 **Más información:** Ver [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)

### 4. Configura Supabase (opcional)

Si quieres usar la funcionalidad online (puntajes, leaderboard):

1. Crea una cuenta en [supabase.com](https://supabase.com)
2. Crea un nuevo proyecto
3. Ejecuta el SQL en [SUPABASE_SETUP.md](SUPABASE_SETUP.md)
4. Copia las credenciales al archivo `.env`

### 5. Configura el logo y splash screen (opcional)

```bash
# Sigue las instrucciones en LOGO_SETUP.md
# Convierte las plantillas SVG a PNG o crea tu propio diseño
# Luego ejecuta:
setup_logo.bat      # Windows
bash setup_logo.sh  # Linux/Mac
```

📖 **Guía completa:** Ver [LOGO_SETUP.md](LOGO_SETUP.md)

### 6. Ejecuta la aplicación

```bash
flutter run
```

## 📋 Requisitos

- Flutter SDK ^3.9.0
- Dart ^3.9.0
- Android SDK (para Android)
- Xcode (para iOS)

## 🎮 Cómo Jugar

1. **Inicia el juego** presionando el botón "START GAME"
2. **Selecciona palabras** haciendo clic en las celdas del crucigrama
3. **Gana puntos** por cada palabra correcta:
   - Palabras cortas (3 letras): 10 puntos
   - Palabras medianas (4-5): 20 puntos
   - Palabras largas (6-7): 30 puntos
   - Palabras muy largas (8-9): 50 puntos
   - Palabras épicas (10+): 75 puntos
4. **Bonificaciones**:
   - +200 puntos por completar el crucigrama
   - +20 puntos por cada minuto ahorrado (máx 10 minutos)
5. **Penalizaciones**:
   - -5 puntos por cada intento incorrecto
6. **Guarda tu puntaje** y compite en el Top 5

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── models/                      # Modelos de datos
│   ├── category.dart           # Categorías de palabras
│   ├── crossword.dart          # Modelo del crucigrama
│   └── score.dart              # Sistema de puntuación
├── providers.dart               # Estado global con Riverpod
├── services/
│   └── supabase_service.dart   # Cliente de Supabase
└── widgets/                     # Componentes de UI
    ├── crossword_puzzle_app.dart
    ├── crossword_puzzle_widget.dart
    ├── puzzle_completed_widget.dart
    └── start_game_widget.dart

assets/
└── words.txt                    # Diccionario de palabras

.env                             # Credenciales (NO en Git)
.env.example                     # Plantilla de configuración
```

## 🔐 Seguridad

Las credenciales sensibles están protegidas:

- ✅ `.env` está en `.gitignore`
- ✅ Las claves se cargan desde variables de entorno
- ✅ No hay credenciales hardcodeadas en el código

**Verifica tu configuración:**

```bash
# Windows
.\check_env.bat

# Linux/Mac
bash check_env.sh
```

## 📚 Documentación

- [SCORE_SYSTEM_DOCUMENTATION.md](SCORE_SYSTEM_DOCUMENTATION.md) - Sistema de puntuación
- [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) - Configuración de variables de entorno
- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Configuración de base de datos

## 🛠️ Tecnologías

- **Flutter** - Framework UI
- **Riverpod** - Gestión de estado
- **Supabase** - Backend y base de datos
- **flutter_dotenv** - Variables de entorno
- **built_value** - Modelos inmutables

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu rama de características (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

**Andrew Steven DJ**
- GitHub: [@AndrewStevenDJ](https://github.com/AndrewStevenDJ)

## 🙏 Agradecimientos

- Flutter Team por el increíble framework
- Supabase por el backend BaaS
- Comunidad de Flutter por los paquetes open source

---

**¡Disfruta jugando! 🎉**
