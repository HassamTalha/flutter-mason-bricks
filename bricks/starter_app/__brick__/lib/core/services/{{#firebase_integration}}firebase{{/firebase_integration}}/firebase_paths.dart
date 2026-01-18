enum FirebaseEnvironment { dev, staging, prod }

FirebaseEnvironment _envFromString(String s) {
  switch (s.toLowerCase()) {
    case 'staging':
    case 'stg':
    case 'stage':
      return FirebaseEnvironment.staging;
    case 'prod':
    case 'production':
      return FirebaseEnvironment.prod;
    default:
      return FirebaseEnvironment.dev;
  }
}

/// Centralized Firebase path constants and builders.
///
/// Read environment from `--dart-define=FIREBASE_ENV=staging|prod|dev` at compile
/// time, or set runtime environment via `FirebasePaths.setEnvironment(...)` in
/// tests or app bootstrap.
class FirebasePaths {
  // Compile-time env (from --dart-define). Defaults to 'dev'.
  static final FirebaseEnvironment _compileTimeEnv = _envFromString(
    const String.fromEnvironment('FIREBASE_ENV', defaultValue: 'dev'),
  );

  // Optional runtime override (useful for tests or runtime switches).
  static FirebaseEnvironment? _runtimeEnv;

  /// Current environment. Runtime override takes precedence.
  static FirebaseEnvironment get environment => _runtimeEnv ?? _compileTimeEnv;

  /// Set environment at runtime (for tests or bootstrap code).
  static void setEnvironment(FirebaseEnvironment env) {
    _runtimeEnv = env;
  }

  /// Clear any runtime override so compile-time env is used again.
  static void clearRuntimeEnvironment() {
    _runtimeEnv = null;
  }

  // Internal prefix mapping. Prod uses no prefix to keep paths stable.
  static String _prefix() {
    switch (environment) {
      case FirebaseEnvironment.dev:
        return 'dev_';
      case FirebaseEnvironment.staging:
        return 'stg_';
      case FirebaseEnvironment.prod:
        return '';
    }
  }

  // --- Collection names (base, unprefixed) ---
  static const String users = 'users';
  static const String posts = 'posts';
  static const String messages = 'messages';
  static const String notifications = 'notifications';

  // --- Storage folders (base, unprefixed) ---
  static const String avatars = 'avatars';
  static const String images = 'images';
  static const String files = 'files';

  // --- Helpers that apply environment prefix ---
  static String collectionPath(String collectionName) =>
      '${_prefix()}$collectionName';

  static String usersCollection() => collectionPath(users);
  static String userDoc(String userId) => '${usersCollection()}/$userId';

  static String postsCollection() => collectionPath(posts);
  static String postDoc(String postId) => '${postsCollection()}/$postId';

  static String messagesCollection() => collectionPath(messages);
  static String messageDoc(String messageId) =>
      '${messagesCollection()}/$messageId';

  // Storage path builders
  static String avatarStorageFolder() => '${_prefix()}$avatars';
  static String avatarStoragePath(
    String userId, [
    String filename = 'avatar.jpg',
  ]) => '${avatarStorageFolder()}/$userId/$filename';

  static String imageStorageFolder() => '${_prefix()}$images';
  static String imageStoragePath(String id, String filename) =>
      '${imageStorageFolder()}/$id/$filename';
}
