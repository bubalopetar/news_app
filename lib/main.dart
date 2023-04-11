import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/articles/presentation/pages/article_web_view.dart';
import 'package:news_app/features/articles/presentation/widgets/widgets.dart';
import 'core/themes/bloc/theme_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildBasedOnTheme,
      ),
    );
  }

  Widget _buildBasedOnTheme(BuildContext context, ThemeState state) =>
      MaterialApp(
        theme: state.theme,
        routes: {
          WebViewPage.routeName: (context) => const WebViewPage(),
        },
        home: const ArticlesBlocProvider(),
      );
}
