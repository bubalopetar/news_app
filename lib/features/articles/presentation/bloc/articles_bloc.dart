// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';

part 'articles_event.dart';
part 'articles_state.dart';

const serverFailureMessage = 'SERVER_FAILURE_MESSAGE';
const invalidUrlFailureMessage = 'INVALID_URL_FAILURE';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  GetArticlesUseCase usecase;
  UrlConverter urlConverter;
  ArticlesBloc({required this.usecase, required this.urlConverter})
      : super(const Empty()) {
    on<GetArticlesFromUrlEvent>(getArticlesFromUrlEventHandler);
  }

  void getArticlesFromUrlEventHandler(event, emit) async {
    final urlEither = urlConverter.toURI(event.url);

    await urlEither.fold((failure) async {
      emit(Error(
          message: invalidUrlFailureMessage,
          activeTabIndex: event.activeTabIndex));
    }, (url) async {
      emit(Loading(activeTabIndex: event.activeTabIndex));
      await _callUseCase(event, url, emit);
    });
  }

  FutureOr<void> _callUseCase(event, url, emit) async {
    final articles = await usecase(params: Params(url: url));

    await articles.fold((failure) async {
      emit(Error(
          message: serverFailureMessage, activeTabIndex: event.activeTabIndex));
    }, (articles) async {
      emit(Loaded(articles: articles, activeTabIndex: event.activeTabIndex));
    });
  }
}
