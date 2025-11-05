/// Representa el puntaje de un jugador
class GameScore {
  /// Puntos totales acumulados
  final int totalPoints;

  /// Número de palabras correctas encontradas
  final int correctWords;

  /// Número de intentos incorrectos
  final int wrongAttempts;

  /// Tiempo transcurrido en segundos (opcional)
  final int? timeElapsed;

  /// Lista de palabras correctas encontradas
  final List<String> foundWords;

  /// Fecha de inicio del juego
  final DateTime startTime;

  /// Fecha de finalización (null si aún está en progreso)
  final DateTime? endTime;

  /// ID de la categoría utilizada (null si es default)
  final String? categoryId;

  /// Nombre de la categoría
  final String? categoryName;

  /// Constructor
  const GameScore({
    required this.totalPoints,
    required this.correctWords,
    required this.wrongAttempts,
    this.timeElapsed,
    required this.foundWords,
    required this.startTime,
    this.endTime,
    this.categoryId,
    this.categoryName,
  });

  /// Crear un puntaje inicial
  factory GameScore.initial({String? categoryId, String? categoryName}) {
    return GameScore(
      totalPoints: 0,
      correctWords: 0,
      wrongAttempts: 0,
      timeElapsed: null,
      foundWords: [],
      startTime: DateTime.now(),
      endTime: null,
      categoryId: categoryId,
      categoryName: categoryName,
    );
  }

  /// Convertir a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'correct_words': correctWords,
      'wrong_attempts': wrongAttempts,
      'time_elapsed': timeElapsed,
      'found_words': foundWords,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }

  /// Crear desde JSON de Supabase
  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      totalPoints: json['total_points'] as int,
      correctWords: json['correct_words'] as int,
      wrongAttempts: json['wrong_attempts'] as int,
      timeElapsed: json['time_elapsed'] as int?,
      foundWords: (json['found_words'] as List).map((e) => e as String).toList(),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }

  /// Crear una copia con modificaciones
  GameScore copyWith({
    int? totalPoints,
    int? correctWords,
    int? wrongAttempts,
    int? timeElapsed,
    List<String>? foundWords,
    DateTime? startTime,
    DateTime? endTime,
    String? categoryId,
    String? categoryName,
  }) {
    return GameScore(
      totalPoints: totalPoints ?? this.totalPoints,
      correctWords: correctWords ?? this.correctWords,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      foundWords: foundWords ?? this.foundWords,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}

/// Sistema de cálculo de puntos
class ScoreCalculator {
  /// Puntos base por palabra según su longitud
  static int pointsForWord(String word) {
    final length = word.length;
    if (length <= 3) return 10;
    if (length <= 5) return 20;
    if (length <= 7) return 30;
    if (length <= 9) return 50;
    return 75; // Palabras de 10+ letras
  }

  /// Penalización por intento incorrecto
  static const int wrongAttemptPenalty = -5;

  /// Bonus por completar el crucigrama
  static const int completionBonus = 200;

  /// Bonus por tiempo (puntos extra si completas rápido)
  /// Por cada minuto bajo el tiempo objetivo, se otorgan puntos extra
  static int timeBonusPoints(int secondsElapsed, int targetSeconds) {
    if (secondsElapsed < targetSeconds) {
      final minutesSaved = (targetSeconds - secondsElapsed) ~/ 60;
      return minutesSaved * 20; // 20 puntos por minuto ahorrado
    }
    return 0;
  }

  /// Calcular puntaje total
  static int calculateTotalScore({
    required List<String> foundWords,
    required int wrongAttempts,
    required bool isCompleted,
    int? timeElapsed,
    int targetTimeSeconds = 600, // 10 minutos por defecto
  }) {
    int total = 0;

    // Sumar puntos por cada palabra
    for (final word in foundWords) {
      total += pointsForWord(word);
    }

    // Restar penalizaciones
    total += wrongAttempts * wrongAttemptPenalty;

    // Bonus por completar
    if (isCompleted) {
      total += completionBonus;

      // Bonus por tiempo si está disponible
      if (timeElapsed != null) {
        total += timeBonusPoints(timeElapsed, targetTimeSeconds);
      }
    }

    // No permitir puntajes negativos
    return total < 0 ? 0 : total;
  }
}
