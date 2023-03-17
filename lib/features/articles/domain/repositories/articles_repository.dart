import 'package:dartz/dartz.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> getArticlesFrom({required Uri url});
  Future<Either<Failure, bool>> setToFavorites(Article article);
  Either<Failure, List<Article>?> getFavorites();
}
