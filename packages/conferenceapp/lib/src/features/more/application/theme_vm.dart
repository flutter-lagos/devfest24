import 'package:cave/cave.dart';
import 'package:collection/collection.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'theme_state.dart';

final themeVMNotifier = StateNotifierProvider<ThemeViewModel, ThemeState>(
  (ref) => ThemeViewModel(),
);

final class ThemeViewModel extends StateNotifier<ThemeState> {
  final SharedPreferencesAsync _store = SharedPreferencesAsync();

  ThemeViewModel() : super(ThemeState()) {
    _loadTheme();
  }

  void onThemeChange(ThemeMode? theme) {
    final updatedTheme = theme ?? ThemeMode.system;
    _store.setString('theme', updatedTheme.name);
    state = state.copyWith(theme: updatedTheme);
  }

  _loadTheme() async {
    final setTheme = await _store.getString('theme');
    final actualTheme = ThemeMode.values.firstWhereOrNull(
      (theme) => theme.name.toLowerCase() == setTheme?.toLowerCase(),
    );

    state = state.copyWith(theme: actualTheme ?? ThemeMode.system);
  }
}
