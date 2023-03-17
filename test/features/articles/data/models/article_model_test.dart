import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  ArticleModel articleModel = ArticleModel(
    title: "test title",
    link: "test link",
    description: "test desc",
    img: "test img",
    pubDate: DateTime.parse("2023-03-16T19:26:21.830257"),
    category: "test category",
  );

  test(
    "ArticleModel should be of type Article",
    () {
      expect(articleModel, isA<Article>());
    },
  );
  group(
    "fromJson",
    () {
      test(
        "should return Article model from json string",
        () {
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('article.json'));

          final result = ArticleModel.fromJson(jsonMap);

          expect(result, articleModel);
        },
      );
    },
  );

  group(
    "toJson",
    () {
      test(
        "should return map containing proper data",
        () {
          final result = articleModel.toJson();
          final expectedMap = {
            "title": "test title",
            "link": "test link",
            "description": "test desc",
            "img": "test img",
            "pubDate": "2023-03-16T19:26:21.830257",
            "category": "test category"
          };
          expect(result, expectedMap);
          expect(fixture('article.json'), jsonEncode(result));
        },
      );
    },
  );
}
