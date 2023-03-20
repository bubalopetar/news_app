import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/usecases.dart';

part 'articles_event.dart';
part 'articles_state.dart';

const serverFailureMessage = 'SERVER_FAILURE_MESSAGE';
const invalidUrlFailureMessage = 'INVALID_URL_FAILURE';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  GetArticlesUseCase getArticlesUseCase;
  ToggleFavoritesUseCase toggleFavoritesUseCase;
  GetFavoritesUseCase getFavoritesUseCase;
  UrlConverter urlConverter;

  ArticlesBloc(
      {required this.getArticlesUseCase,
      required this.toggleFavoritesUseCase,
      required this.getFavoritesUseCase,
      required this.urlConverter})
      : super(const Empty(activeTab: initialActiveTabIndex)) {
    on<GetArticlesFromUrlEvent>(getArticlesFromUrlEventHandler);
    on<TogleFavoritesEvent>(toggleFavoritesEventHandler);
    on<GetFavoritesEvent>(getFavoritesEventHandler);
  }
  /////////////////////

  void getArticlesFromUrlEventHandler(event, emit) async {
    final urlEither = urlConverter.toURI(event.url);

    await urlEither.fold((failure) async {
      emit(Error(
          message: invalidUrlFailureMessage,
          activeTabIndex: event.activeTabIndex));
    }, (url) async {
      emit(Loading(activeTab: event.activeTabIndex));
      await _callGetArticlesUseCase(event, url, emit);
    });
  }

  FutureOr<void> _callGetArticlesUseCase(event, url, emit) async {
    final articles = await getArticlesUseCase(params: Params(url: url));
    final favorites = getFavoritesUseCase(params: NoParams());

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

  //////////////////////

  void toggleFavoritesEventHandler(event, emit) {
    toggleFavoritesUseCase(params: CAParams(article: event.article));
  }

  //////////////////////

  void getFavoritesEventHandler(event, emit) {
    final favorites = getFavoritesUseCase(params: NoParams());

    if (favorites.isEmpty) {
      emit(Empty(activeTab: event.activeTabIndex, message: 'No Favorites'));
    } else {
      emit(Loaded(
          articles: favorites,
          activeTabIndex: event.activeTabIndex,
          favorites: favorites));
    }
  }
}
