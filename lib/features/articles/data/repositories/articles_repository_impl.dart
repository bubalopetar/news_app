import 'package:news_app/core/error/exceptions.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';

class ArticleRepositoryImpl extends ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;

  ArticleRepositoryImpl({required this.remoteDataSource});
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
}
