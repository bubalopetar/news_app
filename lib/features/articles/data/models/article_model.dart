// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_app/features/articles/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required String title,
    required String link,
    String description = '',
    String img = '',
    String category = '',
    DateTime? pubDate,
  }) : super(
            link: link,
            title: title,
            description: description,
            category: category,
            img: img,
            pubDate: pubDate);
}
