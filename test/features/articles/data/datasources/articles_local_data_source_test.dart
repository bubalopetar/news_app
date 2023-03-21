import 'dart:convert';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/articles/data/datasources/articles_local_data_source.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'articles_local_data_source_test.mocks.dart';

void main() {
  late MockSharedPreferences sharedPreferences;
  late ArticlesLocalDataSource localDataSource;
  final articles = [
    jsonEncode(ArticleModel(
      title: "test title",
      link: "test link",
      description: "test desc",
      img: "test img",
      pubDate: DateTime.parse("2023-03-16T19:26:21.830257"),
      category: "test category",
    ).toJson()),
    jsonEncode(ArticleModel(
      title: "test title2",
      link: "test link2",
      description: "test desc2",
      img: "test img2",
      pubDate: DateTime.parse("2023-03-16T20:26:21.830257"),
      category: "test category2",
    ).toJson()),
  ];
  final article = ArticleModel(
    title: "test title2",
    link: "test link2",
    description: "test desc2",
    img: "test img2",
    pubDate: DateTime.parse("2023-03-16T20:26:21.830257"),
    category: "test category2",
  );
  setUp(
    () {
      sharedPreferences = MockSharedPreferences();
      localDataSource =
          ArticlesLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    },
  );

  group(
    "getCachedArticles",
    () {
      setUp(
        () {
          sharedPreferences = MockSharedPreferences();
          localDataSource =
              ArticlesLocalDataSourceImpl(sharedPreferences: sharedPreferences);
        },
      );
      test(
        "should return a list of Articles from sharedPreferences",
        () {
          when(sharedPreferences.getStringList('favorites')).thenAnswer(
            (realInvocation) => articles,
          );
          final result = localDataSource.getCachedArticles();
          verify(sharedPreferences.getStringList('favorites'));
          expect(result, isA<List<Article>>());
        },
      );

      test(
        "should return [] from sharedPreferences if there are no favorites",
        () {
          when(sharedPreferences.getStringList('favorites')).thenAnswer(
            (realInvocation) => null,
          );
          final result = localDataSource.getCachedArticles();
          verify(sharedPreferences.getStringList('favorites'));
          expect(result, []);
        },
      );
    },
  );

  group(
    "cacheArticle",
    () {
      setUp(
        () {
          sharedPreferences = MockSharedPreferences();
          localDataSource =
              ArticlesLocalDataSourceImpl(sharedPreferences: sharedPreferences);
        },
      );

      test(
        "should return true afer caching Article",
        () async {
          when(sharedPreferences.setStringList('favorites', any)).thenAnswer(
            (realInvocation) async => true,
          );

          final result = await localDataSource.cacheOrRemoveArticle(article);
          verify(sharedPreferences.getStringList('favorites'));

          verify(sharedPreferences.setStringList('favorites', any));
          expect(result, true);
        },
      );
    },
  );
}
