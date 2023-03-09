import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_app/injection_container.dart';

import '../../domain/entities/article.dart';
import '../pages/article_web_view.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({
    Key? key,
    required this.article,
  }) : super(key: key);

  AspectRatio? _getLeading() {
    return article.img == ''
        ? null
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: article.img,
              cacheManager: serviceLocator.get<CacheManager>(),
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
  }

  final Article article;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(WebViewPage.routeName, arguments: article.link),
      child: Card(
        elevation: 5,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4),
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            article.title,
            maxLines: 3,
          ),
          leading: _getLeading(),
        ),
      ),
    );
  }
}
