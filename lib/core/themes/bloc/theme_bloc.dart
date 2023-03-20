import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

AppTheme currentMode() {
  final darkMode = WidgetsBinding.instance.window.platformBrightness;
  if (darkMode == Brightness.dark) {
    return AppTheme.dark;
  } else {
    return AppTheme.light;
  }
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(appThemes[currentMode()]!)) {
    on<ThemeEvent>(changeThemeEventHandler);
  }

  void changeThemeEventHandler(event, emit) {
    emit(ThemeState(appThemes[event.theme]!));
  }
}
