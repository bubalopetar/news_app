import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/domain/usecases/get_favorites.dart';

import 'get_articles_test.mocks.dart';

void main() {
  late GetFavoritesUseCase getFavoritesUseCase;
  late MockArticlesRepository articlesRepository;
  final articles = [
    ArticleModel(
      title: "test title",
      link: "test link",
      description: "test desc",
      img: "test img",
      pubDate: DateTime.parse("2023-03-16T19:26:21.830257"),
      category: "test category",
    ),
    ArticleModel(
      title: "test title2",
      link: "test link2",
      description: "test desc2",
      img: "test img2",
      pubDate: DateTime.parse("2023-03-16T20:26:21.830257"),
      category: "test category2",
    ),
  ];

  group(
    "getFavoritesUseCase",
    () {
      setUp(
        () {
          articlesRepository = MockArticlesRepository();
          getFavoritesUseCase =
              GetFavoritesUseCase(repository: articlesRepository);
        },
      );

      test(
        "should return a list of Articles from repository getFavorites() method",
        () async {
          when(articlesRepository.getFavorites()).thenAnswer((_) => articles);

          final result = getFavoritesUseCase.syncCall(params: NoParams());
          verify(articlesRepository.getFavorites());
          expect(result, articles);
        },
      );

      test(
        "should return a null if repository getFavorites() method returns it",
        () async {
          when(articlesRepository.getFavorites()).thenAnswer((_) => []);

          final result = getFavoritesUseCase.syncCall(params: NoParams());
          verify(articlesRepository.getFavorites());
          expect(result, []);
        },
      );
    },
  );
}
