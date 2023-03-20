import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/themes/app_themes.dart';
import 'package:news_app/core/themes/bloc/theme_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeBloc bloc = ThemeBloc();

  group(
    "ChangeThemeEvent",
    () {
      test(
        "should emit ThemeState with selected theme",
        () {
          const theme = AppTheme.light;
          expectLater(
              bloc.stream.asBroadcastStream(),
              emitsInOrder([
                ThemeState(appThemes[theme]!),
              ]));
          bloc.add(const ChangeThemeEvent(theme));
        },
      );
    },
  );
}
