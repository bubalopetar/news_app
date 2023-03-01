import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<http.Client>(), MockSpec<ArticlesXMLParser>()])
import 'articles_remote_data_source_test.mocks.dart';

void main() {
  late ArticlesRemoteDataSourceImpl dataSource;
  late MockClient httpClient;
  late MockArticlesXMLParser xmlParser;
  String xml = fixture('articles.xml');

  void setMockHttpClientSuccess200() {
    when(httpClient.get(any)).thenAnswer((realInvocation) async => Response(
          xml,
          200,
        ));
  }

  setUp(() {
    httpClient = MockClient();
    xmlParser = MockArticlesXMLParser();
    dataSource = ArticlesRemoteDataSourceImpl(
        httpClient: httpClient, articleXMLParser: xmlParser);
  });

  group(
    'getArticlesFrom',
    () {
      final url = Uri.parse('https://www.index.hr/rss');

      test(
        'should perform http request on provided url',
        () async {
          setMockHttpClientSuccess200();
          await dataSource.getArticlesFrom(url: url);
          verify(httpClient.get(url));
        },
      );

      test(
        'should call xmlParser.getArticlesFromXML function',
        () async {
          setMockHttpClientSuccess200();
          await dataSource.getArticlesFrom(url: url);
          verify(xmlParser.getArticlesFromXML(any));
        },
      );

      test(
        'should return a list of articles',
        () async {
          setMockHttpClientSuccess200();
          final articles = await dataSource.getArticlesFrom(url: url);
          expect(articles, isA<List<ArticleModel>>());
        },
      );

      test(
        'should throw a ServerException when server returns anything different from 200',
        () async {
          when(httpClient.get(any))
              .thenAnswer((realInvocation) async => Response(
                    'Not found',
                    404,
                  ));
          expect(() async => await dataSource.getArticlesFrom(url: url),
              throwsA(const TypeMatcher<ServerException>()));
        },
      );
    },
  );
}
