// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/toggle_favorites.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';
import 'package:news_app/features/articles/domain/usecases/get_favorites.dart';

part 'articles_event.dart';
part 'articles_state.dart';

const serverFailureMessage = 'SERVER_FAILURE_MESSAGE';
const invalidUrlFailureMessage = 'INVALID_URL_FAILURE';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  GetArticlesUseCase getArticlesUseCase;
  ToggleFavoritesUseCase addToFavoritesUseCase;
  GetFavoritesUseCase getFavoritesUseCase;
  UrlConverter urlConverter;
  ArticlesBloc(
      {required this.getArticlesUseCase,
      required this.addToFavoritesUseCase,
      required this.getFavoritesUseCase,
      required this.urlConverter})
      : super(const Empty()) {
    on<GetArticlesFromUrlEvent>(getArticlesFromUrlEventHandler);
    on<TogleFavoritesEvent>(toggleFavoritesEventHandler);
  }

  void toggleFavoritesEventHandler(event, emit) async {
    addToFavoritesUseCase(params: CAParams(article: event.article));
  }

  void getArticlesFromUrlEventHandler(event, emit) async {
    final urlEither = urlConverter.toURI(event.url);

    await urlEither.fold((failure) async {
      emit(Error(
          message: invalidUrlFailureMessage,
          activeTabIndex: event.activeTabIndex));
    }, (url) async {
      emit(Loading(activeTabIndex: event.activeTabIndex));
      await _callGetArticlesUseCase(event, url, emit);
    });
  }

  List<Article> getFavorites() {
    final r = getFavoritesUseCase.syncCall(params: NoParams());
    return r;
  }

  FutureOr<void> _callGetArticlesUseCase(event, url, emit) async {
    final articles = await getArticlesUseCase(params: Params(url: url));
    final favorites = getFavorites();

    await articles.fold((failure) async {
      emit(Error(
          message: serverFailureMessage, activeTabIndex: event.activeTabIndex));
    }, (articles) async {
      emit(Loaded(
          articles: articles,
          activeTabIndex: event.activeTabIndex,
          favorites: favorites));
    });
  }
}
