import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class LeaderboardWidget extends ConsumerWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final leaderboardAsync = ref.watch(
      leaderboardProvider(
        limit: 5,
        categoryId: selectedCategory?.id,
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.amber[700],
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top 5 Mejores Puntajes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedCategory != null)
                        Text(
                          'Categoría: ${selectedCategory.nameEs}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.invalidate(leaderboardProvider);
                  },
                  tooltip: 'Actualizar',
                ),
              ],
            ),
            const Divider(height: 24),
            leaderboardAsync.when(
              data: (scores) {
                if (scores.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.leaderboard,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Aún no hay puntajes registrados',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '¡Sé el primero en completar un crucigrama!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (int i = 0; i < scores.length; i++)
                      _LeaderboardItem(
                        rank: i + 1,
                        score: scores[i],
                      ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar puntajes',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  const _LeaderboardItem({
    required this.rank,
    required this.score,
  });

  final int rank;
  final Map<String, dynamic> score;

  @override
  Widget build(BuildContext context) {
    final playerName = score['player_name'] as String? ?? 'Anónimo';
    final totalPoints = score['total_points'] as int? ?? 0;
    final correctWords = score['correct_words'] as int? ?? 0;
    final timeElapsed = score['time_elapsed'] as int?;
    final createdAt = score['created_at'] as String?;

    String formatTime(int? seconds) {
      if (seconds == null) return '--:--';
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    }

    String formatDate(String? dateString) {
      if (dateString == null) return '';
      try {
        final date = DateTime.parse(dateString);
        final now = DateTime.now();
        final difference = now.difference(date);

        if (difference.inDays == 0) {
          return 'Hoy';
        } else if (difference.inDays == 1) {
          return 'Ayer';
        } else if (difference.inDays < 7) {
          return 'Hace ${difference.inDays} días';
        } else {
          return '${date.day}/${date.month}/${date.year}';
        }
      } catch (e) {
        return '';
      }
    }

    Color getRankColor() {
      switch (rank) {
        case 1:
          return Colors.amber[700]!;
        case 2:
          return Colors.grey[400]!;
        case 3:
          return Colors.brown[400]!;
        default:
          return Colors.grey[600]!;
      }
    }

    IconData getRankIcon() {
      switch (rank) {
        case 1:
          return Icons.emoji_events;
        case 2:
          return Icons.emoji_events_outlined;
        case 3:
          return Icons.emoji_events_outlined;
        default:
          return Icons.person;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rank <= 3
            ? getRankColor().withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: rank <= 3 ? getRankColor() : Colors.grey.withOpacity(0.3),
          width: rank == 1 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: getRankColor(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(
                      getRankIcon(),
                      color: Colors.white,
                      size: 24,
                    )
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        playerName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: rank == 1 ? 16 : 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$totalPoints pts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: rank == 1 ? 18 : 16,
                        color: getRankColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      '$correctWords palabras',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.timer, size: 14, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      formatTime(timeElapsed),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDate(createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
