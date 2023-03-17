// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  Future<Either<Failure, bool>> setToFavorites(Article article) async {
    try {
      final result =
          await localDataSource.cacheArticle(article as ArticleModel);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Either<Failure, List<Article>?> getFavorites() {
    try {
      final result = localDataSource.getCachedArticles();
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
