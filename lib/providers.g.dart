// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListHash() => r'8e3e9cd4555ba4baa045ccddd8dd45a25cfb6653';

/// A provider for the wordlist to use when generating the crossword.
///
/// Copied from [wordList].
@ProviderFor(wordList)
final wordListProvider = AutoDisposeFutureProvider<BuiltSet<String>>.internal(
  wordList,
  name: r'wordListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$workQueueHash() => r'0c5c8904ff41e4a3f1c1894102a51fe225900ec3';

/// See also [workQueue].
@ProviderFor(workQueue)
final workQueueProvider = AutoDisposeStreamProvider<model.WorkQueue>.internal(
  workQueue,
  name: r'workQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkQueueRef = AutoDisposeStreamProviderRef<model.WorkQueue>;
String _$hasInternetHash() => r'eaf90340ebe8d2495f620d796d261a9c7e9532b2';

/// Provider que verifica si hay conexión a internet
///
/// Copied from [hasInternet].
@ProviderFor(hasInternet)
final hasInternetProvider = AutoDisposeFutureProvider<bool>.internal(
  hasInternet,
  name: r'hasInternetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasInternetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasInternetRef = AutoDisposeFutureProviderRef<bool>;
String _$categoriesHash() => r'f66e2b3919ccc7150e006e5c5b2e45befb430694';

/// Provider que obtiene las categorías disponibles desde Supabase
///
/// Copied from [categories].
@ProviderFor(categories)
final categoriesProvider =
    AutoDisposeFutureProvider<List<WordCategory>>.internal(
      categories,
      name: r'categoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<WordCategory>>;
String _$categoryWordListHash() => r'f0ee1a1ff11485ad588cdbe77b18294f79335588';

/// Provider modificado del wordList que considera la categoría seleccionada
///
/// Copied from [categoryWordList].
@ProviderFor(categoryWordList)
final categoryWordListProvider =
    AutoDisposeFutureProvider<BuiltSet<String>>.internal(
      categoryWordList,
      name: r'categoryWordListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryWordListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryWordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$leaderboardHash() => r'3cdc8f54a3f91649b4e2276f492f172891a45069';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [leaderboard].
@ProviderFor(leaderboard)
const leaderboardProvider = LeaderboardFamily();

/// See also [leaderboard].
class LeaderboardFamily extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [leaderboard].
  const LeaderboardFamily();

  /// See also [leaderboard].
  LeaderboardProvider call({int limit = 10, String? categoryId}) {
    return LeaderboardProvider(limit: limit, categoryId: categoryId);
  }

  @override
  LeaderboardProvider getProviderOverride(
    covariant LeaderboardProvider provider,
  ) {
    return call(limit: provider.limit, categoryId: provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'leaderboardProvider';
}

/// See also [leaderboard].
class LeaderboardProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [leaderboard].
  LeaderboardProvider({int limit = 10, String? categoryId})
    : this._internal(
        (ref) => leaderboard(
          ref as LeaderboardRef,
          limit: limit,
          categoryId: categoryId,
        ),
        from: leaderboardProvider,
        name: r'leaderboardProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$leaderboardHash,
        dependencies: LeaderboardFamily._dependencies,
        allTransitiveDependencies: LeaderboardFamily._allTransitiveDependencies,
        limit: limit,
        categoryId: categoryId,
      );

  LeaderboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.categoryId,
  }) : super.internal();

  final int limit;
  final String? categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(LeaderboardRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LeaderboardProvider._internal(
        (ref) => create(ref as LeaderboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _LeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeaderboardProvider &&
        other.limit == limit &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LeaderboardRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _LeaderboardProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with LeaderboardRef {
  _LeaderboardProviderElement(super.provider);

  @override
  int get limit => (origin as LeaderboardProvider).limit;
  @override
  String? get categoryId => (origin as LeaderboardProvider).categoryId;
}

String _$sizeHash() => r'6ece68b4e628680963f11e0885d044cfa64b18fc';

/// A provider that holds the current size of the crossword to generate.
///
/// Copied from [Size].
@ProviderFor(Size)
final sizeProvider = NotifierProvider<Size, CrosswordSize>.internal(
  Size.new,
  name: r'sizeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Size = Notifier<CrosswordSize>;
String _$puzzleHash() => r'48dd9d9fa4fa37a94f5b64f718eb5fce834fa015';

/// See also [Puzzle].
@ProviderFor(Puzzle)
final puzzleProvider =
    NotifierProvider<Puzzle, model.CrosswordPuzzleGame>.internal(
      Puzzle.new,
      name: r'puzzleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$puzzleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Puzzle = Notifier<model.CrosswordPuzzleGame>;
String _$selectedCategoryHash() => r'cba542b4a62c6fa710b8d49efb3ab6e8cb389510';

/// Provider que mantiene la categoría seleccionada actualmente
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, WordCategory?>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = Notifier<WordCategory?>;
String _$gameScoreNotifierHash() => r'395d19f8ce5a1a274597f9fafdd58dd92aeb1cf6';

/// Provider para manejar el sistema de puntaje
///
/// Copied from [GameScoreNotifier].
@ProviderFor(GameScoreNotifier)
final gameScoreNotifierProvider =
    NotifierProvider<GameScoreNotifier, Map<String, dynamic>>.internal(
      GameScoreNotifier.new,
      name: r'gameScoreNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameScoreNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameScoreNotifier = Notifier<Map<String, dynamic>>;
String _$gameStartedHash() => r'195fa63406c88f84a65986cf2497a6f7bda82ac2';

/// Provider para controlar si el juego ha comenzado
///
/// Copied from [GameStarted].
@ProviderFor(GameStarted)
final gameStartedProvider = NotifierProvider<GameStarted, bool>.internal(
  GameStarted.new,
  name: r'gameStartedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameStartedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameStarted = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
