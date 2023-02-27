import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:xml/xml.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  late ArticlesXMLParserImpl parser;
  String xml = fixture('articles.xml');

  group(
    'getArticlesFromXML',
    () {
      setUp(
        () {
          parser = ArticlesXMLParserImpl();
        },
      );
      test(
        'should return a list of articles from provided xml string',
        () {
          final result = parser.getArticlesFromXML(xml);

          expect(result.length, 3);
          expect(result.first, isA<ArticleModel>());
        },
      );

      test(
        'should throw a XmlParserException if xml string is empty',
        () {
          expect(() => parser.getArticlesFromXML(''),
              throwsA(isA<XmlParserException>()));
        },
      );
    },
  );
}
