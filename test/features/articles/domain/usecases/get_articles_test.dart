import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles.dart';

@GenerateNiceMocks([MockSpec<ArticlesRepository>()])
import 'get_articles_test.mocks.dart';

void main() {
  late GetArticles usecase;
  late MockArticlesRepository mockArticlesRepository;

  setUp(
    () {
      mockArticlesRepository = MockArticlesRepository();
      usecase = GetArticles(repository: mockArticlesRepository);
    },
  );
  const String tUrl = 'test';
  const List<Article> tArticles = [
    Article(title: 'first article', link: 'link1'),
    Article(title: 'second article', link: 'link2'),
    Article(title: 'third article', link: 'link3'),
  ];

  test(
    'should get a list od articles from provided url',
    () async {
      when(mockArticlesRepository.getArticlesFrom(url: tUrl))
          .thenAnswer((_) async => const Right(tArticles));

      final result = await usecase(params: const Params(url: tUrl));
      expect(result, const Right(tArticles));
      verify(mockArticlesRepository.getArticlesFrom(url: tUrl));
      verifyNoMoreInteractions(mockArticlesRepository);
    },
  );

  test(
    'should get a Failure if something went wrong',
    () async {
      when(mockArticlesRepository.getArticlesFrom(url: tUrl))
          .thenAnswer((_) async => Left(ServerFailure()));

      final result = await usecase(params: const Params(url: tUrl));
      expect(result, Left(ServerFailure()));
      verify(mockArticlesRepository.getArticlesFrom(url: tUrl));
      verifyNoMoreInteractions(mockArticlesRepository);
    },
  );
}
