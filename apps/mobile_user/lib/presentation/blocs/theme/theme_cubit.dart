import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  static const String _themeModeKey = 'theme_mode';

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final rawMode = prefs.getString(_themeModeKey);

    if (rawMode == ThemeMode.light.name) {
      emit(ThemeMode.light);
      return;
    }

    if (rawMode == ThemeMode.dark.name) {
      emit(ThemeMode.dark);
      return;
    }

    emit(ThemeMode.dark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
    emit(mode);
  }
}
