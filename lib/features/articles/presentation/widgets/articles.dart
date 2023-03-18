import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:news_app/features/articles/presentation/widgets/article.dart';

import '../../domain/entities/article.dart';

class Articles extends StatelessWidget {
  const Articles({
    Key? key,
    required this.articles,
    required this.favorites,
  }) : super(key: key);

  final List<Article> articles;
  final List<Article> favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GroupedListView(
            separator: Divider(
              color: Theme.of(context).primaryColor,
            ),
            useStickyGroupSeparators: true,
            order: GroupedListOrder.DESC,
            elements: articles,
            groupSeparatorBuilder: (String category) => Category(category),
            groupBy: (element) => element.category,
            itemBuilder: (context, Article article) {
              return ArticleWidget(
                key: ValueKey(article.link),
                article: article,
                favorites: favorites,
              );
            },
          ),
        ),
      ],
    );
  }
}

class Category extends StatelessWidget {
  final String category;
  const Category(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return category != ''
        ? Container(
            child: Row(children: <Widget>[
              Expanded(
                child: Divider(
                  color: Theme.of(context).primaryColor,
                  height: 36,
                ),
              ),
              Text(
                category,
                style: const TextStyle(fontSize: 18),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      height: 36,
                    )),
              ),
            ]),
          )
        : const SizedBox();
  }
}
