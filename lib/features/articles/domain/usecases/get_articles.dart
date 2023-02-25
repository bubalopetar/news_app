// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';

class GetArticles {
  final ArticlesRepository repository;
  GetArticles({
    required this.repository,
  });

  Future<Either<Failure, List<Article>>> execute({required String url}) async {
    return repository.getArticlesFrom(url: url);
  }
}
