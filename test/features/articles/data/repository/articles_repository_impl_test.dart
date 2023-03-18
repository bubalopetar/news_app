import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/features/articles/data/datasources/articles_local_data_source.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/data/repositories/articles_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks(
    [MockSpec<ArticlesRemoteDataSource>(), MockSpec<ArticlesLocalDataSource>()])
import 'articles_repository_impl_test.mocks.dart';

void main() {
  MockArticlesRemoteDataSource articlesRemoteDataSource =
      MockArticlesRemoteDataSource();

  MockArticlesLocalDataSource articlesLocalDataSource =
      MockArticlesLocalDataSource();

  ArticlesRepositoryImpl repository = ArticlesRepositoryImpl(
      remoteDataSource: articlesRemoteDataSource,
      localDataSource: articlesLocalDataSource);

  Uri url = Uri.parse('testUrl');
  List<ArticleModel> articles =
      ArticlesXMLParserImpl().getArticlesFromXML(fixture('articles.xml'));

  ArticleModel article = const ArticleModel(title: 'title', link: 'link');

  setUp(
    () {
      articlesLocalDataSource = MockArticlesLocalDataSource();
      articlesRemoteDataSource = MockArticlesRemoteDataSource();
      repository = ArticlesRepositoryImpl(
          remoteDataSource: articlesRemoteDataSource,
          localDataSource: articlesLocalDataSource);
    },
  );
  group(
    'getArticlesFrom',
    () {
      test(
        'should call datasource.getArticlesFrom and get articles',
        () async {
          when(articlesRemoteDataSource.getArticlesFrom(url: url))
              .thenAnswer((realInvocation) async => articles);
          final response = await repository.getArticlesFrom(url: url);
          verify(articlesRemoteDataSource.getArticlesFrom(url: url));
          expect(response, Right(articles));
        },
      );

      test(
        'should call datasource.getArticlesFrom and get failure if server error',
        () async {
          when(articlesRemoteDataSource.getArticlesFrom(url: url))
              .thenThrow(ServerException());

          final response = await repository.getArticlesFrom(url: url);
          verify(articlesRemoteDataSource.getArticlesFrom(url: url));
          expect(response, Left(ServerFailure()));
        },
      );
    },
  );

  group(
    "cacheArticle",
    () {
      test(
        "should call localDataSource cacheArticleFunction and return true",
        () async {
          when(articlesLocalDataSource.cacheOrRemoveArticle(article))
              .thenAnswer((realInvocation) => Future.value(true));
          final response = await repository.toggleFavorites(article);

          verify(articlesLocalDataSource.cacheOrRemoveArticle(article));
          expect(response, const Right(true));
        },
      );

      test(
        "should return CacheFailure when localDataSource throws an CacheException",
        () async {
          when(articlesLocalDataSource.cacheOrRemoveArticle(article))
              .thenThrow(CacheException());
          final response = await repository.toggleFavorites(article);

          verify(articlesLocalDataSource.cacheOrRemoveArticle(article));
          expect(response, Left(CacheFailure()));
        },
      );
    },
  );

  group(
    "getFavorites",
    () {
      test(
        "should get and return a list of articles from datasource",
        () async {
          when(articlesLocalDataSource.getCachedArticles())
              .thenAnswer((realInvocation) => articles);
          final result = repository.getFavorites();
          expect(result, articles);
        },
      );
      test(
        "should get and return a null from datasource",
        () async {
          when(articlesLocalDataSource.getCachedArticles())
              .thenAnswer((realInvocation) => articles);
          final result = repository.getFavorites();
          expect(result, articles);
        },
      );
    },
  );
}
