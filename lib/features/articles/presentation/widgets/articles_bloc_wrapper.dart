// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:news_app/injection_container.dart';
import '../pages/articles_page.dart';

class ArticlesBlocProvider extends StatelessWidget {
  const ArticlesBlocProvider({super.key});

  final String initialUrl = 'https://www.index.hr/rss';

  ArticlesBloc _getArticleBloc() {
    return serviceLocator<ArticlesBloc>()
      ..add(GetArticlesFromUrlEvent(
          url: initialUrl, activeTabIndex: initialActiveTabIndex));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getArticleBloc(),
      child: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          return ArticlesPage(state: state);
        },
      ),
    );
  }
}
