import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/core/utils/articles_xml_parser.dart';
import 'package:news_app/core/utils/url_converter.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:news_app/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:news_app/features/articles/domain/repositories/articles_repository.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/features/articles/domain/usecases/get_articles_from_url.dart';
import 'package:news_app/features/articles/presentation/bloc/articles_bloc.dart';

final serviceLocator = GetIt.instance;

// can also be "Future<void> init() async {} "
void init() {
  // features
  serviceLocator.registerFactory(() =>
      ArticlesBloc(usecase: serviceLocator(), urlConverter: serviceLocator()));

  // usecase
  serviceLocator.registerLazySingleton(
      () => GetArticlesUseCase(repository: serviceLocator()));

  // repository
  serviceLocator.registerLazySingleton<ArticlesRepository>(
      () => ArticlesRepositoryImpl(remoteDataSource: serviceLocator()));

  // data source
  serviceLocator.registerLazySingleton<ArticlesRemoteDataSource>(() =>
      ArticlesRemoteDataSourceImpl(
          httpClient: serviceLocator(), articleXMLParser: serviceLocator()));

  // core
  serviceLocator.registerLazySingleton(() => UrlConverter());
  serviceLocator
      .registerLazySingleton<ArticlesXMLParser>(() => ArticlesXMLParserImpl());

  // external
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerFactory<CacheManager>(() => CacheManager(
        Config(
          'some_key_for_cache',
          stalePeriod: const Duration(days: 1),
          maxNrOfCacheObjects: 1000,
        ),
      ));
}
