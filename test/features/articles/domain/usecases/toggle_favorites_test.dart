import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';

import 'package:news_app/features/articles/domain/usecases/toggle_favorites.dart';

import 'get_articles_test.mocks.dart';

void main() {
  late ToggleFavoritesUseCase setFavoritesUseCase;
  late MockArticlesRepository mockArticlesRepository;

  ArticleModel testArticle = const ArticleModel(link: 'test', title: 'test');

  setUp(
    () {
      mockArticlesRepository = MockArticlesRepository();
      setFavoritesUseCase =
          ToggleFavoritesUseCase(repository: mockArticlesRepository);
    },
  );
  group(
    "cacheArticleUseCase",
    () {
      test(
        "should get true from repository if cached ok",
        () async {
          when(mockArticlesRepository.toggleFavorites(any))
              .thenAnswer((realInvocation) async => const Right(true));
          final result =
              await setFavoritesUseCase(params: CAParams(article: testArticle));

          expect(result, const Right(true));
          verify(mockArticlesRepository.toggleFavorites(testArticle));
          verifyNoMoreInteractions(mockArticlesRepository);
        },
      );

      test(
        "should get a failure from repository if something went wrong",
        () async {
          when(mockArticlesRepository.toggleFavorites(any))
              .thenAnswer((realInvocation) async => Left(CacheFailure()));
          final result =
              await setFavoritesUseCase(params: CAParams(article: testArticle));

          expect(result, Left(CacheFailure()));
          verify(mockArticlesRepository.toggleFavorites(testArticle));
          verifyNoMoreInteractions(mockArticlesRepository);
        },
      );
    },
  );
}
