import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class PuzzleCompletedWidget extends ConsumerStatefulWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  ConsumerState<PuzzleCompletedWidget> createState() => _PuzzleCompletedWidgetState();
}

class _PuzzleCompletedWidgetState extends ConsumerState<PuzzleCompletedWidget> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // Completar el juego automáticamente cuando se muestra este widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameScoreNotifierProvider.notifier).completeGame();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoreData = ref.watch(gameScoreNotifierProvider);
    final totalPoints = scoreData['totalPoints'] as int;
    final correctWords = scoreData['correctWords'] as int;
    final wrongAttempts = scoreData['wrongAttempts'] as int;
    final timeElapsed = scoreData['timeElapsed'] as int?;

    return Center(
      child: Card(
        margin: EdgeInsets.all(32),
        elevation: 8,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de celebración
                Icon(
                  Icons.celebration,
                  size: 80,
                  color: Colors.amber,
                ),
                SizedBox(height: 16),
                
                // Título
                Text(
                  '¡Felicidades!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Has completado el crucigrama',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                
                // Puntaje principal
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 40),
                      SizedBox(width: 12),
                      Text(
                        '$totalPoints',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'puntos',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Estadísticas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      icon: Icons.check_circle,
                      color: Colors.green,
                      label: 'Palabras',
                      value: '$correctWords',
                    ),
                    _StatItem(
                      icon: Icons.close,
                      color: Colors.red,
                      label: 'Errores',
                      value: '$wrongAttempts',
                    ),
                    _StatItem(
                      icon: Icons.timer,
                      color: Colors.blue,
                      label: 'Tiempo',
                      value: _formatTime(timeElapsed ?? 0),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Campo para nombre del jugador
                if (!_isSaved) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tu nombre (opcional)',
                      hintText: 'Ingresa tu nombre para guardar el puntaje',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                
                // Mensaje de éxito
                if (_isSaved) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '¡Puntaje guardado exitosamente!',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isSaved)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveScore,
                          icon: _isSaving
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(Icons.save),
                          label: Text(_isSaving ? 'Guardando...' : 'Guardar Puntaje'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (!_isSaved) SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _newGame,
                        icon: Icon(Icons.refresh),
                        label: Text('Nuevo Juego'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _saveScore() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final success = await ref.read(gameScoreNotifierProvider.notifier).saveScore(
        playerName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );

      if (success) {
        setState(() {
          _isSaved = true;
        });
        
        // Invalidar el leaderboard para que se actualice
        ref.invalidate(leaderboardProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('¡Puntaje guardado exitosamente!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar el puntaje. Verifica tu conexión.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _newGame() {
    // Resetear el estado de juego iniciado
    ref.read(gameStartedProvider.notifier).resetGame();
    
    // Resetear el puntaje
    ref.read(gameScoreNotifierProvider.notifier).resetGame();
    
    // Invalidar el workQueue para generar un nuevo crucigrama
    ref.invalidate(workQueueProvider);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
