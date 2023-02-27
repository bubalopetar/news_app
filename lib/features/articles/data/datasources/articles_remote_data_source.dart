// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:http/http.dart' as http;

abstract class ArticlesRemoteDataSource {
  // call endpoint for getting rrs feed
  // throws [ServerException] for all error codes
  Future<List<ArticleModel>> getArticlesFrom({required String url});
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  http.Client httpClient;
  ArticlesXMLParser articleXMLParser;
  ArticlesRemoteDataSourceImpl({
    required this.httpClient,
    required this.articleXMLParser,
  });

  @override
  Future<List<ArticleModel>> getArticlesFrom({required String url}) async {
    final result = await httpClient.get(Uri.parse(url));

    if (result.statusCode == 200) {
      String xml = result.body;
      final articles = articleXMLParser.getArticlesFromXML(xml);
      return articles;
    } else {
      throw ServerException();
    }
  }
}
