import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_provider.g.dart';

@riverpod
SharedPreferences sharedPrefs(Ref ref) {
  // This will be overridden in main.dart
  throw UnimplementedError();
}
