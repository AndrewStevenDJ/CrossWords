# 🎵 Guía de Configuración de Audio

## 📁 Archivos que debes agregar

Coloca tus archivos de audio en la carpeta `assets/audio/` con los siguientes nombres EXACTOS:

### 1. **lobby_music.mp3** 
   - 🎧 Música del menú principal/lobby
   - ⏱️ Duración recomendada: 1-3 minutos
   - 🔁 Se reproduce en bucle infinito
   - 📊 Formato: MP3, WAV u OGG
   - 🎚️ Volumen: 50% por defecto

### 2. **game_music.mp3**
   - 🎮 Música durante la partida
   - ⏱️ Duración recomendada: 2-5 minutos
   - 🔁 Se reproduce en bucle infinito
   - 📊 Formato: MP3, WAV u OGG
   - 🎚️ Volumen: 50% por defecto

### 3. **button_click.mp3**
   - 🖱️ Sonido para clics en botones
   - ⏱️ Duración recomendada: 0.1-0.3 segundos
   - 🔊 Efecto corto y sutil
   - 📊 Formato: MP3, WAV u OGG
   - 🎚️ Volumen: 70% por defecto

### 4. **game_complete.mp3**
   - 🎉 Sonido al completar el crucigrama
   - ⏱️ Duración recomendada: 2-5 segundos
   - 🏆 Celebración/fanfarria
   - 📊 Formato: MP3, WAV u OGG
   - 🎚️ Volumen: 70% por defecto

---

## 🚀 Pasos para agregar tus audios

1. **Elimina los archivos de instrucciones:**
   ```
   COLOCA_AQUI_lobby_music.txt
   COLOCA_AQUI_game_music.txt
   COLOCA_AQUI_button_click.txt
   COLOCA_AQUI_game_complete.txt
   ```

2. **Copia tus archivos de audio** a la carpeta `assets/audio/` con los nombres exactos:
   - `lobby_music.mp3`
   - `game_music.mp3`
   - `button_click.mp3`
   - `game_complete.mp3`

3. **Ejecuta el comando:**
   ```bash
   flutter pub get
   ```

4. **Ejecuta la app:**
   ```bash
   flutter run
   ```

---

## 🎮 Funciones disponibles en la app

### En el código podrás usar:

```dart
import 'package:generate_crossword/services/audio_service.dart';

final audioService = AudioService();

// Inicializar el servicio (hazlo en main.dart o al inicio)
await audioService.init();

// Reproducir música del lobby
await audioService.playLobbyMusic();

// Reproducir música de partida
await audioService.playGameMusic();

// Sonido de botón
await audioService.playButtonClick();

// Sonido de victoria
await audioService.playVictorySound();

// Pausar/reanudar música
await audioService.pauseMusic();
await audioService.resumeMusic();

// Detener toda la música
await audioService.stopAllMusic();

// Ajustar volúmenes (0.0 a 1.0)
await audioService.setMusicVolume(0.7);
await audioService.setEffectsVolume(0.8);

// Activar/desactivar audio
audioService.toggleMusic(true);  // o false
audioService.toggleSfx(false);   // o true

// Obtener estado actual
double musicVol = audioService.musicVolume;
bool musicEnabled = audioService.isMusicEnabled;
```

---

## 🎛️ Características del sistema de audio

✅ **Música de fondo en loop** - La música del lobby y partida se repiten automáticamente  
✅ **Control independiente** - Volumen separado para música y efectos  
✅ **Transiciones automáticas** - Al cambiar de lobby a partida, la música cambia sola  
✅ **Sistema singleton** - Un solo servicio de audio para toda la app  
✅ **Manejo de errores** - Si un audio falta, no crashea la app  
✅ **Debug logs** - Mensajes en consola para saber qué está sonando  

---

## 📝 Recomendaciones de calidad

### Para música de fondo:
- **Formato:** MP3 (mejor compatibilidad)
- **Bitrate:** 128-192 kbps
- **Frecuencia:** 44.1 kHz
- **Canales:** Stereo
- **Tamaño:** Mantén archivos < 5 MB por canción

### Para efectos de sonido:
- **Formato:** MP3 o WAV
- **Bitrate:** 64-128 kbps (suficiente para efectos cortos)
- **Frecuencia:** 44.1 kHz
- **Tamaño:** < 100 KB por efecto

---

## 🆓 Recursos para encontrar audio

Si no tienes tus propios audios, puedes conseguir música y efectos gratuitos en:

- **Freesound.org** - Efectos de sonido gratuitos
- **Incompetech.com** - Música libre de derechos
- **Pixabay Audio** - Música y efectos gratuitos
- **Zapsplat.com** - Efectos de sonido free

⚠️ **IMPORTANTE:** Asegúrate de usar música libre de derechos si vas a publicar la app.

---

## ❓ Solución de problemas

### El audio no se reproduce:
1. Verifica que los archivos tengan los nombres EXACTOS
2. Asegúrate de que estén en `assets/audio/`
3. Ejecuta `flutter pub get` después de agregar archivos
4. Reinicia la app completamente
5. Revisa los logs en consola (busca mensajes con 🎵 o ⚠️)

### El audio suena cortado o con lag:
1. Reduce el tamaño de los archivos
2. Usa formato MP3 en lugar de WAV
3. Reduce el bitrate a 128 kbps

### La app tarda en iniciar:
1. Los archivos de audio son muy grandes
2. Comprime los archivos sin perder calidad
3. Para música de fondo, mantén < 5 MB por archivo

---

## 🔧 Integración en tu código

El servicio está listo para usar. Solo necesitas llamarlo en los lugares apropiados:

1. **En main.dart** - Inicializar el servicio
2. **En el lobby** - `playLobbyMusic()`
3. **Al iniciar partida** - `playGameMusic()`
4. **En cada botón** - `playButtonClick()`
5. **Al completar juego** - `playVictorySound()`

---

¡Listo! Solo coloca tus archivos y todo funcionará automáticamente. 🎉
