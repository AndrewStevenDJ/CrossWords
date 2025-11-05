# Sistema de Puntaje (Score System) - Documentación

## Descripción General

El juego de crucigramas incluye un sistema completo de puntuación que recompensa a los jugadores por:
- Encontrar palabras correctas
- Completar el crucigrama
- Hacerlo rápidamente
- Minimizar errores

## Sistema de Puntos

### 1. Puntos por Palabra Correcta
Los puntos se asignan según la longitud de la palabra encontrada:

| Longitud de Palabra | Puntos |
|---------------------|--------|
| 3 letras o menos    | 10     |
| 4-5 letras          | 20     |
| 6-7 letras          | 30     |
| 8-9 letras          | 50     |
| 10+ letras          | 75     |

### 2. Penalización por Intentos Incorrectos
- **-5 puntos** por cada intento incorrecto
- Los puntos nunca pueden bajar de 0

### 3. Bonus por Completar el Crucigrama
- **+200 puntos** al completar todo el crucigrama correctamente

### 4. Bonus por Tiempo
Si completas el crucigrama en menos de 10 minutos:
- **+20 puntos** por cada minuto ahorrado
- Ejemplo: Si completas en 7 minutos → +60 puntos bonus (3 minutos × 20)

## Arquitectura del Sistema

### Modelo de Datos: `GameScore`

```dart
class GameScore {
  final int totalPoints;         // Puntaje total acumulado
  final int correctWords;        // Número de palabras correctas
  final int wrongAttempts;       // Número de intentos incorrectos
  final int? timeElapsed;        // Tiempo en segundos
  final List<String> foundWords; // Lista de palabras encontradas
  final DateTime startTime;      // Hora de inicio
  final DateTime? endTime;       // Hora de finalización
  final String? categoryId;      // ID de la categoría utilizada
  final String? categoryName;    // Nombre de la categoría
}
```

### Provider: `GameScoreNotifier`

El provider `gameScoreNotifierProvider` maneja el estado del puntaje durante el juego.

#### Métodos Principales:

**1. Iniciar un nuevo juego**
```dart
ref.read(gameScoreNotifierProvider.notifier).startGame(
  categoryId: '123',
  categoryName: 'Frutas',
);
```

**2. Registrar una palabra correcta**
```dart
ref.read(gameScoreNotifierProvider.notifier).addCorrectWord('manzana');
```
- Agrega la palabra a la lista de palabras encontradas
- Calcula y suma los puntos según la longitud
- Actualiza el contador de palabras correctas

**3. Registrar un intento incorrecto**
```dart
ref.read(gameScoreNotifierProvider.notifier).addWrongAttempt();
```
- Resta 5 puntos (mínimo 0)
- Incrementa el contador de intentos incorrectos

**4. Completar el juego**
```dart
ref.read(gameScoreNotifierProvider.notifier).completeGame();
```
- Registra la hora de finalización
- Agrega el bonus de completado (+200 puntos)
- Calcula y agrega el bonus por tiempo (si aplica)

**5. Guardar puntaje en Supabase**
```dart
bool success = await ref.read(gameScoreNotifierProvider.notifier).saveScore(
  playerName: 'Juan',
);
```
- Guarda el puntaje en la base de datos
- Retorna `true` si se guardó correctamente

**6. Obtener resumen del puntaje**
```dart
String summary = ref.read(gameScoreNotifierProvider.notifier).getScoreSummary();
```
Ejemplo de salida:
```
Puntaje Total: 350 puntos
Palabras Correctas: 8
Intentos Incorrectos: 2
Tiempo: 6:45
```

**7. Reiniciar el juego**
```dart
ref.read(gameScoreNotifierProvider.notifier).resetGame();
```

## Integración con la UI

### Ejemplo: Mostrar puntaje en tiempo real

```dart
Consumer(
  builder: (context, ref, child) {
    final scoreData = ref.watch(gameScoreNotifierProvider);
    final points = scoreData['totalPoints'] as int;
    final correctWords = scoreData['correctWords'] as int;
    
    return Column(
      children: [
        Text('Puntaje: $points'),
        Text('Palabras: $correctWords'),
      ],
    );
  },
)
```

### Ejemplo: Cuando el jugador selecciona una palabra correcta

```dart
// En el widget CrosswordPuzzleWidget o similar
void _onWordSelected(String word, bool isCorrect) {
  if (isCorrect) {
    // Registrar palabra correcta
    ref.read(gameScoreNotifierProvider.notifier).addCorrectWord(word);
  } else {
    // Registrar intento incorrecto
    ref.read(gameScoreNotifierProvider.notifier).addWrongAttempt();
  }
}
```

### Ejemplo: Al completar el crucigrama

```dart
// En PuzzleCompletedWidget
@override
Widget build(BuildContext context) {
  // Marcar como completado
  ref.read(gameScoreNotifierProvider.notifier).completeGame();
  
  // Obtener resumen
  final summary = ref.read(gameScoreNotifierProvider.notifier).getScoreSummary();
  
  return AlertDialog(
    title: Text('¡Felicidades!'),
    content: Text(summary),
    actions: [
      TextButton(
        onPressed: () async {
          // Guardar puntaje
          final saved = await ref.read(gameScoreNotifierProvider.notifier).saveScore(
            playerName: 'Jugador1',
          );
          
          if (saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Puntaje guardado!')),
            );
          }
        },
        child: Text('Guardar Puntaje'),
      ),
    ],
  );
}
```

## Leaderboard (Tabla de Líderes)

### Provider: `leaderboardProvider`

Obtiene los mejores puntajes desde Supabase.

```dart
// Obtener top 10 de todos los tiempos
final leaderboard = ref.watch(leaderboardProvider(limit: 10));

// Obtener top 10 de una categoría específica
final categoryLeaderboard = ref.watch(leaderboardProvider(
  limit: 10,
  categoryId: 'category-id-here',
));
```

### Ejemplo de Widget de Leaderboard

```dart
class LeaderboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider(limit: 10));
    
    return leaderboardAsync.when(
      data: (scores) => ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          final score = scores[index];
          return ListTile(
            leading: Text('#${index + 1}'),
            title: Text(score['player_name'] ?? 'Anónimo'),
            subtitle: Text('${score['correct_words']} palabras'),
            trailing: Text('${score['total_points']} pts'),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## Guardado en Supabase

Los puntajes se guardan automáticamente en la tabla `game_scores` con la siguiente estructura:

```sql
CREATE TABLE game_scores (
  id UUID PRIMARY KEY,
  player_name TEXT,              -- Nombre del jugador (opcional)
  total_points INTEGER,          -- Puntaje total
  correct_words INTEGER,         -- Palabras correctas
  wrong_attempts INTEGER,        -- Intentos incorrectos
  time_elapsed INTEGER,          -- Tiempo en segundos
  found_words TEXT[],            -- Array de palabras encontradas
  start_time TIMESTAMP,          -- Hora de inicio
  end_time TIMESTAMP,            -- Hora de finalización
  category_id UUID,              -- ID de categoría (si aplica)
  category_name TEXT,            -- Nombre de categoría
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Estadísticas del Jugador

Puedes obtener estadísticas agregadas de un jugador usando el servicio de Supabase:

```dart
final stats = await SupabaseService.getPlayerStats('NombreJugador');

// stats contiene:
// {
//   'total_games': 25,
//   'total_points': 5000,
//   'average_points': 200,
//   'best_score': 450,
//   'total_correct_words': 150,
//   'total_wrong_attempts': 30,
//   'average_time': 480  // segundos
// }
```

## Flujo Completo de un Juego

1. **Inicio del juego:**
   ```dart
   ref.read(gameScoreNotifierProvider.notifier).startGame(
     categoryId: selectedCategory?.id,
     categoryName: selectedCategory?.nameEs,
   );
   ```

2. **Durante el juego:**
   ```dart
   // Por cada palabra correcta
   ref.read(gameScoreNotifierProvider.notifier).addCorrectWord(word);
   
   // Por cada intento incorrecto
   ref.read(gameScoreNotifierProvider.notifier).addWrongAttempt();
   ```

3. **Al completar:**
   ```dart
   ref.read(gameScoreNotifierProvider.notifier).completeGame();
   
   // Mostrar resumen
   final summary = ref.read(gameScoreNotifierProvider.notifier).getScoreSummary();
   
   // Guardar (opcional)
   await ref.read(gameScoreNotifierProvider.notifier).saveScore(
     playerName: playerName,
   );
   ```

4. **Nuevo juego:**
   ```dart
   ref.read(gameScoreNotifierProvider.notifier).resetGame();
   ```

## Personalización del Sistema

### Cambiar los puntos por palabra:
Modifica el método `_calculatePointsForWord` en `GameScoreNotifier`:

```dart
int _calculatePointsForWord(String word) {
  final length = word.length;
  if (length <= 3) return 15;  // Cambiado de 10 a 15
  if (length <= 5) return 25;  // Cambiado de 20 a 25
  // etc...
}
```

### Cambiar la penalización:
En el método `addWrongAttempt`:

```dart
void addWrongAttempt() {
  _wrongAttempts++;
  _totalPoints = (_totalPoints - 10).clamp(0, double.infinity).toInt(); // Cambiado de -5 a -10
  ref.invalidateSelf();
}
```

### Cambiar el bonus de completado:
En el método `completeGame`:

```dart
void completeGame() {
  if (_endTime != null) return;
  _endTime = DateTime.now();
  _totalPoints += 300; // Cambiado de 200 a 300
  // ...
}
```

### Cambiar el tiempo objetivo y bonus:
```dart
final timeElapsed = _timeElapsed ?? 0;
if (timeElapsed < 900) { // Cambiado de 600 (10 min) a 900 (15 min)
  final minutesSaved = (900 - timeElapsed) ~/ 60;
  _totalPoints += minutesSaved * 30; // Cambiado de 20 a 30 puntos por minuto
}
```

## Tips de Implementación

1. **Siempre llama a `startGame()` cuando comienza un nuevo crucigrama**
2. **Usa `addCorrectWord()` inmediatamente cuando una palabra sea validada**
3. **Llama a `completeGame()` automáticamente cuando se resuelva el último espacio**
4. **Considera guardar puntajes solo si el jugador completa el crucigrama**
5. **Muestra el puntaje en tiempo real para motivar al jugador**
6. **Implementa un leaderboard para fomentar la competencia**
7. **Permite al jugador ver su historial de puntajes**

## Troubleshooting

**Problema:** Los puntos no se actualizan en la UI
- **Solución:** Asegúrate de estar usando `Consumer` o `ref.watch()` para observar el provider

**Problema:** El puntaje se guarda múltiples veces
- **Solución:** Verifica que `completeGame()` solo se llame una vez (tiene protección contra llamadas múltiples)

**Problema:** El tiempo no se calcula correctamente
- **Solución:** Asegúrate de llamar a `startGame()` al inicio y `completeGame()` al final

**Problema:** Error al guardar en Supabase
- **Solución:** Verifica que la tabla `game_scores` esté creada y que Supabase esté inicializado

## Ejemplo Completo

Ver `SCORE_IMPLEMENTATION_EXAMPLE.md` para un ejemplo completo de integración con los widgets del juego.
