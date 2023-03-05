import 'package:flutter/material.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:news_app/features/articles/presentation/widgets/widgets.dart';
import '../../domain/entities/article.dart';

class ArticlesPage extends StatelessWidget {
  final ArticlesState state;

  const ArticlesPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  List<Article> sortByCategory(List<Article> articles) {
    List<Article> tmp = articles
      ..sort((Article a, Article b) => a.category.compareTo(b.category));
    tmp = tmp.reversed.toList();
    return tmp;
  }

  Widget getBodyForState(ArticlesState state) {
    switch (state.runtimeType) {
      case Empty:
        {
          return const Center(child: CircularProgressIndicator());
        }
      case Loading:
        {
          return const Center(child: CircularProgressIndicator());
        }
      case Loaded:
        {
          state = state as Loaded;
          List<Article> articles = sortByCategory(state.articles);
          return Articles(articles: articles);
        }
      default:
        {
          return const Center(child: Text('error'));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          SourcesNavigationBar(activeTabIndex: state.activeTabIndex!),
      body: getBodyForState(state),
    );
  }
}
