// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetArticlesFromUrlEvent extends ArticlesEvent {
  final String url;
  final int? activeTabIndex;
  GetArticlesFromUrlEvent({
    required this.url,
    this.activeTabIndex,
  }) : super([url]);
}

class TogleFavoritesEvent extends ArticlesEvent {
  final Article article;

  const TogleFavoritesEvent(this.article);
}

class GetFavoritesEvent extends ArticlesEvent {
  final int? activeTabIndex;

  const GetFavoritesEvent({this.activeTabIndex});
}
