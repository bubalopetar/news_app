// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/usecases/usecase.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';

import '../repositories/articles_repository.dart';

class SetArticleToFavoritesUseCase implements UseCase<void, CAParams> {
  final ArticlesRepository repository;
  SetArticleToFavoritesUseCase({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call({required CAParams params}) async {
    return await repository.setToFavorites(params.article);
  }
}

class CAParams extends Equatable {
  final ArticleModel article;
  const CAParams({
    required this.article,
  });

  @override
  List<Object> get props => [article];
}
