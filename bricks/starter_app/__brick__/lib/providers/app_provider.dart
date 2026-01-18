import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:statetest/core/config/constants.dart';
import 'package:statetest/providers/shared_preference_provider.dart';

part 'app_provider.g.dart';

final appTheme = {
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
  'system': ThemeMode.system,
};

@Riverpod(keepAlive: true)
class AppConfig extends _$AppConfig {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    String? savedTheme = prefs.getString(Constants.themeKey);
    return appTheme[savedTheme] ?? ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPrefsProvider).setString(Constants.themeKey, mode.name);
  }
}
