// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/usecases/usecase.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';

class GetArticles implements UseCase<List<Article>, Params> {
  final ArticlesRepository repository;
  GetArticles({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<Article>>> call({required Params params}) async {
    return repository.getArticlesFrom(url: params.url);
  }
}

class Params extends Equatable {
  final String url;
  const Params({
    required this.url,
  });

  @override
  List<Object> get props => [url];
}
