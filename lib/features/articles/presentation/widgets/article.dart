import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_app/injection_container.dart';

import '../../domain/entities/article.dart';
import '../bloc/articles_bloc.dart';
import '../pages/article_web_view.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({
    required Key? key,
    required this.article,
    required this.favorites,
  }) : super(key: key);

  final List<Article> favorites;
  final Article article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openArticle(context),
      child: _buildListTile(),
    );
  }

  void openArticle(BuildContext context) {
    Navigator.of(context)
        .pushNamed(WebViewPage.routeName, arguments: article.link);
  }

  AspectRatio? _getLeadingImgOrNull() {
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

  ListTile _buildListTile() {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 4),
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        article.title,
        maxLines: 3,
      ),
      leading: _getLeadingImgOrNull(),
      trailing: FavoriteButton(
        article: article,
        favorites: favorites,
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {required this.article, required this.favorites, super.key});
  final Article article;
  final List<Article> favorites;
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool init = true;
  bool isFavorite = false;

  @override
  void initState() {
    if (init) {
      init = false;
      isFavorite = widget.favorites.contains(widget.article);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        splashColor: Colors.transparent,
        onPressed: () => _toggleFavorites(widget.article, context),
        icon: _getFavoriteIcon());
  }

  Icon _getFavoriteIcon() {
    return isFavorite
        ? const Icon(
            Icons.star,
          )
        : const Icon(Icons.star_border);
  }

  void _toggleFavorites(Article article, BuildContext context) {
    setState(() {
      isFavorite = !isFavorite;
    });
    BlocProvider.of<ArticlesBloc>(context).add(TogleFavoritesEvent(article));
  }
}
