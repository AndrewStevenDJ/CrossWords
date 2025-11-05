import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/supabase_service.dart';
import 'widgets/crossword_puzzle_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno desde .env
  try {
    await dotenv.load(fileName: ".env");
    print('✓ Variables de entorno cargadas correctamente');
  } catch (e) {
    print('⚠️ Advertencia: No se pudo cargar el archivo .env: $e');
    print('   La aplicación continuará sin conexión a Supabase');
  }
  
  // Inicializar Supabase
  try {
    await SupabaseService.initialize();
    print('✓ Supabase inicializado correctamente');
  } catch (e) {
    print('⚠️ Error inicializando Supabase: $e');
    print('   La aplicación continuará en modo offline');
  }
  
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Crossword Puzzle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        home: const CrosswordPuzzleApp(),
      ),
    ),
  );
}
