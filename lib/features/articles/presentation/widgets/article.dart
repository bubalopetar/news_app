import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_app/injection_container.dart';

import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 5),
      visualDensity: const VisualDensity(vertical: 4),
      title: Text(article.title),
      leading: article.img == ''
          ? null
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: article.img,
                cacheManager: serviceLocator.get<CacheManager>(),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
    );
  }
}
