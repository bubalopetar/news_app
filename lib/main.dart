import 'package:flutter/material.dart';
import 'package:news_app/features/articles/presentation/widgets/articles_bloc_wrapper.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ArticlesBlocProvider(),
    );
  }
}
