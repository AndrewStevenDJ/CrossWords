import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Servicio centralizado para manejar todos los audios de la app
class AudioService {
  // Instancia singleton
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Players para música de fondo (lobby y partida)
  final AudioPlayer _lobbyPlayer = AudioPlayer();
  final AudioPlayer _gamePlayer = AudioPlayer();
  
  // Player para efectos de sonido
  final AudioPlayer _effectsPlayer = AudioPlayer();

  // Control de volumen
  double _musicVolume = 0.5;
  double _effectsVolume = 0.7;
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;

  // Rutas de los archivos de audio
  static const String _lobbyMusic = 'audio/lobby_music.mp3';
  static const String _gameMusic = 'audio/game_music.mp3';
  static const String _buttonSound = 'audio/button_click.mp3';
  static const String _victorySound = 'audio/game_complete.mp3';

  /// Inicializa el servicio de audio
  Future<void> init() async {
    // Configurar el modo de reproducción para música de fondo (loop)
    await _lobbyPlayer.setReleaseMode(ReleaseMode.loop);
    await _gamePlayer.setReleaseMode(ReleaseMode.loop);
    
    // Configurar volúmenes iniciales
    await _lobbyPlayer.setVolume(_musicVolume);
    await _gamePlayer.setVolume(_musicVolume);
    await _effectsPlayer.setVolume(_effectsVolume);

    debugPrint('🎵 AudioService inicializado');
  }

  /// Reproduce la música del lobby/menú
  Future<void> playLobbyMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      await _gamePlayer.stop(); // Detener música de partida si está sonando
      await _lobbyPlayer.play(AssetSource(_lobbyMusic));
      debugPrint('🎵 Reproduciendo música del lobby');
    } catch (e) {
      debugPrint('⚠️ Error al reproducir música del lobby: $e');
    }
  }

  /// Reproduce la música de la partida
  Future<void> playGameMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      await _lobbyPlayer.stop(); // Detener música del lobby si está sonando
      await _gamePlayer.play(AssetSource(_gameMusic));
      debugPrint('🎵 Reproduciendo música de partida');
    } catch (e) {
      debugPrint('⚠️ Error al reproducir música de partida: $e');
    }
  }

  /// Reproduce sonido de clic en botón
  Future<void> playButtonClick() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _effectsPlayer.play(AssetSource(_buttonSound));
      debugPrint('🔊 Click de botón');
    } catch (e) {
      debugPrint('⚠️ Error al reproducir sonido de botón: $e');
    }
  }

  /// Reproduce sonido de victoria/completar juego
  Future<void> playVictorySound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _effectsPlayer.play(AssetSource(_victorySound));
      debugPrint('🎉 Sonido de victoria');
    } catch (e) {
      debugPrint('⚠️ Error al reproducir sonido de victoria: $e');
    }
  }

  /// Pausa toda la música
  Future<void> pauseMusic() async {
    await _lobbyPlayer.pause();
    await _gamePlayer.pause();
    debugPrint('⏸️ Música pausada');
  }

  /// Reanuda la música
  Future<void> resumeMusic() async {
    if (!_isMusicEnabled) return;
    
    if (await _lobbyPlayer.getCurrentPosition() != null) {
      await _lobbyPlayer.resume();
    }
    if (await _gamePlayer.getCurrentPosition() != null) {
      await _gamePlayer.resume();
    }
    debugPrint('▶️ Música reanudada');
  }

  /// Detiene toda la música
  Future<void> stopAllMusic() async {
    await _lobbyPlayer.stop();
    await _gamePlayer.stop();
    debugPrint('⏹️ Música detenida');
  }

  /// Ajusta el volumen de la música (0.0 - 1.0)
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _lobbyPlayer.setVolume(_musicVolume);
    await _gamePlayer.setVolume(_musicVolume);
    debugPrint('🔊 Volumen de música: ${(_musicVolume * 100).round()}%');
  }

  /// Ajusta el volumen de efectos de sonido (0.0 - 1.0)
  Future<void> setEffectsVolume(double volume) async {
    _effectsVolume = volume.clamp(0.0, 1.0);
    await _effectsPlayer.setVolume(_effectsVolume);
    debugPrint('🔊 Volumen de efectos: ${(_effectsVolume * 100).round()}%');
  }

  /// Activa/desactiva la música
  void toggleMusic(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopAllMusic();
    }
    debugPrint('🎵 Música: ${enabled ? "Activada" : "Desactivada"}');
  }

  /// Activa/desactiva los efectos de sonido
  void toggleSfx(bool enabled) {
    _isSfxEnabled = enabled;
    debugPrint('🔊 Efectos de sonido: ${enabled ? "Activados" : "Desactivados"}');
  }

  // Getters para obtener el estado actual
  double get musicVolume => _musicVolume;
  double get effectsVolume => _effectsVolume;
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  /// Libera los recursos de audio
  Future<void> dispose() async {
    await _lobbyPlayer.dispose();
    await _gamePlayer.dispose();
    await _effectsPlayer.dispose();
    debugPrint('🎵 AudioService liberado');
  }
}
