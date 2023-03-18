import 'package:flutter/material.dart';
import 'package:news_app/features/articles/presentation/pages/article_web_view.dart';
import 'package:news_app/features/articles/presentation/widgets/widgets.dart';
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
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.black,
        bottomAppBarColor: Colors.grey.shade500,
      ),
      routes: {
        WebViewPage.routeName: (context) => const WebViewPage(),
      },
      title: 'Flutter Demo',
      home: const ArticlesBlocProvider(),
    );
  }
}
