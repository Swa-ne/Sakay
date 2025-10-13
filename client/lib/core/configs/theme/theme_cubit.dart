import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _prefKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final int? idx = prefs.getInt(_prefKey);
    if (idx != null && idx >= 0 && idx < ThemeMode.values.length) {
      emit(ThemeMode.values[idx]);
    } else {
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final ThemeMode mode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, mode.index);
  }

  Future<void> setSystemTheme() async {
    emit(ThemeMode.system);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, ThemeMode.system.index);
  }
}
