import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../services/audio_service.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';
import 'start_game_widget.dart';

class CrosswordPuzzleApp extends StatelessWidget {
  const CrosswordPuzzleApp({super.key});

  void _showExitConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('¿Salir al menú?'),
          ],
        ),
        content: Text(
          'Tu progreso actual se perderá. ¿Estás seguro que deseas salir?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              AudioService().playButtonClick();
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              AudioService().playButtonClick();
              Navigator.of(context).pop();
              
              // Volver a música del lobby
              AudioService().playLobbyMusic();
              
              // Resetear el juego
              ref.read(gameStartedProvider.notifier).resetGame();
              ref.read(gameScoreNotifierProvider.notifier).resetGame();
              ref.invalidate(workQueueProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          leading: Consumer(
            builder: (context, ref, _) {
              final gameStarted = ref.watch(gameStartedProvider);
              
              // Mostrar botón de salida solo si el juego está activo
              if (gameStarted) {
                return IconButton(
                  icon: Icon(Icons.exit_to_app, size: 20),
                  tooltip: 'Salir al menú',
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showExitConfirmation(context, ref);
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
          actions: [
            _TimerDisplay(),
            SizedBox(width: 4),
            _ScoreDisplay(),
            SizedBox(width: 4),
            _Top5Button(),
            SizedBox(width: 4),
            _CategorySelector(),
            SizedBox(width: 4),
            _CrosswordPuzzleAppMenu(),
            SizedBox(width: 4),
          ],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          title: Consumer(
            builder: (context, ref, _) {
              final selectedCategory = ref.watch(selectedCategoryProvider);
              final gameStarted = ref.watch(gameStartedProvider);
              final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
              
              // Ocultar título en modo vertical cuando hay juego activo para dar más espacio
              if (gameStarted && isPortrait) {
                return SizedBox.shrink();
              }
              
              return Text(
                selectedCategory != null
                    ? 'Crucigrama: ${selectedCategory.nameEs}'
                    : 'Crossword Puzzle',
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final gameStarted = ref.watch(gameStartedProvider);
              
              // Si el juego no ha comenzado, mostrar pantalla de inicio
              if (!gameStarted) {
                return StartGameWidget();
              }
              
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzle = ref.watch(puzzleProvider);
              final puzzleSolved = puzzle.solved;

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty) {
                    return CrosswordPuzzleWidget();
                  }
                  return CrosswordGeneratorWidget();
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('$error')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

class _CategorySelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInternetAsync = ref.watch(hasInternetProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return hasInternetAsync.when(
      data: (hasInternet) {
        if (!hasInternet) {
          return Tooltip(
            message: 'Sin conexión a internet',
            child: IconButton(
              icon: Icon(Icons.wifi_off, color: Colors.grey),
              onPressed: null,
            ),
          );
        }

        return categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return IconButton(
                icon: Icon(Icons.category_outlined),
                onPressed: null,
              );
            }

            return MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => ref.read(selectedCategoryProvider.notifier).clearCategory(),
                  leadingIcon: selectedCategory == null
                      ? Icon(Icons.radio_button_checked_outlined)
                      : Icon(Icons.radio_button_unchecked_outlined),
                  child: Text('Por defecto (todas las palabras)'),
                ),
                Divider(),
                for (final category in categories)
                  MenuItemButton(
                    onPressed: () => ref.read(selectedCategoryProvider.notifier).selectCategory(category),
                    leadingIcon: selectedCategory?.id == category.id
                        ? Icon(Icons.radio_button_checked_outlined)
                        : Icon(Icons.radio_button_unchecked_outlined),
                    child: Text(category.nameEs),
                  ),
              ],
              builder: (context, controller, child) => IconButton(
                onPressed: () => controller.open(),
                icon: Icon(
                  selectedCategory != null ? Icons.category : Icons.category_outlined,
                  color: selectedCategory != null ? Colors.green : null,
                ),
                tooltip: 'Seleccionar categoría',
              ),
            );
          },
          loading: () => IconButton(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            onPressed: null,
          ),
          error: (_, __) => IconButton(
            icon: Icon(Icons.error_outline, color: Colors.red),
            onPressed: null,
          ),
        );
      },
      loading: () => IconButton(
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        onPressed: null,
      ),
      error: (_, __) => IconButton(
        icon: Icon(Icons.wifi_off, color: Colors.grey),
        onPressed: null,
      ),
    );
  }
}

class _CrosswordPuzzleAppMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
    menuChildren: [
      for (final entry in CrosswordSize.values)
        MenuItemButton(
          onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
          leadingIcon: entry == ref.watch(sizeProvider)
              ? Icon(Icons.radio_button_checked_outlined)
              : Icon(Icons.radio_button_unchecked_outlined),
          child: Text(entry.label),
        ),
    ],
    builder: (context, controller, child) => IconButton(
      onPressed: () => controller.open(),
      icon: Icon(Icons.settings),
    ),
  );
}

class _TimerDisplay extends ConsumerStatefulWidget {
  @override
  ConsumerState<_TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends ConsumerState<_TimerDisplay> {
  Timer? _timer;
  int _currentSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Actualizar cada segundo usando un Timer
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTime();
      }
    });
  }

  void _updateTime() {
    final scoreData = ref.read(gameScoreNotifierProvider);
    final startTime = scoreData['startTime'] as DateTime?;
    
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime).inSeconds;
      if (_currentSeconds != elapsed) {
        setState(() {
          _currentSeconds = elapsed;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameStarted = ref.watch(gameStartedProvider);
    
    if (!gameStarted) {
      return SizedBox.shrink();
    }

    final minutes = _currentSeconds ~/ 60;
    final seconds = _currentSeconds % 60;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: Colors.blue),
          SizedBox(width: 4),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreData = ref.watch(gameScoreNotifierProvider);
    final totalPoints = scoreData['totalPoints'] as int;
    final correctWords = scoreData['correctWords'] as int;
    final wrongAttempts = scoreData['wrongAttempts'] as int;
    
    final gameStarted = ref.watch(gameStartedProvider);
    
    if (!gameStarted) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: Colors.amber),
          SizedBox(width: 2),
          Text(
            '$totalPoints',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.check_circle, size: 14, color: Colors.green),
          SizedBox(width: 2),
          Text('$correctWords', style: TextStyle(fontSize: 12)),
          SizedBox(width: 6),
          Icon(Icons.close, size: 14, color: Colors.red),
          SizedBox(width: 2),
          Text('$wrongAttempts', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _Top5Button extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.emoji_events),
      tooltip: 'Top 5 Mejores Puntuaciones',
      onPressed: () {
        // Refrescar leaderboard antes de abrir el diálogo
        ref.invalidate(leaderboardProvider);
        
        showDialog(
          context: context,
          builder: (context) => _Top5Dialog(),
        );
      },
    );
  }
}

class _Top5Dialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider(
      limit: 5,
      categoryId: selectedCategory?.id,
    ));

    // Calcular dimensiones responsivas
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    final dialogWidth = isPortrait ? screenSize.width * 0.9 : screenSize.width * 0.6;
    final dialogHeight = isPortrait ? screenSize.height * 0.6 : screenSize.height * 0.7;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.amber),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedCategory != null
                  ? 'Top 5 - ${selectedCategory.nameEs}'
                  : 'Top 5 - Todas las categorías',
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refrescar',
            onPressed: () {
              ref.invalidate(leaderboardProvider);
            },
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: leaderboardAsync.when(
          data: (scores) {
            if (scores.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay puntuaciones aún',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '¡Sé el primero en completar un crucigrama!',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                final position = index + 1;
                
                Color medalColor = Colors.grey;
                IconData medalIcon = Icons.emoji_events;
                
                if (position == 1) {
                  medalColor = Color(0xFFFFD700); // Oro
                } else if (position == 2) {
                  medalColor = Color(0xFFC0C0C0); // Plata
                } else if (position == 3) {
                  medalColor = Color(0xFFCD7F32); // Bronce
                }

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    dense: isPortrait,
                    leading: CircleAvatar(
                      backgroundColor: medalColor.withOpacity(0.2),
                      child: Icon(
                        medalIcon,
                        color: medalColor,
                        size: isPortrait ? 20 : 24,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '#$position',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isPortrait ? 14 : 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            score['player_name'] ?? 'Jugador Anónimo',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: isPortrait ? 13 : 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              '${score['correct_words']} palabras',
                              style: TextStyle(fontSize: isPortrait ? 11 : 12),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.timer, size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              _formatTime(score['time_elapsed'] ?? 0),
                              style: TextStyle(fontSize: isPortrait ? 11 : 12),
                            ),
                          ],
                        ),
                        if (score['category_name'] != null) ...[
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.category, size: 14, color: Colors.purple),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  score['category_name'],
                                  style: TextStyle(
                                    fontSize: isPortrait ? 10 : 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: isPortrait ? 16 : 20,
                        ),
                        Text(
                          '${score['total_points']}',
                          style: TextStyle(
                            fontSize: isPortrait ? 14 : 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error al cargar puntuaciones'),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      error.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cerrar'),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}
