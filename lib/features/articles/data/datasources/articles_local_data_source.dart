// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';

import '../../domain/entities/article.dart';

abstract class ArticlesLocalDataSource {
  Future<bool> cacheArticle(ArticleModel article);
  List<Article>? getCachedArticles();
}

class ArticlesLocalDataSourceImpl implements ArticlesLocalDataSource {
  SharedPreferences sharedPreferences;
  ArticlesLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<bool> cacheArticle(ArticleModel article) async {
    List? cachedArticles = getCachedArticles();
    if (cachedArticles == null) {
      cachedArticles = [article];
    } else {
      cachedArticles.insert(0, article);
    }

    cachedArticles = cachedArticles.map((e) => jsonEncode(e.toJson())).toList();
    await sharedPreferences.setStringList(
        'favorites', cachedArticles as List<String>);
    return true;
  }

  @override
  List<Article>? getCachedArticles() {
    final results = sharedPreferences.getStringList('favorites');
    if (results != null) {
      return results.map((e) => ArticleModel.fromJson(jsonDecode(e))).toList();
    }
    return null;
  }
}
