import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';

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
  late ToggleFavoritesUseCase toggleFavoritesUseCase;
  late GetArticlesUseCase getArticlesUseCase;
  late ArticlesBloc bloc;
  late UrlConverter converter;
  const articles = [
    ArticleModel(title: 'test title', link: 'article link'),
    ArticleModel(title: 'test title2', link: 'article link2')
  ];
  setUp(
    () {
      getFavoritesUseCase = MockGetFavoritesUseCase();
      getArticlesUseCase = MockGetArticlesUseCase();
      toggleFavoritesUseCase = MockToggleFavoritesUseCase();
      converter = MockUrlConverter();
      getArticlesUseCase = MockGetArticlesUseCase();
      bloc = ArticlesBloc(
          getFavoritesUseCase: getFavoritesUseCase,
          getArticlesUseCase: getArticlesUseCase,
          toggleFavoritesUseCase: toggleFavoritesUseCase,
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

      setUp(
        () {
          getFavoritesUseCase = MockGetFavoritesUseCase();
          getArticlesUseCase = MockGetArticlesUseCase();
          toggleFavoritesUseCase = MockToggleFavoritesUseCase();
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              getFavoritesUseCase: getFavoritesUseCase,
              getArticlesUseCase: getArticlesUseCase,
              toggleFavoritesUseCase: toggleFavoritesUseCase,
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
        bloc.add(GetArticlesFromUrlEvent(url: url));
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
              const Loading(),
              const Loaded(articles: articles, favorites: []),
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
              const Loading(),
              const Error(message: serverFailureMessage),
            ]));

        addGetArticlesFromUrlEvent(url);

        await untilCalled(getArticlesUseCase.call(params: Params(url: uri)));

        verify(getArticlesUseCase.call(params: Params(url: uri)));
      });
    },
  );

  group(
    "ToggleFavoritesEvent",
    () {
      setUp(
        () {
          getFavoritesUseCase = MockGetFavoritesUseCase();
          getArticlesUseCase = MockGetArticlesUseCase();
          toggleFavoritesUseCase = MockToggleFavoritesUseCase();
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              getFavoritesUseCase: getFavoritesUseCase,
              getArticlesUseCase: getArticlesUseCase,
              toggleFavoritesUseCase: toggleFavoritesUseCase,
              urlConverter: converter);
        },
      );

      test(
        "should call usecase and add/remove article to/from favorites",
        () async {
          bloc.add(TogleFavoritesEvent(articles[0]));
          await untilCalled(toggleFavoritesUseCase.call(
              params: CAParams(article: articles[0])));

          verify(toggleFavoritesUseCase.call(
              params: CAParams(article: articles[0])));
        },
      );
    },
  );

  group(
    "GetFavoritesEvent",
    () {
      setUp(
        () {
          getFavoritesUseCase = MockGetFavoritesUseCase();
          getArticlesUseCase = MockGetArticlesUseCase();
          toggleFavoritesUseCase = MockToggleFavoritesUseCase();
          converter = MockUrlConverter();
          getArticlesUseCase = MockGetArticlesUseCase();
          bloc = ArticlesBloc(
              getFavoritesUseCase: getFavoritesUseCase,
              getArticlesUseCase: getArticlesUseCase,
              toggleFavoritesUseCase: toggleFavoritesUseCase,
              urlConverter: converter);
        },
      );

      test(
        "should call use case for fetching favorites",
        () async {
          bloc.add(const GetFavoritesEvent());
          await untilCalled(getFavoritesUseCase.syncCall(params: NoParams()));
          verify(getFavoritesUseCase.syncCall(params: NoParams()));
        },
      );

      test(
        "should emit Loaded state when favorites are read",
        () async {
          when(getFavoritesUseCase.syncCall(params: NoParams()))
              .thenReturn(articles);

          expectLater(
              bloc.stream.asBroadcastStream(),
              emitsInOrder(
                  [const Loaded(articles: articles, favorites: articles)]));
          bloc.add(const GetFavoritesEvent());
        },
      );

      test(
        "should emit Empty state when favorites are read",
        () async {
          when(getFavoritesUseCase.syncCall(params: NoParams())).thenReturn([]);

          expectLater(
              bloc.stream.asBroadcastStream(), emitsInOrder([const Empty()]));
          bloc.add(const GetFavoritesEvent());
        },
      );
    },
  );
}
