// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'articles_bloc.dart';

const int initialActiveTabIndex = 0;
const String initialUrl = 'https://www.index.hr/rss';

abstract class ArticlesState extends Equatable {
  final int? activeTabIndex;
  const ArticlesState(this.activeTabIndex, [List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Empty extends ArticlesState {
  final String message;
  final int? activeTab = initialActiveTabIndex;

  const Empty({activeTab, this.message = ''}) : super(activeTab);
}

class Loading extends ArticlesState {
  final int? activeTab = initialActiveTabIndex;
  const Loading({activeTab}) : super(activeTab);
  @override
  List<Object> get props => [];
}

class Loaded extends ArticlesState {
  final List<Article> articles;
  final List<Article> favorites;

  const Loaded(
      {activeTabIndex, required this.articles, required this.favorites})
      : super(activeTabIndex);
  @override
  List<Object> get props => [articles];
}

class Error extends ArticlesState {
  final String message;
  const Error({
    activeTabIndex,
    required this.message,
  }) : super(activeTabIndex);
  @override
  List<Object> get props => [message];
}
