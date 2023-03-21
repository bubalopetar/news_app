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

  Divider buildDivider(BuildContext context) {
    return Divider(
      height: 0,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: GroupedListView(
        separator: buildDivider(context),
        useStickyGroupSeparators: true,
        order: GroupedListOrder.DESC,
        groupSeparatorBuilder: (String category) => Category(category),
        elements: articles,
        groupBy: (element) => element.category,
        itemBuilder: (context, Article article) {
          return ArticleWidget(
            key: ValueKey(article.link),
            article: article,
            favorites: favorites,
          );
        },
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String category;
  const Category(
    this.category, {
    super.key,
  });

  Widget buildDivider(BuildContext context, double left, double right) {
    return Expanded(
      child: Container(
          margin: EdgeInsets.only(left: left, right: right),
          child: Divider(
            color: Theme.of(context).primaryColor,
            height: 36,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return category != ''
        ? Container(
            color: Theme.of(context).backgroundColor,
            child: Row(children: <Widget>[
              buildDivider(context, 50, 20),
              Text(
                category,
                style: const TextStyle(fontSize: 18),
              ),
              buildDivider(context, 20, 50),
            ]),
          )
        : const SizedBox();
  }
}
