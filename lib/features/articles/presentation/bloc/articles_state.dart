// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'articles_bloc.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Empty extends ArticlesState {}

class Loading extends ArticlesState {}

class Loaded extends ArticlesState {
  final List<Article> articles;
  const Loaded({
    required this.articles,
  });
  @override
  List<Object> get props => [articles];
}

class Error extends ArticlesState {
  final String message;
  const Error({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
