import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../services/audio_service.dart';

class StartGameWidget extends ConsumerStatefulWidget {
  const StartGameWidget({super.key});

  @override
  ConsumerState<StartGameWidget> createState() => _StartGameWidgetState();
}

class _StartGameWidgetState extends ConsumerState<StartGameWidget> {
  @override
  void initState() {
    super.initState();
    // Reproducir música del lobby cuando se muestra esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService().playLobbyMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono grande
            Icon(
              Icons.grid_on,
              size: 120,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: 40),
            
            // Título
            Text(
              'Crucigrama',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8),
            
            // Subtítulo
            Text(
              '¡Resuelve el puzzle y gana puntos!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            
            // Botón de inicio
            ElevatedButton(
              onPressed: () {
                // Sonido de clic
                AudioService().playButtonClick();
                
                final selectedCategory = ref.read(selectedCategoryProvider);
                
                // Cambiar a música de partida
                AudioService().playGameMusic();
                
                // Iniciar el juego
                ref.read(gameStartedProvider.notifier).startGame();
                
                // Iniciar el sistema de puntaje
                ref.read(gameScoreNotifierProvider.notifier).startGame(
                  categoryId: selectedCategory?.id,
                  categoryName: selectedCategory?.nameEs,
                );
                
                // Generar un nuevo crucigrama
                ref.invalidate(workQueueProvider);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 24),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'START GAME',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            
            // Información adicional
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.star,
                    color: Colors.amber,
                    text: 'Gana puntos por cada palabra correcta',
                  ),
                  SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.timer,
                    color: Colors.blue,
                    text: 'Completa rápido para bonus de tiempo',
                  ),
                  SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.emoji_events,
                    color: Colors.orange,
                    text: 'Compite en el Top 5 de mejores jugadores',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
