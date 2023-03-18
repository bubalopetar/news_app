import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/toggle_favorites.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';
import 'package:news_app/features/articles/domain/usecases/get_favorites.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetArticlesUseCase>(),
  MockSpec<UrlConverter>(),
  MockSpec<ToggleFavoritesUseCase>(),
  MockSpec<GetFavoritesUseCase>()
])
import 'articles_block_test.mocks.dart';

void main() {
  late GetFavoritesUseCase getFavoritesUseCase;
  late ToggleFavoritesUseCase addToFavoritesUseCase;
  late GetArticlesUseCase getArticlesUseCase;
  late ArticlesBloc bloc;
  late UrlConverter converter;

  setUp(
    () {
      getFavoritesUseCase = MockGetFavoritesUseCase();
      getArticlesUseCase = MockGetArticlesUseCase();
      addToFavoritesUseCase = MockAddToFavoritesUseCase();
      converter = MockUrlConverter();
      getArticlesUseCase = MockGetArticlesUseCase();
      bloc = ArticlesBloc(
          getFavoritesUseCase: getFavoritesUseCase,
          getArticlesUseCase: getArticlesUseCase,
          addToFavoritesUseCase: addToFavoritesUseCase,
          urlConverter: converter);
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
          getFavoritesUseCase = MockGetFavoritesUseCase();
          getArticlesUseCase = MockGetArticlesUseCase();
          addToFavoritesUseCase = MockAddToFavoritesUseCase();
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              getFavoritesUseCase: getFavoritesUseCase,
              getArticlesUseCase: getArticlesUseCase,
              addToFavoritesUseCase: addToFavoritesUseCase,
              urlConverter: converter);
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
              const Loaded(
                  articles: articles, activeTabIndex: 0, favorites: []),
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
    () {
      setUp(
        () {
          getFavoritesUseCase = MockGetFavoritesUseCase();
          getArticlesUseCase = MockGetArticlesUseCase();
          addToFavoritesUseCase = MockAddToFavoritesUseCase();
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              getFavoritesUseCase: getFavoritesUseCase,
              getArticlesUseCase: getArticlesUseCase,
              addToFavoritesUseCase: addToFavoritesUseCase,
              urlConverter: converter);
        },
      );

      test(
        "should call repository and add new article to favorites",
        () async {
          final article = ArticleModel(
            title: "test title2",
            link: "test link2",
            description: "test desc2",
            img: "test img2",
            pubDate: DateTime.parse("2023-03-16T20:26:21.830257"),
            category: "test category2",
          );
          bloc.add(TogleFavoritesEvent(article));
          await untilCalled(
              addToFavoritesUseCase.call(params: CAParams(article: article)));

          verify(
              addToFavoritesUseCase.call(params: CAParams(article: article)));
        },
      );
    },
  );
}
