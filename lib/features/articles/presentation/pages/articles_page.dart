import 'package:flutter/material.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:news_app/features/articles/presentation/widgets/widgets.dart';

class ArticlesPage extends StatelessWidget {
  final ArticlesState state;

  const ArticlesPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  Widget getBodyForState(ArticlesState state) {
    switch (state.runtimeType) {
      case Empty:
        {
          state = state as Empty;
          return Center(child: Text(state.message));
        }
      case Loading:
        {
          return const Center(child: CircularProgressIndicator());
        }
      case Loaded:
        {
          state = state as Loaded;
          return Articles(
            articles: state.articles,
            favorites: state.favorites,
          );
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
