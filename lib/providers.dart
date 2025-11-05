import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isolates.dart';
import 'model.dart' as model;
import 'models/category.dart';
import 'services/connectivity_service.dart';
import 'services/supabase_service.dart';

part 'providers.g.dart';

const backgroundWorkerCount = 4;

/// A provider for the wordlist to use when generating the crossword.
@riverpod
Future<BuiltSet<String>> wordList(WordListRef ref) async {
  // This codebase requires that all words consist of lowercase characters
  // in the range 'a'-'z'. Words containing uppercase letters will be
  // lowercased, and words containing runes outside this range will
  // be removed.

  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');
  return const LineSplitter()
      .convert(words)
      .toBuiltSet()
      .rebuild(
        (b) => b
          ..map((word) => word.toLowerCase().trim())
          ..where((word) => word.length > 2)
          ..where((word) => re.hasMatch(word)),
      );
}

/// An enumeration for different sizes of [model.Crossword]s.
enum CrosswordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrosswordSize({required this.width, required this.height});

  final int width;
  final int height;
  String get label => '$width x $height';
}

/// A provider that holds the current size of the crossword to generate.
@Riverpod(keepAlive: true)
class Size extends _$Size {
  var _size = CrosswordSize.small;

  @override
  CrosswordSize build() => _size;

  void setSize(CrosswordSize size) {
    _size = size;
    ref.invalidateSelf();
  }
}

@riverpod
Stream<model.WorkQueue> workQueue(WorkQueueRef ref) async* {
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(categoryWordListProvider);
  final emptyCrossword = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );
  final emptyWorkQueue = model.WorkQueue.from(
    crossword: emptyCrossword,
    candidateWords: BuiltSet<String>(),
    startLocation: model.Location.at(0, 0),
  );

  yield* wordListAsync.when(
    data: (wordList) => exploreCrosswordSolutions(
      crossword: emptyCrossword,
      wordList: wordList,
      maxWorkerCount: backgroundWorkerCount,
    ),
    error: (error, stackTrace) async* {
      debugPrint('Error loading word list: $error');
      yield emptyWorkQueue;
    },
    loading: () async* {
      yield emptyWorkQueue;
    },
  );
}

@Riverpod(keepAlive: true)
class Puzzle extends _$Puzzle {
  model.CrosswordPuzzleGame _puzzle = model.CrosswordPuzzleGame.from(
    crossword: model.Crossword.crossword(width: 0, height: 0),
    candidateWords: BuiltSet<String>(),
  );

  @override
  model.CrosswordPuzzleGame build() {
    final size = ref.watch(sizeProvider);
    final wordList = ref.watch(categoryWordListProvider).value;
    final workQueue = ref.watch(workQueueProvider).value;

    if (wordList != null &&
        workQueue != null &&
        workQueue.isCompleted &&
        (_puzzle.crossword.height != size.height ||
            _puzzle.crossword.width != size.width ||
            _puzzle.crossword != workQueue.crossword)) {
      compute(_puzzleFromCrosswordTrampoline, (
        workQueue.crossword,
        wordList,
      )).then((puzzle) {
        _puzzle = puzzle;
        ref.invalidateSelf();
      });
    }

    return _puzzle;
  }

  Future<void> selectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) async {
    final candidate = await compute(_puzzleSelectWordTrampoline, (
      _puzzle,
      location,
      word,
      direction,
    ));

    if (candidate != null) {
      _puzzle = candidate;
      ref.invalidateSelf();
    } else {
      debugPrint('Invalid word selection: $word');
    }
  }

  bool canSelectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) {
    return _puzzle.canSelectWord(
      location: location,
      word: word,
      direction: direction,
    );
  }
}

// Trampoline functions to disentangle these Isolate target calls from the
// unsendable reference to the [Puzzle] provider.

Future<model.CrosswordPuzzleGame> _puzzleFromCrosswordTrampoline(
  (model.Crossword, BuiltSet<String>) args,
) async =>
    model.CrosswordPuzzleGame.from(crossword: args.$1, candidateWords: args.$2);

model.CrosswordPuzzleGame? _puzzleSelectWordTrampoline(
  (model.CrosswordPuzzleGame, model.Location, String, model.Direction) args,
) => args.$1.selectWord(location: args.$2, word: args.$3, direction: args.$4);

// ==================== CONNECTIVITY & CATEGORIES ====================

/// Provider que verifica si hay conexión a internet
@riverpod
Future<bool> hasInternet(HasInternetRef ref) async {
  return await ConnectivityService.hasInternetConnection();
}

/// Provider que obtiene las categorías disponibles desde Supabase
@riverpod
Future<List<WordCategory>> categories(CategoriesRef ref) async {
  final hasInternet = await ref.watch(hasInternetProvider.future);
  
  if (!hasInternet) {
    return [];
  }

  try {
    return await SupabaseService.getCategories();
  } catch (e) {
    debugPrint('Error loading categories: $e');
    return [];
  }
}

/// Provider que mantiene la categoría seleccionada actualmente
@Riverpod(keepAlive: true)
class SelectedCategory extends _$SelectedCategory {
  WordCategory? _category;

  @override
  WordCategory? build() => _category;

  void selectCategory(WordCategory? category) {
    _category = category;
    ref.invalidateSelf();
    // Invalidar el workQueue para regenerar con la nueva categoría
    ref.invalidate(workQueueProvider);
  }

  void clearCategory() {
    _category = null;
    ref.invalidateSelf();
    ref.invalidate(workQueueProvider);
  }
}

/// Provider modificado del wordList que considera la categoría seleccionada
@riverpod
Future<BuiltSet<String>> categoryWordList(CategoryWordListRef ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  // Si hay una categoría seleccionada, usar sus palabras
  if (selectedCategory != null) {
    return selectedCategory.words;
  }
  
  // Si no, usar el wordList por defecto
  return ref.watch(wordListProvider.future);
}

/// Provider para manejar el sistema de puntaje
@Riverpod(keepAlive: true)
class GameScoreNotifier extends _$GameScoreNotifier {
  int _totalPoints = 0;
  int _correctWords = 0;
  int _wrongAttempts = 0;
  DateTime? _startTime;
  DateTime? _endTime;
  List<String> _foundWords = [];
  String? _categoryId;
  String? _categoryName;

  @override
  Map<String, dynamic> build() {
    return {
      'totalPoints': _totalPoints,
      'correctWords': _correctWords,
      'wrongAttempts': _wrongAttempts,
      'startTime': _startTime,
      'endTime': _endTime,
      'foundWords': _foundWords,
      'categoryId': _categoryId,
      'categoryName': _categoryName,
      'timeElapsed': _timeElapsed,
    };
  }

  int? get _timeElapsed {
    if (_startTime == null) return null;
    final endTime = _endTime ?? DateTime.now();
    return endTime.difference(_startTime!).inSeconds;
  }

  void startGame({String? categoryId, String? categoryName}) {
    _totalPoints = 0;
    _correctWords = 0;
    _wrongAttempts = 0;
    _startTime = DateTime.now();
    _endTime = null;
    _foundWords = [];
    _categoryId = categoryId;
    _categoryName = categoryName;
    ref.invalidateSelf();
  }

  void resetGame() {
    _totalPoints = 0;
    _correctWords = 0;
    _wrongAttempts = 0;
    _startTime = null;
    _endTime = null;
    _foundWords = [];
    _categoryId = null;
    _categoryName = null;
    ref.invalidateSelf();
  }

  void addCorrectWord(String word) {
    if (_foundWords.contains(word)) return;
    _foundWords.add(word);
    _correctWords++;
    final points = _calculatePointsForWord(word);
    _totalPoints += points;
    ref.invalidateSelf();
  }

  void addWrongAttempt() {
    _wrongAttempts++;
    _totalPoints = (_totalPoints - 5).clamp(0, double.infinity).toInt();
    ref.invalidateSelf();
  }

  void completeGame() {
    if (_endTime != null) return;
    _endTime = DateTime.now();
    _totalPoints += 200;
    final timeElapsed = _timeElapsed ?? 0;
    if (timeElapsed < 600) {
      final minutesSaved = (600 - timeElapsed) ~/ 60;
      _totalPoints += minutesSaved * 20;
    }
    ref.invalidateSelf();
  }

  int _calculatePointsForWord(String word) {
    final length = word.length;
    if (length <= 3) return 10;
    if (length <= 5) return 20;
    if (length <= 7) return 30;
    if (length <= 9) return 50;
    return 75;
  }

  Future<bool> saveScore({String? playerName}) async {
    if (_endTime == null) completeGame();
    try {
      final scoreData = {
        'total_points': _totalPoints,
        'correct_words': _correctWords,
        'wrong_attempts': _wrongAttempts,
        'time_elapsed': _timeElapsed,
        'found_words': _foundWords,
        'start_time': _startTime?.toIso8601String(),
        'end_time': _endTime?.toIso8601String(),
        'category_id': _categoryId,
        'category_name': _categoryName,
      };
      return await SupabaseService.saveScore(scoreData: scoreData, playerName: playerName);
    } catch (e) {
      debugPrint('Error saving score: $e');
      return false;
    }
  }

  String getScoreSummary() {
    return 'Puntaje Total: $_totalPoints puntos\nPalabras Correctas: $_correctWords\nIntentos Incorrectos: $_wrongAttempts\nTiempo: ${_formatTime(_timeElapsed ?? 0)}';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

@riverpod
Future<List<Map<String, dynamic>>> leaderboard(LeaderboardRef ref, {int limit = 10, String? categoryId}) async {
  try {
    return await SupabaseService.getTopScores(limit: limit, categoryId: categoryId);
  } catch (e) {
    debugPrint('Error loading leaderboard: $e');
    return [];
  }
}

/// Provider para controlar si el juego ha comenzado
@Riverpod(keepAlive: true)
class GameStarted extends _$GameStarted {
  @override
  bool build() => false;

  void startGame() {
    state = true;
  }

  void resetGame() {
    state = false;
  }
}
