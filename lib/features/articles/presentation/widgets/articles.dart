import 'package:flutter/material.dart';
import 'package:news_app/features/articles/presentation/widgets/article.dart';

import '../../domain/entities/article.dart';

class Articles extends StatelessWidget {
  const Articles({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                Article article = articles[index];
                return ArticleWidget(article: article);
              },
            ),
          ),
        ],
      ),
    );
  }
}
