# 🎯 Sistema de Puntaje - Guía Rápida

## ✅ Lo que se ha implementado:

### 1. **Visualización de Puntaje en Tiempo Real**
- **Ubicación**: Barra superior (AppBar)
- **Muestra**:
  - ⭐ Puntaje total
  - ✅ Palabras correctas
  - ❌ Intentos incorrectos

### 2. **Sistema de Puntuación Automático**
- Se registra automáticamente cuando seleccionas una palabra:
  - ✅ **Palabra correcta**: Suma puntos (10-75 según longitud)
  - ❌ **Palabra incorrecta**: Resta 5 puntos

### 3. **Pantalla de Finalización Mejorada**
Cuando completas el crucigrama:
- 🎉 Animación de celebración
- 📊 Resumen completo de estadísticas
- 💾 Opción para guardar puntaje con tu nombre
- 🔄 Botón para iniciar nuevo juego

### 4. **Top 5 de Mejores Puntuaciones**
- **Ubicación**: Botón de trofeo 🏆 en la barra superior
- **Muestra**:
  - Top 5 jugadores con mejores puntajes
  - Medallas (Oro 🥇, Plata 🥈, Bronce 🥉)
  - Información de cada jugador:
    - Nombre
    - Puntaje total
    - Palabras correctas
    - Tiempo empleado
    - Categoría utilizada

### 5. **Filtrado por Categoría**
- El Top 5 se ajusta según la categoría seleccionada
- Puedes ver el ranking global o por categoría específica

## 🚀 Pasos para que funcione completamente:

### Paso 1: Crear tabla en Supabase

Ve a tu proyecto de Supabase → **SQL Editor** y ejecuta:

```sql
-- Crear tabla para guardar puntajes
CREATE TABLE game_scores (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  player_name TEXT,
  total_points INTEGER NOT NULL DEFAULT 0,
  correct_words INTEGER NOT NULL DEFAULT 0,
  wrong_attempts INTEGER NOT NULL DEFAULT 0,
  time_elapsed INTEGER,
  found_words TEXT[] NOT NULL,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  category_id UUID REFERENCES word_categories(id) ON DELETE SET NULL,
  category_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar Row Level Security
ALTER TABLE game_scores ENABLE ROW LEVEL SECURITY;

-- Políticas de acceso
CREATE POLICY "Allow public read access" 
ON game_scores FOR SELECT 
TO public 
USING (true);

CREATE POLICY "Allow public insert access" 
ON game_scores FOR INSERT 
TO public 
WITH CHECK (true);

-- Índices para optimización
CREATE INDEX idx_game_scores_total_points 
ON game_scores(total_points DESC);

CREATE INDEX idx_game_scores_player 
ON game_scores(player_name, created_at DESC);

CREATE INDEX idx_game_scores_category 
ON game_scores(category_id, total_points DESC);

-- Función para estadísticas
CREATE OR REPLACE FUNCTION get_player_stats(p_player_name TEXT)
RETURNS JSON AS $$
SELECT json_build_object(
  'total_games', COUNT(*),
  'total_points', SUM(total_points),
  'average_points', AVG(total_points),
  'best_score', MAX(total_points),
  'total_correct_words', SUM(correct_words),
  'total_wrong_attempts', SUM(wrong_attempts),
  'average_time', AVG(time_elapsed)
)
FROM game_scores
WHERE player_name = p_player_name;
$$ LANGUAGE SQL STABLE;
```

### Paso 2: Agregar categoría Dark Rippers (opcional)

Si aún no lo has hecho:

```sql
INSERT INTO word_categories (name, name_es, words) VALUES
('dark_rippers', 'Dark Rippers', ARRAY['kirito', 'eromechi', 'pablini', 'secuaz', 'niño', 'celismor', 'wesuangelito']);
```

### Paso 3: Ejecutar la app

```bash
flutter run
```

## 🎮 Cómo usar el sistema:

### Durante el juego:
1. **Selecciona palabras** haciendo clic en las celdas
2. **Observa tu puntaje** aumentar en tiempo real en la barra superior
3. El sistema registra automáticamente:
   - Palabras correctas ✅ → Suma puntos
   - Palabras incorrectas ❌ → Resta 5 puntos

### Al completar:
1. Aparecerá una **pantalla de celebración** 🎉
2. Verás tu **puntaje final** y estadísticas
3. Puedes **guardar tu puntaje**:
   - Ingresa tu nombre (opcional)
   - Presiona "Guardar Puntaje"
4. Inicia un **nuevo juego** con el botón "Nuevo Juego"

### Ver el Top 5:
1. Haz clic en el **botón de trofeo** 🏆 en la barra superior
2. Verás las **5 mejores puntuaciones**:
   - 🥇 Medalla de oro para el 1er lugar
   - 🥈 Medalla de plata para el 2do lugar
   - 🥉 Medalla de bronce para el 3er lugar

## 📊 Sistema de Puntos:

| Acción | Puntos |
|--------|--------|
| Palabra de 3 letras | **+10** |
| Palabra de 4-5 letras | **+20** |
| Palabra de 6-7 letras | **+30** |
| Palabra de 8-9 letras | **+50** |
| Palabra de 10+ letras | **+75** |
| Intento incorrecto | **-5** |
| **Completar crucigrama** | **+200** 🎉 |
| **Bonus por tiempo** | **+20 pts/min ahorrado** ⏱️ |

### Bonus por Tiempo:
- Si completas en menos de **10 minutos**
- Ganas **20 puntos extra** por cada minuto que ahorres
- Ejemplo: Completar en 7 minutos = +60 puntos bonus (3 min × 20)

## 🔍 Solución de problemas:

### ❌ No veo el Top 5
**Solución**: Asegúrate de haber creado la tabla `game_scores` en Supabase

### ❌ No se guarda el puntaje
**Soluciones**:
1. Verifica tu conexión a internet
2. Asegura que Supabase esté configurado correctamente
3. Revisa las credenciales en `lib/services/supabase_service.dart`

### ❌ El puntaje no se actualiza
**Solución**: Asegúrate de que `flutter run` esté ejecutándose (reinicia la app)

### ❌ Error al cargar puntuaciones
**Solución**: Verifica que las políticas RLS estén habilitadas en Supabase

## 📱 Capturas de lo implementado:

1. **Barra superior con puntaje**:
   ```
   [🏠] Crucigrama: Frutas    [⭐ 150  ✅ 5  ❌ 2] [🏆] [📁] [⚙️]
   ```

2. **Pantalla de finalización**:
   ```
   ╔═══════════════════════════════╗
   ║         🎉                     ║
   ║     ¡Felicidades!             ║
   ║  Has completado el crucigrama ║
   ║                               ║
   ║    ⭐ 350 puntos               ║
   ║                               ║
   ║  ✅ 8    ❌ 2    ⏱️ 6:45       ║
   ║                               ║
   ║  [Nombre: _________]          ║
   ║  [💾 Guardar] [🔄 Nuevo]      ║
   ╚═══════════════════════════════╝
   ```

3. **Top 5**:
   ```
   ╔════════ Top 5 ════════╗
   ║ 🥇 #1 Juan    ⭐ 450  ║
   ║ 🥈 #2 María   ⭐ 380  ║
   ║ 🥉 #3 Pedro   ⭐ 350  ║
   ║ 🏅 #4 Ana     ⭐ 320  ║
   ║ 🏅 #5 Luis    ⭐ 290  ║
   ╚═══════════════════════╝
   ```

## 🎯 Próximas mejoras sugeridas:

1. ✨ Agregar animaciones cuando se ganan puntos
2. 🔊 Sonidos de victoria/error
3. 📈 Gráficas de progreso del jugador
4. 🏆 Sistema de logros/trofeos
5. 👥 Comparar tu puntaje con amigos
6. 📅 Rankings semanales/mensuales
7. 🎨 Temas visuales desbloqueables

---

## 📚 Documentación completa:

- **`SCORE_SYSTEM_DOCUMENTATION.md`** - Documentación técnica completa
- **`SUPABASE_SETUP.md`** - Configuración de base de datos

¡Disfruta del juego! 🎮
