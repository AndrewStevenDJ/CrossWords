# Configuración de Variables de Entorno

## 🔐 Seguridad

Este proyecto utiliza variables de entorno para proteger información sensible como credenciales de Supabase.

## 📋 Configuración Inicial

### 1. Copia el archivo de ejemplo

```bash
cp .env.example .env
```

### 2. Edita el archivo `.env` con tus credenciales reales

Abre `.env` y reemplaza los valores de ejemplo:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_clave_anonima_aqui
```

### 3. Obtén tus credenciales de Supabase

1. Ve a [supabase.com](https://supabase.com)
2. Abre tu proyecto
3. Ve a **Settings** → **API**
4. Copia:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

## ⚠️ IMPORTANTE

### ❌ NO subas el archivo `.env` a Git

El archivo `.env` está incluido en `.gitignore` para evitar que las credenciales se suban al repositorio público.

**Archivos protegidos:**
- ✅ `.env` - Ignorado por Git (contiene credenciales reales)
- ✅ `.env.example` - Plantilla sin credenciales (SÍ se sube a Git)

### 🔍 Verifica antes de hacer commit

Antes de hacer `git push`, verifica que `.env` NO esté en los archivos modificados:

```bash
git status
```

Si ves `.env` en la lista, **NO hagas commit**. Verifica tu `.gitignore`.

## 🚀 Uso en la Aplicación

Las variables de entorno se cargan automáticamente al iniciar la app en `main.dart`:

```dart
await dotenv.load(fileName: ".env");
```

Y se acceden en `SupabaseService`:

```dart
static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
```

## 🛠️ Solución de Problemas

### Error: "No se pudo cargar el archivo .env"

1. Verifica que el archivo `.env` exista en la raíz del proyecto
2. Verifica que `.env` esté listado en `pubspec.yaml` bajo `assets:`

```yaml
flutter:
  assets:
    - .env
```

3. Ejecuta `flutter pub get` después de modificar `pubspec.yaml`
4. Haz un hot restart completo (`R` en la terminal de Flutter)

### La app funciona sin .env

La aplicación está configurada para funcionar en **modo offline** si no encuentra el archivo `.env`:

- ✅ Los crucigramas locales funcionan normalmente
- ❌ No se puede guardar puntajes en Supabase
- ❌ No se puede ver el Top 5 online
- ❌ No se pueden usar categorías personalizadas de Supabase

## 📦 Despliegue

### Para desarrollo local
- Usa tu propio archivo `.env` con tus credenciales de Supabase

### Para producción
- Configura las variables de entorno en tu plataforma de hosting
- **Nunca** incluyas credenciales en el código fuente

### Para compartir con tu equipo
1. Comparte el archivo `.env.example` (sin credenciales)
2. Cada desarrollador debe crear su propio `.env` localmente
3. Comparte las credenciales por un canal seguro (no por Git)

## 🔑 Variables Disponibles

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `SUPABASE_URL` | URL de tu proyecto Supabase | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Clave pública/anónima de Supabase | `eyJhbGciOiJIUzI1NiIs...` |

## 📚 Referencias

- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) - Documentación del paquete
- [Supabase Flutter](https://supabase.com/docs/guides/getting-started/quickstarts/flutter) - Guía oficial
- [12 Factor App - Config](https://12factor.net/config) - Mejores prácticas
