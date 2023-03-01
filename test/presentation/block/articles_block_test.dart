import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:news_app/core/error/failures.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/domain/entities/article.dart';
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';

@GenerateNiceMocks([MockSpec<GetArticlesUseCase>(), MockSpec<UrlConverter>()])
import 'articles_block_test.mocks.dart';

void main() {
  late MockGetArticles usecase;
  late ArticlesBloc bloc;
  late MockUrlConverter converter;

  setUp(
    () {
      converter = MockUrlConverter();
      usecase = MockGetArticles();
      bloc = ArticlesBloc(usecase: usecase, urlConverter: converter);
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
          usecase = MockGetArticles();
          bloc = ArticlesBloc(usecase: usecase, urlConverter: converter);
        },
      );

      void setUpConverterSuccess() {
        when(converter.toURI(url)).thenReturn(Right(uri));
      }

      void setUpUsecaseSucess() {
        when(usecase.call(params: Params(url: uri)))
            .thenAnswer((_) async => const Right(articles));
      }

      void addBlockEvent(String url) {
        bloc.add(GetArticlesFromUrlEvent(url: url));
      }

      test(
        'should call UrlConverter.toURI() method',
        () async {
          setUpConverterSuccess();

          setUpUsecaseSucess();

          addBlockEvent(url);

          await untilCalled(converter.toURI(url));

          verify(converter.toURI(url));
        },
      );

      test('should emit [Error] when the provided link is empty', () async {
        when(converter.toURI(any)).thenReturn(Left(InvalidUrlFailure()));

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              const Error(message: invalidUrlFailureMessage),
            ]));

        addBlockEvent('');
      });

      test('should get data from usecase', () async {
        setUpConverterSuccess();

        setUpUsecaseSucess();

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              Loading(),
              const Loaded(articles: articles),
            ]));

        addBlockEvent(url);

        await untilCalled(usecase.call(params: Params(url: uri)));

        verify(usecase.call(params: Params(url: uri)));
      });

      test('should emit [ServerFailure] when returned from usecase', () async {
        setUpConverterSuccess();

        when(usecase.call(params: Params(url: uri)))
            .thenAnswer((_) async => Left(ServerFailure()));

        expectLater(
            bloc.stream.asBroadcastStream(),
            emitsInOrder([
              Loading(),
              const Error(message: serverFailureMessage),
            ]));

        addBlockEvent(url);

        await untilCalled(usecase.call(params: Params(url: uri)));

        verify(usecase.call(params: Params(url: uri)));
      });
    },
  );
}
