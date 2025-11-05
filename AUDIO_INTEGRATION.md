# 🚀 Guía Rápida de Integración del Audio

## 📋 Lista de verificación

Antes de integrar, asegúrate de:
- [ ] Tus 4 archivos de audio están en `assets/audio/`
- [ ] Los nombres son EXACTOS: `lobby_music.mp3`, `game_music.mp3`, `button_click.mp3`, `game_complete.mp3`
- [ ] Ejecutaste `flutter pub get`

---

## 🎯 Integración en 3 pasos

### 1️⃣ Inicializar en main.dart

Agrega esto en tu archivo `lib/main.dart`:

```dart
import 'package:generate_crossword/services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  // 🎵 INICIALIZAR AUDIO
  await AudioService().init();
  
  runApp(const MyApp());
}
```

---

### 2️⃣ Usar en el lobby/menú

Cuando el usuario esté en el menú principal:

```dart
import 'package:generate_crossword/services/audio_service.dart';

class MenuScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Reproducir música del lobby al entrar
    AudioService().playLobbyMusic();
  }
  
  // Ejemplo en un botón
  ElevatedButton(
    onPressed: () {
      AudioService().playButtonClick(); // Sonido de clic
      // Tu acción del botón...
    },
    child: Text('Jugar'),
  )
}
```

---

### 3️⃣ Usar durante la partida

Cuando el jugador inicie una partida:

```dart
import 'package:generate_crossword/services/audio_service.dart';

class GameScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Cambiar a música de partida
    AudioService().playGameMusic();
  }
  
  // Cuando el jugador completa el juego
  void _onGameComplete() {
    AudioService().playVictorySound(); // Sonido de victoria
    // Mostrar pantalla de victoria...
  }
  
  @override
  void dispose() {
    // Al salir de la partida, volver al lobby
    AudioService().playLobbyMusic();
    super.dispose();
  }
}
```

---

## 🎮 Ejemplos de uso completos

### Ejemplo: Botón con sonido

```dart
Widget _buildButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: () {
      AudioService().playButtonClick(); // 🔊 Sonido
      onPressed();
    },
    child: Text(text),
  );
}
```

### Ejemplo: Completar palabra

```dart
void _onWordFound() {
  setState(() {
    wordsFound++;
  });
  
  if (wordsFound == totalWords) {
    // Juego completado
    AudioService().playVictorySound(); // 🎉
    _showVictoryDialog();
  }
}
```

### Ejemplo: Pausar música al salir de la app

```dart
class MyApp extends StatefulWidget {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioService().pauseMusic(); // Pausar al minimizar
    } else if (state == AppLifecycleState.resumed) {
      AudioService().resumeMusic(); // Reanudar al volver
    }
  }
}
```

---

## 🎛️ Control de configuración (opcional)

Si quieres agregar opciones de audio en settings:

```dart
// En tu pantalla de configuración
Slider(
  value: AudioService().musicVolume,
  min: 0.0,
  max: 1.0,
  onChanged: (value) {
    AudioService().setMusicVolume(value);
  },
  label: 'Volumen Música',
)

Switch(
  value: AudioService().isMusicEnabled,
  onChanged: (value) {
    AudioService().toggleMusic(value);
  },
  title: Text('Música'),
)

Switch(
  value: AudioService().isSfxEnabled,
  onChanged: (value) {
    AudioService().toggleSfx(value);
  },
  title: Text('Efectos de sonido'),
)
```

---

## ✅ Checklist de integración

- [ ] `main.dart` - AudioService().init() al inicio
- [ ] Menú/Lobby - AudioService().playLobbyMusic()
- [ ] Inicio de partida - AudioService().playGameMusic()
- [ ] Todos los botones - AudioService().playButtonClick()
- [ ] Al completar juego - AudioService().playVictorySound()
- [ ] Al salir de partida - AudioService().playLobbyMusic()

---

## 🐛 Debug

Para ver mensajes de debug en consola, busca estos emojis:
- 🎵 = Música
- 🔊 = Efectos
- ⚠️ = Errores
- 🎉 = Victoria
- ⏸️ = Pausado
- ▶️ = Reproduciendo

---

¡Eso es todo! Con estos 3 pasos tu app tendrá audio completo. 🎉
