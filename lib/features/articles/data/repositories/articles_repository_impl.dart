import 'package:dartz/dartz.dart';

import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';

import '../datasources/articles_local_data_source.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;
  final ArticlesLocalDataSource localDataSource;

  ArticlesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, List<ArticleModel>>> getArticlesFrom(
      {required Uri url}) async {
    try {
      final response = await remoteDataSource.getArticlesFrom(url: url);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorites(Article article) async {
    try {
      final result =
          await localDataSource.cacheOrRemoveArticle(article as ArticleModel);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  List<Article> getFavorites() {
    final result = localDataSource.getCachedArticles();
    return result;
  }
}
