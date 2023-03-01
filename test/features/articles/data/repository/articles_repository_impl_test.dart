import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/data/repositories/articles_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<ArticlesRemoteDataSource>()])
import 'articles_repository_impl_test.mocks.dart';

void main() {
  MockArticlesRemoteDataSource mockArticlesRemoteDataSource =
      MockArticlesRemoteDataSource();
  ArticleRepositoryImpl repository =
      ArticleRepositoryImpl(remoteDataSource: mockArticlesRemoteDataSource);
  Uri url = Uri.parse('testUrl');
  List<ArticleModel> articles =
      ArticlesXMLParserImpl().getArticlesFromXML(fixture('articles.xml'));

  setUp(
    () {
      mockArticlesRemoteDataSource = MockArticlesRemoteDataSource();
      repository =
          ArticleRepositoryImpl(remoteDataSource: mockArticlesRemoteDataSource);
    },
  );
  group(
    'getArticlesFrom',
    () {
      test(
        'should call datasource.getArticlesFrom and get articles',
        () async {
          when(mockArticlesRemoteDataSource.getArticlesFrom(url: url))
              .thenAnswer((realInvocation) async => articles);
          final response = await repository.getArticlesFrom(url: url);
          verify(mockArticlesRemoteDataSource.getArticlesFrom(url: url));
          expect(response, Right(articles));
        },
      );

      test(
        'should call datasource.getArticlesFrom and get failure if server error',
        () async {
          when(mockArticlesRemoteDataSource.getArticlesFrom(url: url))
              .thenThrow(ServerException());

          final response = await repository.getArticlesFrom(url: url);
          verify(mockArticlesRemoteDataSource.getArticlesFrom(url: url));
          expect(response, Left(ServerFailure()));
        },
      );
    },
  );
}
