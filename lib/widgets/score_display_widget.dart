import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class ScoreDisplayWidget extends ConsumerWidget {
  const ScoreDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreData = ref.watch(gameScoreNotifierProvider);
    final totalPoints = scoreData['totalPoints'] as int;
    final correctWords = scoreData['correctWords'] as int;
    final wrongAttempts = scoreData['wrongAttempts'] as int;
    final timeElapsed = scoreData['timeElapsed'] as int?;

    String formatTime(int? seconds) {
      if (seconds == null) return '--:--';
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ScoreItem(
              icon: Icons.stars,
              label: 'Puntos',
              value: '$totalPoints',
              color: Colors.amber[700]!,
            ),
            _VerticalDivider(),
            _ScoreItem(
              icon: Icons.check_circle,
              label: 'Correctas',
              value: '$correctWords',
              color: Colors.green[700]!,
            ),
            _VerticalDivider(),
            _ScoreItem(
              icon: Icons.error_outline,
              label: 'Errores',
              value: '$wrongAttempts',
              color: Colors.red[700]!,
            ),
            _VerticalDivider(),
            _ScoreItem(
              icon: Icons.timer,
              label: 'Tiempo',
              value: formatTime(timeElapsed),
              color: Colors.blue[700]!,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
}
