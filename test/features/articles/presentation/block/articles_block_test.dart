import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/set_to_favorites.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetArticlesUseCase>(),
  MockSpec<UrlConverter>(),
  MockSpec<SetArticleToFavoritesUseCase>()
])
import 'articles_block_test.mocks.dart';

void main() {
  late SetArticleToFavoritesUseCase cacheArticleUseCase;
  late GetArticlesUseCase getArticlesUseCase;
  late ArticlesBloc bloc;
  late UrlConverter converter;

  setUp(
    () {
      converter = MockUrlConverter();
      getArticlesUseCase = MockGetArticlesUseCase();
      bloc = ArticlesBloc(usecase: getArticlesUseCase, urlConverter: converter);
    },
  );

  test('initial state should be [Empty()]', () {
    expect(bloc.state, isA<Empty>());
  });

  group(
    'GetArticlesFromUrlEvent',
    () {
      const String url = 'https://www.index.hr/rss';
      final uri = Uri.parse(url);
      const articles = [
        Article(title: 'test title', link: 'article link'),
        Article(title: 'test title2', link: 'article link2')
      ];

      setUp(
        () {
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              usecase: getArticlesUseCase, urlConverter: converter);
        },
      );

      void setUpConverterSuccess() {
        when(converter.toURI(url)).thenReturn(Right(uri));
      }

      void setUpUsecaseSucess() {
        when(getArticlesUseCase.call(params: Params(url: uri)))
            .thenAnswer((_) async => const Right(articles));
      }

      void addGetArticlesFromUrlEvent(String url) {
        bloc.add(GetArticlesFromUrlEvent(url: url, activeTabIndex: 0));
      }

      test(
        'should call UrlConverter.toURI() method',
        () async {
          setUpConverterSuccess();

          setUpUsecaseSucess();

          addGetArticlesFromUrlEvent(url);

          await untilCalled(converter.toURI(url));

          verify(converter.toURI(url));
        },
      );

      test('should emit [Error] when the provided link is empty', () async {
        when(converter.toURI('')).thenReturn(Left(InvalidUrlFailure()));

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              const Error(message: invalidUrlFailureMessage, activeTabIndex: 0),
            ]));

        addGetArticlesFromUrlEvent('');
      });

      test('should get data from usecase', () async {
        setUpConverterSuccess();

        setUpUsecaseSucess();

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              const Loading(activeTabIndex: 0),
              const Loaded(articles: articles, activeTabIndex: 0),
            ]));

        addGetArticlesFromUrlEvent(url);

        await untilCalled(getArticlesUseCase.call(params: Params(url: uri)));

        verify(getArticlesUseCase.call(params: Params(url: uri)));
      });

      test('should emit [ServerFailure] when returned from usecase', () async {
        setUpConverterSuccess();

        when(getArticlesUseCase.call(params: Params(url: uri)))
            .thenAnswer((_) async => Left(ServerFailure()));

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              const Loading(activeTabIndex: 0),
              const Error(message: serverFailureMessage, activeTabIndex: 0),
            ]));

        addGetArticlesFromUrlEvent(url);

        await untilCalled(getArticlesUseCase.call(params: Params(url: uri)));

        verify(getArticlesUseCase.call(params: Params(url: uri)));
      });
    },
  );

  group(
    "AddToFavoritesEvent",
    () {},
  );
}
