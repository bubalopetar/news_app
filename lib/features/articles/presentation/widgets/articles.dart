import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
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
    return Column(
      children: [
        Expanded(
          child: GroupedListView(
            useStickyGroupSeparators: true,
            order: GroupedListOrder.DESC,
            elements: articles,
            groupSeparatorBuilder: (String category) => Category(category),
            groupBy: (element) => element.category,
            itemBuilder: (context, Article article) {
              return ArticleWidget(article: article);
            },
          ),
        ),
      ],
    );
  }
}

class Category extends StatelessWidget {
  final Color tileColor = Colors.grey.withOpacity(0.5);
  final String category;
  Category(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 1),
            decoration: BoxDecoration(
                color: tileColor,
                border: Border.all(color: tileColor),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Text(
              category,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ))
      ],
    );
  }
}
