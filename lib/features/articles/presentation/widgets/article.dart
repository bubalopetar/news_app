import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_app/injection_container.dart';

import '../../domain/entities/article.dart';
import '../bloc/articles_bloc.dart';
import '../pages/article_web_view.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget({
    required Key? key,
    required this.article,
    required this.favorites,
  }) : super(key: key);

  final List<Article> favorites;
  final Article article;

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  bool init = true;
  bool isFavorite = true;

  @override
  void initState() {
    if (init) {
      init = false;
      isFavorite = widget.favorites.contains(widget.article);
    }
    super.initState();
  }

  void toggleFavorites(Article article, BuildContext context) {
    setState(() {
      isFavorite = !isFavorite;
    });

    BlocProvider.of<ArticlesBloc>(context).add(TogleFavoritesEvent(article));
  }

  AspectRatio? _getLeading() {
    return widget.article.img == ''
        ? null
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.article.img,
              cacheManager: serviceLocator.get<CacheManager>(),
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
  }

  Icon getFavoriteIcon() {
    if (isFavorite) {
      return const Icon(Icons.favorite);
    } else {
      return const Icon(Icons.favorite_border);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(WebViewPage.routeName, arguments: widget.article.link),
      child: Card(
        elevation: 5,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4),
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            widget.article.title,
            maxLines: 3,
          ),
          leading: _getLeading(),
          trailing: IconButton(
              onPressed: () => toggleFavorites(widget.article, context),
              icon: getFavoriteIcon()),
        ),
      ),
    );
  }
}
