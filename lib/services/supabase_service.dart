import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://vespnopipzsllnvbnzbq.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlc3Bub3BpcHpzbGxudmJuemJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NjI5NDEsImV4cCI6MjA3NzMzODk0MX0.2ddxfqlmdivgti8hXw5e6mQR5Avg5CRZjaia7pbePtk';

  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase no ha sido inicializado. Llama a initialize() primero.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// Obtiene todas las categorías de palabras desde Supabase
  static Future<List<WordCategory>> getCategories() async {
    try {
      final response = await client
          .from('word_categories')
          .select()
          .order('name_es');

      final categories = (response as List)
          .map((json) => WordCategory.fromJson(json))
          .toList();

      return categories;
    } catch (e) {
      print('Error obteniendo categorías: $e');
      return [];
    }
  }

  /// Obtiene una categoría específica por ID
  static Future<WordCategory?> getCategoryById(String id) async {
    try {
      final response = await client
          .from('word_categories')
          .select()
          .eq('id', id)
          .single();

      return WordCategory.fromJson(response);
    } catch (e) {
      print('Error obteniendo categoría: $e');
      return null;
    }
  }

  /// Guarda un crucigrama generado en Supabase
  static Future<bool> saveCrossword({
    required String categoryId,
    required Map<String, dynamic> crosswordData,
  }) async {
    try {
      await client.from('saved_crosswords').insert({
        'category_id': categoryId,
        'crossword_data': crosswordData,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error guardando crucigrama: $e');
      return false;
    }
  }

  /// Obtiene crucigramas guardados de una categoría
  static Future<List<Map<String, dynamic>>> getSavedCrosswords(
      String categoryId) async {
    try {
      final response = await client
          .from('saved_crosswords')
          .select()
          .eq('category_id', categoryId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obteniendo crucigramas guardados: $e');
      return [];
    }
  }

  /// Guarda un puntaje en Supabase
  static Future<bool> saveScore({
    required Map<String, dynamic> scoreData,
    String? playerName,
  }) async {
    try {
      await client.from('game_scores').insert({
        ...scoreData,
        if (playerName != null) 'player_name': playerName,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error guardando puntaje: $e');
      return false;
    }
  }

  /// Obtiene los mejores puntajes (leaderboard)
  static Future<List<Map<String, dynamic>>> getTopScores({
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      var query = client
          .from('game_scores')
          .select('*, word_categories(name_es)');

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final response = await query
          .order('total_points', ascending: false)
          .limit(limit);

      // Transformar la respuesta para incluir el nombre de categoría
      final scores = List<Map<String, dynamic>>.from(response);
      return scores.map((score) {
        final categoryData = score['word_categories'];
        return {
          ...score,
          'category_name': categoryData != null ? categoryData['name_es'] : null,
        };
      }).toList();
    } catch (e) {
      print('Error obteniendo mejores puntajes: $e');
      print('Detalles del error: ${e.toString()}');
      return [];
    }
  }

  /// Obtiene el historial de puntajes de un jugador
  static Future<List<Map<String, dynamic>>> getPlayerScores(
    String playerName, {
    int limit = 20,
  }) async {
    try {
      final response = await client
          .from('game_scores')
          .select()
          .eq('player_name', playerName)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obteniendo puntajes del jugador: $e');
      return [];
    }
  }

  /// Obtiene estadísticas generales de un jugador
  static Future<Map<String, dynamic>?> getPlayerStats(String playerName) async {
    try {
      final response = await client.rpc('get_player_stats', params: {
        'p_player_name': playerName,
      });

      return response as Map<String, dynamic>?;
    } catch (e) {
      print('Error obteniendo estadísticas del jugador: $e');
      return null;
    }
  }
}
