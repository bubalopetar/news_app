// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:news_app/core/usecases/usecase.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';

import '../repositories/articles_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Article>, NoParams> {
  final ArticlesRepository repository;
  GetFavoritesUseCase({
    required this.repository,
  });

  @override
  call({required NoParams params}) {
    final result = repository.getFavorites();
    return result;
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
