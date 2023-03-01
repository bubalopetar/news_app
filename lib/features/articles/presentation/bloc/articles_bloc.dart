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
      : super(Empty()) {
    on<GetArticlesFromUrlEvent>(getArticlesFromUrlEventHandler);
  }

  void getArticlesFromUrlEventHandler(event, emit) async {
    final urlEither = urlConverter.toURI(event.url);
    urlEither.fold((failure) {
      emit(const Error(message: invalidUrlFailureMessage));
    }, (url) {
      emit(Loading());
      _callUseCase(url, emit);
    });
  }

  FutureOr<void> _callUseCase(url, emit) async {
    final articles = await usecase(params: Params(url: url));
    articles.fold((failure) {
      emit(const Error(message: serverFailureMessage));
    }, (articles) {
      emit(Loaded(articles: articles));
    });
  }
}
